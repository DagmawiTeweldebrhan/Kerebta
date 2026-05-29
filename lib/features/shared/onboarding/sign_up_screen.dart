import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app.dart';
import '../../../services/auth_service.dart';
import 'otp_verification_screen.dart';

enum UserRole { fan, creator }

class SignUpScreen extends StatefulWidget {
  final UserRole role;
  const SignUpScreen({Key? key, required this.role}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  bool isAmharic = false;
  bool _agreeTerms = false;
  bool _showPassword = false;
  bool _usernameError = false;
  bool _socialLoading = false;
  bool _idUploading = false;
  bool _idUploaded = false;

  final AuthService _authService = AuthService();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _authController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bioController = TextEditingController();
  final _payoutController = TextEditingController();

  final _nameFocus = FocusNode();
  final _usernameFocus = FocusNode();
  final _authFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _bioFocus = FocusNode();

  String? _selectedCategory;
  DateTime? _birthdate;
  int _activeFieldIndex = -1;

  late AnimationController _spineGlowController;
  late AnimationController _buttonGlowController;

  List<String> _categories = [
    'Musician',
    'Filmmaker',
    'Photographer',
    'Poet',
    'Producer',
  ];
  List<String> _categoriesAm = [
    'ሙዚቀኛ',
    'ፊልም ሰሪ',
    'ፎቶግራፈር',
    'ገጣሚ',
    'ፕሮዲውሰር',
  ];

  @override
  void initState() {
    super.initState();
    _spineGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _buttonGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    for (final fn in [
      _nameFocus,
      _usernameFocus,
      _authFocus,
      _passwordFocus,
      _bioFocus
    ]) {
      fn.addListener(() => setState(() {
            _activeFieldIndex = [
              _nameFocus,
              _usernameFocus,
              _authFocus,
              _passwordFocus,
              _bioFocus
            ].indexOf(fn);
            if (!fn.hasFocus) _activeFieldIndex = -1;
          }));
    }
  }

  @override
  void dispose() {
    _spineGlowController.dispose();
    _buttonGlowController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _authController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _payoutController.dispose();
    _nameFocus.dispose();
    _usernameFocus.dispose();
    _authFocus.dispose();
    _passwordFocus.dispose();
    _bioFocus.dispose();
    super.dispose();
  }

  bool get _isAuthValid {
    final text = _authController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
    return emailRegex.hasMatch(text) || phoneRegex.hasMatch(text);
  }

  bool get _isFormValid {
    final base = _nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _isAuthValid &&
        _passwordController.text.isNotEmpty &&
        _birthdate != null &&
        _agreeTerms;
    if (widget.role == UserRole.creator) {
      return base && _selectedCategory != null;
    }
    return base;
  }

  int get _completedFields {
    int count = 0;
    if (_nameController.text.isNotEmpty) count++;
    if (_usernameController.text.isNotEmpty) count++;
    if (_isAuthValid) count++;
    if (_birthdate != null) count++;
    if (_passwordController.text.isNotEmpty) count++;
    if (widget.role == UserRole.creator && _selectedCategory != null) count++;
    if (_agreeTerms) count++;
    return count;
  }

  int get _totalFields => widget.role == UserRole.creator ? 7 : 6;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? const Color(0xFF1A1A1A) : AppColors.white;
    final subText = isLight
        ? const Color(0xFF1A1A1A).withOpacity(0.7)
        : AppColors.white.withOpacity(0.7);
    final gold = isLight ? const Color(0xFFB8860B) : const Color(0xFFD4AF37);
    final hint = isLight ? const Color(0xFF666666) : textColor.withOpacity(0.5);
    final fieldBg =
        isLight ? Colors.white.withOpacity(0.3) : Colors.transparent;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final toggleBorder = isLight
        ? const Color(0xFF1A1A1A).withOpacity(0.2)
        : AppColors.white.withOpacity(0.3);
    final progress = _totalFields > 0 ? _completedFields / _totalFields : 0.0;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Container(
        decoration: BoxDecoration(
          color: scaffoldBg,
          gradient: isLight
              ? const RadialGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF9F7F2)],
                  center: Alignment.center,
                  radius: 1.0,
                )
              : null,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // LEFT SPINE (Progress Tracker)
              Positioned(
                left: 24.0,
                top: 80.0,
                bottom: 0,
                child: AnimatedBuilder(
                  animation: _spineGlowController,
                  builder: (context, _) {
                    return SizedBox(
                      width: 4.0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final totalH = constraints.maxHeight;
                          final filledH = totalH * progress;
                          return Stack(
                            children: [
                              // Dormant spine
                              Container(
                                  width: 0.8,
                                  height: totalH,
                                  color: gold.withOpacity(0.15)),
                              // Active/glowing spine
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                width: _activeFieldIndex >= 0 ? 2.5 : 0.8,
                                height: filledH,
                                decoration: BoxDecoration(
                                  color: gold,
                                  borderRadius: BorderRadius.circular(2.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gold.withOpacity(0.3 +
                                          _spineGlowController.value * 0.3),
                                      blurRadius: 6.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // MAIN CONTENT
              Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: toggleBorder, width: 0.5),
                            ),
                            child: Icon(Icons.arrow_back_ios_new_rounded,
                                color: textColor, size: 18.0),
                          ),
                        ),
                        const Spacer(),
                        // Theme Toggle
                        GestureDetector(
                          onTap: () => appThemeMode.value =
                              isLight ? ThemeMode.dark : ThemeMode.light,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: toggleBorder, width: 0.5),
                            ),
                            child: Icon(
                                isLight
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: textColor,
                                size: 18.0),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        // Language Toggle
                        GestureDetector(
                          onTap: () => setState(() => isAmharic = !isAmharic),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(color: toggleBorder, width: 0.5),
                            ),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.language_rounded,
                                  color: textColor, size: 16.0),
                              const SizedBox(width: 6.0),
                              Text(isAmharic ? "EN" : "አማ",
                                  style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 24.0), // Left offset for spine
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo (scaled down)
                          Center(
                            child: Image.asset('assets/images/logo.png',
                                height: 45.0),
                          ),
                          const SizedBox(height: 24.0),

                          // Headline
                          Text(
                            widget.role == UserRole.creator
                                ? (isAmharic
                                    ? "ስቱዲዮዎን ይጀምሩ።"
                                    : "Start Your Studio.")
                                : (isAmharic
                                    ? "ማህበረሰቡን ይቀላቀሉ።"
                                    : "Join the Community."),
                            style: GoogleFonts.poppins(
                                color: textColor,
                                fontSize: 28.0,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 28.0),

                          // FULL NAME
                          _buildField(
                            index: 0,
                            focusNode: _nameFocus,
                            controller: _nameController,
                            hint: isAmharic
                                ? "ስምዎን ያስገቡ"
                                : "What should we call you?",
                            gold: gold,
                            hint2: hint,
                            textColor: textColor,
                            fieldBg: fieldBg,
                            isLight: isLight,
                          ),
                          const SizedBox(height: 16.0),

                          // USERNAME with @ prefix
                          _buildField(
                            index: 1,
                            focusNode: _usernameFocus,
                            controller: _usernameController,
                            hint: isAmharic ? "የተጠቃሚ ስም" : "Username",
                            gold: gold,
                            hint2: hint,
                            textColor: textColor,
                            fieldBg: fieldBg,
                            isLight: isLight,
                            prefix: Text("@",
                                style: GoogleFonts.poppins(
                                    color: gold,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 16.0),

                          // PHONE/EMAIL
                          _buildField(
                            index: 2,
                            focusNode: _authFocus,
                            controller: _authController,
                            hint: isAmharic
                                ? "ስልክ ቁጥር ወይም ኢሜይል"
                                : "Phone Number or Email",
                            gold: gold,
                            hint2: hint,
                            textColor: textColor,
                            fieldBg: fieldBg,
                            isLight: isLight,
                          ),
                          if (_authController.text.isNotEmpty && !_isAuthValid)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 16.0),
                              child: Text(
                                isAmharic
                                    ? "ትክክለኛ ስልክ ቁጥር ወይም ኢሜይል ያስገቡ"
                                    : "Enter a valid phone number or email",
                                style: GoogleFonts.poppins(
                                    color: Colors.redAccent, fontSize: 12.0),
                              ),
                            ),
                          const SizedBox(height: 16.0),

                          // BIRTHDATE PICKER
                          GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime(2000, 1, 1),
                                firstDate: DateTime(1940),
                                lastDate: DateTime.now(),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.fromSeed(
                                        seedColor: gold,
                                        brightness: isLight
                                            ? Brightness.light
                                            : Brightness.dark,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null)
                                setState(() => _birthdate = picked);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 18.0),
                              decoration: BoxDecoration(
                                color: fieldBg,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: gold, width: 0.5),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded,
                                      color: gold.withOpacity(0.7), size: 20.0),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    _birthdate != null
                                        ? "${_birthdate!.day}/${_birthdate!.month}/${_birthdate!.year}"
                                        : (isAmharic
                                            ? "የልደት ቀን"
                                            : "Date of Birth"),
                                    style: GoogleFonts.poppins(
                                      color:
                                          _birthdate != null ? textColor : hint,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // PASSWORD
                          _buildField(
                            index: 4,
                            focusNode: _passwordFocus,
                            controller: _passwordController,
                            hint: isAmharic ? "የይለፍ ቃል" : "Password",
                            gold: gold,
                            hint2: hint,
                            textColor: textColor,
                            fieldBg: fieldBg,
                            isLight: isLight,
                            obscure: !_showPassword,
                            suffix: IconButton(
                              icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: gold.withOpacity(0.7)),
                              onPressed: () => setState(
                                  () => _showPassword = !_showPassword),
                            ),
                          ),
                          const SizedBox(height: 6.0),
                          // PASSWORD STRENGTH DOTS
                          _buildPasswordStrengthDots(gold),
                          const SizedBox(height: 20.0),

                          // CREATOR-SPECIFIC FIELDS
                          if (widget.role == UserRole.creator) ...[
                            // Category Chips
                            Text(
                              isAmharic ? "ምድብ ይምረጡ" : "Select Category",
                              style: GoogleFonts.poppins(
                                  color: subText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12.0),
                            SizedBox(
                              height: 42.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _categories.length + 1,
                                itemBuilder: (context, i) {
                                  if (i == _categories.length) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: GestureDetector(
                                        onTap: _showAddCategoryDialog,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 18.0, vertical: 10.0),
                                          decoration: BoxDecoration(
                                            color: fieldBg,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            border: Border.all(
                                                color: gold.withOpacity(0.4),
                                                width: 0.5),
                                          ),
                                          child: Icon(Icons.add,
                                              color: textColor, size: 18),
                                        ),
                                      ),
                                    );
                                  }
                                  final selected =
                                      _selectedCategory == _categories[i];
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: i == 0 ? 0 : 10.0),
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _selectedCategory = _categories[i]),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 10.0),
                                        decoration: BoxDecoration(
                                          color: selected ? gold : fieldBg,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              color: gold.withOpacity(
                                                  selected ? 1.0 : 0.4),
                                              width: 0.5),
                                        ),
                                        child: Text(
                                          isAmharic
                                              ? _categoriesAm[i]
                                              : _categories[i],
                                          style: GoogleFonts.poppins(
                                            color: selected
                                                ? AppColors.black
                                                : textColor,
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),

                            // Verification Upload
                            GestureDetector(
                              onTap: () async {
                                if (_idUploaded) return;
                                setState(() => _idUploading = true);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                if (mounted) {
                                  setState(() {
                                    _idUploading = false;
                                    _idUploaded = true;
                                  });
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 28.0),
                                decoration: BoxDecoration(
                                  color: _idUploaded
                                      ? gold.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      color: _idUploaded
                                          ? gold
                                          : gold.withOpacity(0.5),
                                      width: 1.0,
                                      strokeAlign:
                                          BorderSide.strokeAlignInside),
                                ),
                                child: Column(
                                  children: [
                                    if (_idUploading)
                                      SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: CircularProgressIndicator(
                                              color: gold, strokeWidth: 2))
                                    else
                                      Icon(
                                          _idUploaded
                                              ? Icons.check_circle_outline
                                              : Icons.cloud_upload_outlined,
                                          color: _idUploaded
                                              ? gold
                                              : gold.withOpacity(0.6),
                                          size: 32.0),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      _idUploaded
                                          ? (isAmharic
                                              ? "መታወቂያ በተሳካ ሁኔታ ገብቷል"
                                              : "ID Uploaded Successfully")
                                          : (isAmharic
                                              ? "ለክፍያ ማረጋገጫ መታወቂያ ያስገቡ"
                                              : "Upload ID for Payout Verification"),
                                      style: GoogleFonts.poppins(
                                          color: _idUploaded ? gold : subText,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                    if (!_idUploaded) ...[
                                      const SizedBox(height: 4.0),
                                      Text(
                                        "Telebirr / CBE",
                                        style: GoogleFonts.poppins(
                                            color: gold.withOpacity(0.5),
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),

                            // PAYOUT ACCOUNT NUMBER
                            _buildField(
                              index: 5,
                              focusNode: FocusNode(),
                              controller: _payoutController,
                              hint: isAmharic
                                  ? "የክፍያ አካውንት (ለምሳሌ Telebirr)"
                                  : "Where should we send your payouts?",
                              gold: gold,
                              hint2: hint,
                              textColor: textColor,
                              fieldBg: fieldBg,
                              isLight: isLight,
                            ),
                            const SizedBox(height: 16.0),

                            // Bio / Link
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: fieldBg,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(color: gold, width: 0.5),
                                  ),
                                  child: TextField(
                                    controller: _bioController,
                                    focusNode: _bioFocus,
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: isAmharic
                                          ? "አጭር የግል መግለጫ ወይም ማህበራዊ ሊንክ"
                                          : "Short Bio or Social Link",
                                      hintStyle: GoogleFonts.poppins(
                                          color: hint,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.all(16.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24.0),
                          ],

                          // TERMS & CONSENT
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _agreeTerms = !_agreeTerms),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 22.0,
                                  height: 22.0,
                                  margin: const EdgeInsets.only(top: 2.0),
                                  decoration: BoxDecoration(
                                    color:
                                        _agreeTerms ? gold : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(color: gold, width: 1.0),
                                  ),
                                  child: _agreeTerms
                                      ? const Icon(Icons.check_rounded,
                                          size: 16.0, color: Colors.black)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  isAmharic
                                      ? "የቀረብታ ${widget.role == UserRole.creator ? 'ፈጣሪ' : 'አድናቂ'} አገልግሎት ውልን እቀበላለሁ።"
                                      : "I agree to the Kerebta ${widget.role == UserRole.creator ? 'Creator' : 'Fan'} Terms of Service.",
                                  style: GoogleFonts.poppins(
                                      color: subText,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28.0),

                          // CREATE ACCOUNT BUTTON
                          AnimatedBuilder(
                            animation: _buttonGlowController,
                            builder: (context, _) {
                              return Container(
                                width: double.infinity,
                                decoration: _isFormValid
                                    ? BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: gold.withOpacity(0.2 +
                                                _buttonGlowController.value *
                                                    0.15),
                                            blurRadius: 16.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      )
                                    : null,
                                child: ElevatedButton(
                                  onPressed: _isFormValid
                                      ? () {
                                          final masked = _authController
                                                      .text.length >
                                                  4
                                              ? '${_authController.text.substring(0, 4)}***${_authController.text.substring(_authController.text.length - 2)}'
                                              : _authController.text;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    OtpVerificationScreen(
                                                  maskedContact: masked,
                                                  username:
                                                      _usernameController.text,
                                                  isCreator: widget.role ==
                                                      UserRole.creator,
                                                ),
                                              ));
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: gold,
                                    disabledBackgroundColor:
                                        gold.withOpacity(0.3),
                                    foregroundColor: AppColors.black,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        isAmharic
                                            ? "አካውንት ይፍጠሩ"
                                            : "Create Account",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 20.0),

                          // Redirect
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: subText),
                                  children: [
                                    TextSpan(
                                        text: isAmharic
                                            ? "አካውንት አለዎት? "
                                            : "Already have an account? "),
                                    TextSpan(
                                        text: isAmharic ? "ይግቡ" : "Log In",
                                        style: TextStyle(color: gold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),

                          // SOCIAL AUTH ICONS
                          Center(
                            child: _socialLoading
                                ? SizedBox(
                                    width: 24.0,
                                    height: 24.0,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2.0, color: gold),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _handleSocialAuth(context, 'apple'),
                                        child: Icon(Icons.apple,
                                            color: textColor.withOpacity(0.5),
                                            size: 28.0),
                                      ),
                                      const SizedBox(width: 24.0),
                                      GestureDetector(
                                        onTap: () => _handleSocialAuth(
                                            context, 'google'),
                                        child: Icon(Icons.g_mobiledata_rounded,
                                            color: textColor.withOpacity(0.5),
                                            size: 34.0),
                                      ),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 40.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSocialAuth(BuildContext context, String provider) async {
    setState(() => _socialLoading = true);
    try {
      final result = provider == 'google'
          ? await _authService.signInWithGoogle()
          : await _authService.signInWithApple();

      if (result.user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${result.user!.email ?? 'User'}!'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
        // TODO: Navigate to home feed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Sign in failed: ${e.toString().split(']').last.trim()}'),
            backgroundColor: const Color(0xFFDA121A),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _socialLoading = false);
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final tc = TextEditingController();
    await showDialog(
        context: context,
        builder: (context) {
          final isLight = Theme.of(context).brightness == Brightness.light;
          final textColor = isLight ? const Color(0xFF1A1A1A) : AppColors.white;
          final gold =
              isLight ? const Color(0xFFB8860B) : const Color(0xFFD4AF37);
          return AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(isAmharic ? "አዲስ ምድብ ያክሉ" : "Add Custom Category",
                style: GoogleFonts.poppins(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
            content: TextField(
              controller: tc,
              style: GoogleFonts.poppins(color: textColor),
              decoration: InputDecoration(
                hintText: isAmharic ? "የምድቡ ስም" : "Category Name",
                hintStyle:
                    GoogleFonts.poppins(color: textColor.withOpacity(0.5)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: gold.withOpacity(0.5))),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide(color: gold)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(isAmharic ? "ሰርዝ" : "Cancel",
                    style:
                        GoogleFonts.poppins(color: textColor.withOpacity(0.7))),
              ),
              TextButton(
                onPressed: () {
                  if (tc.text.trim().isNotEmpty) {
                    setState(() {
                      _categories.add(tc.text.trim());
                      _categoriesAm.add(tc.text.trim());
                      _selectedCategory = tc.text.trim();
                    });
                    Navigator.pop(context);
                  }
                },
                child: Text(isAmharic ? "ያክሉ" : "Add",
                    style: GoogleFonts.poppins(
                        color: gold, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }

  Widget _buildField({
    required int index,
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hint,
    required Color gold,
    required Color hint2,
    required Color textColor,
    required Color fieldBg,
    required bool isLight,
    bool obscure = false,
    Widget? prefix,
    Widget? suffix,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: fieldBg,
            borderRadius: BorderRadius.circular(12.0),
            border:
                Border.all(color: gold, width: focusNode.hasFocus ? 1.2 : 0.5),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscure,
            style: GoogleFonts.poppins(
                color: textColor, fontSize: 18.0, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                  color: hint2, fontSize: 16.0, fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              prefixIcon: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                      child: prefix)
                  : null,
              prefixIconConstraints: prefix != null
                  ? const BoxConstraints(minWidth: 0, minHeight: 0)
                  : null,
              suffixIcon: suffix,
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthDots(Color gold) {
    final pwd = _passwordController.text;
    final hasLength = pwd.length >= 8;
    final hasNumber = pwd.contains(RegExp(r'[0-9]'));
    final hasSpecial = pwd.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    Widget dot(bool met) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: met ? gold : gold.withOpacity(0.2),
        ),
      );
    }

    if (pwd.isEmpty) return const SizedBox.shrink();
    return Row(
      children: [dot(hasLength), dot(hasNumber), dot(hasSpecial)],
    );
  }
}
