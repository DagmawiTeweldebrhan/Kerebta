import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../app.dart';
import 'success_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String maskedContact; // e.g. "+251 9** *** *34"
  final String username;
  const OtpVerificationScreen({Key? key, required this.maskedContact, required this.username}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> with TickerProviderStateMixin {
  bool isAmharic = false;
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  late AnimationController _spinePulseController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  int _resendSeconds = 59;
  Timer? _resendTimer;
  bool _isVerifying = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _spinePulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 400),
    )..repeat(reverse: true);

    _shakeController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _startResendTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startResendTimer() {
    _resendSeconds = 59;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _spinePulseController.dispose();
    _shakeController.dispose();
    _resendTimer?.cancel();
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();
  bool get _isComplete => _otpCode.length == 6;

  void _onDigitChanged(int index, String value) {
    if (_hasError) setState(() => _hasError = false);

    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});

    if (_isComplete) {
      _spinePulseController.stop();
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate verification

    // For demo: accept any 6-digit code
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => SuccessScreen(username: widget.username),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  void _triggerError() {
    setState(() => _hasError = true);
    _shakeController.forward(from: 0);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? const Color(0xFF1A1A1A) : AppColors.white;
    final subText = isLight ? const Color(0xFF1A1A1A).withOpacity(0.6) : AppColors.white.withOpacity(0.6);
    final gold = isLight ? const Color(0xFFB8860B) : const Color(0xFFD4AF37);
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final toggleBorder = isLight ? const Color(0xFF1A1A1A).withOpacity(0.2) : AppColors.white.withOpacity(0.3);
    final fieldBg = isLight ? Colors.white.withOpacity(0.3) : Colors.transparent;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Container(
        decoration: BoxDecoration(
          color: scaffoldBg,
          gradient: isLight ? const RadialGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF9F7F2)],
            center: Alignment.center, radius: 1.0,
          ) : null,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: toggleBorder, width: 0.5),
                        ),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 18.0),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => appThemeMode.value = isLight ? ThemeMode.dark : ThemeMode.light,
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(color: toggleBorder, width: 0.5),
                        ),
                        child: Icon(isLight ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: textColor, size: 18.0),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Logo
              Image.asset('assets/images/logo.png', height: 60.0),
              const SizedBox(height: 32.0),

              // Headline
              Text(
                isAmharic ? "ማንነትዎን ያረጋግጡ።" : "Verify your Identity.",
                style: GoogleFonts.poppins(color: textColor, fontSize: 28.0, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12.0),

              // Instruction
              Text(
                isAmharic ? "ኮድ ወደ ${widget.maskedContact} ተልኳል" : "We sent a code to ${widget.maskedContact}",
                style: GoogleFonts.poppins(color: subText, fontSize: 16.0, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),

              // OTP Boxes with Spine
              AnimatedBuilder(
                animation: Listenable.merge([_spinePulseController, _shakeAnimation]),
                builder: (context, _) {
                  final shakeOffset = _shakeController.isAnimating
                      ? _shakeAnimation.value * ((_shakeController.value * 10).toInt().isEven ? 1 : -1)
                      : 0.0;
                  return Transform.translate(
                    offset: Offset(shakeOffset, 0),
                    child: Column(
                      children: [
                        // Center Spine (pulses until complete)
                        if (!_isComplete) AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 0.8 + (_spinePulseController.value * 1.5),
                          height: 4.0,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          decoration: BoxDecoration(
                            color: gold.withOpacity(0.4 + _spinePulseController.value * 0.6),
                            borderRadius: BorderRadius.circular(2.0),
                            boxShadow: [
                              BoxShadow(color: gold.withOpacity(0.3), blurRadius: 8.0),
                            ],
                          ),
                        ),

                        // 6 OTP Digit Boxes
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (i) {
                              final hasValue = _controllers[i].text.isNotEmpty;
                              final borderColor = _hasError ? const Color(0xFFDA121A) : (hasValue ? gold : gold.withOpacity(0.3));
                              return Container(
                                width: 48.0, height: 56.0,
                                margin: EdgeInsets.only(right: i < 5 ? 10.0 : 0),
                                decoration: BoxDecoration(
                                  color: fieldBg,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(color: borderColor, width: hasValue ? 1.2 : 0.5),
                                  boxShadow: hasValue ? [
                                    BoxShadow(color: gold.withOpacity(0.15), blurRadius: 8.0),
                                  ] : null,
                                ),
                                child: TextField(
                                  controller: _controllers[i],
                                  focusNode: _focusNodes[i],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: GoogleFonts.poppins(color: textColor, fontSize: 22.0, fontWeight: FontWeight.w700),
                                  decoration: const InputDecoration(
                                    counterText: "",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                                  ),
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  onChanged: (v) => _onDigitChanged(i, v),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 32.0),

              // Verifying indicator
              if (_isVerifying)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: 24.0, height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0, color: gold),
                  ),
                ),

              // Resend
              if (!_isVerifying)
                GestureDetector(
                  onTap: _resendSeconds == 0 ? () {
                    _startResendTimer();
                    for (final c in _controllers) { c.clear(); }
                    setState(() => _hasError = false);
                    _focusNodes[0].requestFocus();
                    _spinePulseController.repeat(reverse: true);
                  } : null,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(fontSize: 15.0, fontWeight: FontWeight.w600, color: subText),
                      children: [
                        TextSpan(text: isAmharic ? "አልደረሰዎትም? " : "Didn't get it? "),
                        TextSpan(
                          text: _resendSeconds > 0
                              ? "${isAmharic ? 'እንደገና ይላኩ' : 'Resend in'} 00:${_resendSeconds.toString().padLeft(2, '0')}"
                              : (isAmharic ? "እንደገና ይላኩ" : "Resend"),
                          style: TextStyle(color: gold),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
