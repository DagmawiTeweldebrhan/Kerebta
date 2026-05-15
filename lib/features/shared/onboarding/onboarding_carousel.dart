import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app.dart';

class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({Key? key}) : super(key: key);

  @override
  _OnboardingCarouselState createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> with TickerProviderStateMixin {
  bool isAmharic = false;
  bool showLogin = false;
  bool hasError = false;
  bool _isValid = false;
  bool _isPasswordVisible = false;
  
  final TextEditingController _authController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _entranceController;
  late Animation<Offset> _buttonSlideAnimation;
  
  late AnimationController _transitionController;
  late Animation<double> _landingFadeOut;
  late Animation<Offset> _landingSlideUp;
  late Animation<double> _loginFadeIn;
  late Animation<Offset> _loginSlideUp;

  late AnimationController _loginPulseController;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _buttonSlideAnimation = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    
    // Transition animations between landing and login state
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _landingFadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _landingSlideUp = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -0.3)).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _loginFadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );
    _loginSlideUp = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _transitionController, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)),
    );

    _loginPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    void validateForm() {
      setState(() {
        _isValid = _authController.text.isNotEmpty && _passwordController.text.isNotEmpty;
      });
    }

    _authController.addListener(validateForm);
    _passwordController.addListener(validateForm);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _transitionController.dispose();
    _loginPulseController.dispose();
    _authController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  void _triggerError() {
    setState(() {
      hasError = true;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          hasError = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color textColor = isLightMode ? const Color(0xFF1A1A1A) : AppColors.white;
    final Color subTextColor = isLightMode ? const Color(0xFF1A1A1A).withOpacity(0.7) : AppColors.white.withOpacity(0.7);
    final Color toggleBorderColor = isLightMode ? const Color(0xFF1A1A1A).withOpacity(0.2) : AppColors.white.withOpacity(0.3);
    
    // Light mode contrast enhancement for Gold and Hint
    final Color goldColor = isLightMode ? const Color(0xFFA67C00) : Theme.of(context).primaryColor;
    final Color hintColor = isLightMode ? const Color(0xFF666666) : textColor.withOpacity(0.5);
    final Color scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    
    // Transparent field background for Dark mode
    final Color fieldBackgroundColor = isLightMode ? Colors.white.withOpacity(0.3) : Colors.transparent;
    
    // Dynamic border color for the Anti-Gravity warning
    final Color inputBorderColor = hasError ? const Color(0xFFDA121A) : goldColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Container(
        decoration: BoxDecoration(
          color: scaffoldBg,
          gradient: isLightMode ? const RadialGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF9F7F2)],
            center: Alignment.center,
            radius: 1.0,
          ) : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Action Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Theme Toggle (Top Left)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            appThemeMode.value = isLightMode ? ThemeMode.dark : ThemeMode.light;
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: toggleBorderColor, width: 0.5),
                            ),
                            child: Icon(
                              isLightMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                              color: textColor,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Language Toggle (Top Right)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isAmharic = !isAmharic;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(color: toggleBorderColor, width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.language_rounded, color: textColor, size: 16.0),
                                const SizedBox(width: 6.0),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    isAmharic ? "English" : "አማርኛ",
                                    key: ValueKey(isAmharic),
                                    style: GoogleFonts.poppins(
                                      color: textColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(), // Reduced top push

              // Logo & Brand Name (Anchor - Does not move)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200.0, // Reduced height to pull text closer natively
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20.0), // Pulled up significantly closer
                    child: Text(
                      isAmharic ? "ቀረብታ" : "KEREBTA",
                      style: GoogleFonts.poppins(
                        color: goldColor,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w700, // Bolder
                        letterSpacing: 4.0, 
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16.0), // Pulled closer to the transition interface

              // Dynamic Transition Area (Typography -> Login)
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    // LANDING INTERFACE
                    AnimatedBuilder(
                      animation: _transitionController,
                      builder: (context, child) {
                        if (_transitionController.value > 0.5) return const SizedBox.shrink();
                        return FadeTransition(
                          opacity: _landingFadeOut,
                          child: SlideTransition(
                            position: _landingSlideUp,
                            child: IgnorePointer(
                              ignoring: showLogin,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: _buildLandingTypography(textColor, subTextColor),
                                  ),
                                  const Spacer(),
                                  SlideTransition(
                                    position: _buttonSlideAnimation,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 48.0, left: 16.0, right: 16.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              showLogin = true;
                                            });
                                            _transitionController.forward();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: goldColor,
                                            foregroundColor: AppColors.black,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(28.0),
                                            ),
                                          ),
                                          child: Text(
                                            isAmharic ? "ይጀምሩ" : "Get Started",
                                            style: GoogleFonts.poppins(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // LOGIN INTERFACE
                    AnimatedBuilder(
                      animation: _transitionController,
                      builder: (context, child) {
                        if (_transitionController.value < 0.5) return const SizedBox.shrink();
                        return FadeTransition(
                          opacity: _loginFadeIn,
                          child: SlideTransition(
                            position: _loginSlideUp,
                            child: IgnorePointer(
                              ignoring: !showLogin,
                              child: Column(
                                children: [
                                  const SizedBox(height: 16.0), // Pulled up tightly to logo
                                  
                                  // Login Inputs (Middle Center Secure Zone)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Unified Phone/Email Entry with blur depth
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              decoration: BoxDecoration(
                                                color: fieldBackgroundColor,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: inputBorderColor, width: 0.5), // Elegant 0.5px solid border
                                              ),
                                              child: TextField(
                                                controller: _authController,
                                                style: GoogleFonts.poppins(color: textColor, fontSize: 18.0, fontWeight: FontWeight.w600), // Bolder
                                                textAlign: TextAlign.left, // Left Aligned
                                                decoration: InputDecoration(
                                                  hintText: isAmharic ? "ስልክ ቁጥር ወይም ኢሜይል" : "Phone Number or Email",
                                                  hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 16.0, fontWeight: FontWeight.w700), // High Contrast Hint
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Left padding 16px
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        
                                        // Password Entry
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 300),
                                              decoration: BoxDecoration(
                                                color: fieldBackgroundColor,
                                                borderRadius: BorderRadius.circular(12.0),
                                                border: Border.all(color: inputBorderColor, width: 0.5),
                                              ),
                                              child: TextField(
                                                controller: _passwordController,
                                                obscureText: !_isPasswordVisible,
                                                style: GoogleFonts.poppins(color: textColor, fontSize: 18.0, fontWeight: FontWeight.w600), // Bolder
                                                textAlign: TextAlign.left, // Left Aligned
                                                decoration: InputDecoration(
                                                  hintText: isAmharic ? "የይለፍ ቃል" : "Password",
                                                  hintStyle: GoogleFonts.poppins(color: hintColor, fontSize: 16.0, fontWeight: FontWeight.w700), // High Contrast Hint
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Left padding 16px
                                                  suffixIcon: IconButton(
                                                    icon: Icon(
                                                      _isPasswordVisible ? Icons.visibility_off_rounded : Icons.visibility_rounded, 
                                                      color: goldColor.withOpacity(0.7)
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isPasswordVisible = !_isPasswordVisible;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 24.0),
                                        
                                        // Login Button & Biometrics Array
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            AnimatedBuilder(
                                              animation: _loginPulseController,
                                              builder: (context, child) {
                                                final double pulseOpacity = _isValid ? 0.8 + (_loginPulseController.value * 0.2) : 1.0;
                                                return Opacity(
                                                  opacity: pulseOpacity,
                                                  child: SizedBox(
                                                    width: 180.0,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        if (!_isValid) {
                                                          _triggerError(); // Anti-Gravity Warning
                                                        } else {
                                                          // Valid login action
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: goldColor,
                                                        foregroundColor: AppColors.black,
                                                        elevation: 0,
                                                        padding: const EdgeInsets.symmetric(vertical: 16.0), // Ample breathing room
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30.0),
                                                        ),
                                                      ),
                                                      child: AnimatedSwitcher(
                                                        duration: const Duration(milliseconds: 300),
                                                        child: Text(
                                                          isAmharic ? "ግባ" : "Login",
                                                          key: ValueKey(isAmharic),
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.w700, // Bolder
                                                            color: AppColors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                            ),
                                            const SizedBox(width: 16.0),
                                            // Refined Biometric Integration (Scaled Down)
                                            Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(color: goldColor.withOpacity(0.3), width: 1.0),
                                              ),
                                              child: Icon(Icons.fingerprint_rounded, color: goldColor.withOpacity(0.8), size: 22.0),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24.0), // Gap before the spine begins
                                  
                                  // The Sub-Spine & Footer System
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.topCenter,
                                      children: [
                                        // Trailing spine anchoring directly to the center below the Login button
                                        Container(
                                          width: 0.8,
                                          height: double.infinity,
                                          color: goldColor.withOpacity(0.6),
                                        ),
                                        
                                        // Content layer over the spine
                                        Column(
                                          children: [
                                            // Forgot Password (spine runs smoothly behind this text)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              color: scaffoldBg.withOpacity(0.95), // Blocks the line immediately behind the text
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 300),
                                                child: Text(
                                                  isAmharic ? "የይለፍ ቃል ረስተዋል?" : "Forgot Password?",
                                                  key: ValueKey(isAmharic),
                                                  style: GoogleFonts.poppins(
                                                    color: goldColor,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600, // Bolder, no underline
                                                  ),
                                                ),
                                              ),
                                            ),
                                            
                                            const Spacer(),
                                            
                                            // Sign-Up Footer (Bottom Center, bisected by spine)
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 24.0), // Pulled up
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Give text a tiny block to prevent clashing
                                                color: scaffoldBg.withOpacity(0.95), // Block the spine behind the text
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    AnimatedSwitcher(
                                                      duration: const Duration(milliseconds: 300),
                                                      child: Text(
                                                        isAmharic ? "አዲስ ነዎት? ይመዝገቡ እንደ" : "New to Kerebta? Join as a",
                                                        key: ValueKey(isAmharic),
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 18.0, // Larger
                                                          fontWeight: FontWeight.w600, // Bolder
                                                          color: subTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        AnimatedSwitcher(
                                                          duration: const Duration(milliseconds: 300),
                                                          child: Text(
                                                            isAmharic ? "አድናቂ" : "Fan",
                                                            key: ValueKey(isAmharic),
                                                            style: GoogleFonts.poppins(
                                                              color: goldColor,
                                                              fontSize: 22.0, // Larger
                                                              fontWeight: FontWeight.w700, // Bolder
                                                              decoration: TextDecoration.underline,
                                                              decorationColor: goldColor,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 16.0),
                                                        Container(
                                                          width: 1.5,
                                                          height: 12.0,
                                                          color: goldColor,
                                                        ),
                                                        const SizedBox(width: 16.0),
                                                        AnimatedSwitcher(
                                                          duration: const Duration(milliseconds: 300),
                                                          child: Text(
                                                            isAmharic ? "ፈጣሪ" : "Creator",
                                                            key: ValueKey(isAmharic),
                                                            style: GoogleFonts.poppins(
                                                              color: goldColor,
                                                              fontSize: 22.0, // Larger
                                                              fontWeight: FontWeight.w700, // Bolder
                                                              decoration: TextDecoration.underline,
                                                              decorationColor: goldColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandingTypography(Color textColor, Color subTextColor) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: isAmharic 
          ? TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 44.0,
                fontWeight: FontWeight.w800,
                height: 1.1,
                letterSpacing: -1.0,
              ),
              children: [
                TextSpan(text: "የ", style: TextStyle(color: textColor)),
                const TextSpan(text: "ኢት", style: TextStyle(color: Color(0xFF078930))),
                const TextSpan(text: "ዮ", style: TextStyle(color: Color(0xFFFCDD09))),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text("ጵ", style: GoogleFonts.poppins(color: const Color(0xFFFCDD09), fontSize: 44.0, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.0)),
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                      )
                    ],
                  )
                ),
                const TextSpan(text: "ያ", style: TextStyle(color: Color(0xFFDA121A))),
                TextSpan(text: " ምርጥ.\nመጀመሪያ", style: TextStyle(color: textColor)),
              ],
            )
          : TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 44.0,
                fontWeight: FontWeight.w800, 
                height: 1.1,
                letterSpacing: -1.0,
              ),
              children: [
                TextSpan(text: "The Best of\n", style: TextStyle(color: textColor)),
                const TextSpan(text: "ETH", style: TextStyle(color: Color(0xFF078930))),
                const TextSpan(text: "I", style: TextStyle(color: Color(0xFFFCDD09))),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text("O", style: GoogleFonts.poppins(color: const Color(0xFFFCDD09), fontSize: 44.0, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -1.0)),
                      Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
                      )
                    ],
                  )
                ),
                const TextSpan(text: "P", style: TextStyle(color: Color(0xFFFCDD09))),
                const TextSpan(text: "IA", style: TextStyle(color: Color(0xFFDA121A))),
                TextSpan(text: ". First", style: TextStyle(color: textColor)),
              ],
            ),
        ),
        const SizedBox(height: 20.0),
        
        Text(
          isAmharic 
            ? "ከሚወዱት አርቲስት/ፈጣሪ ጋር ይበልጥ ይቅረቡ።"
            : "Get closer to your favorite artist/creator.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: subTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w700, // bolder
          ),
        ),
      ],
    );
  }
}
