import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../fan/pulse/home_feed_page.dart';

class SuccessScreen extends StatefulWidget {
  final String username;
  const SuccessScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with TickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late AnimationController _textController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1800),
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.3, end: 3.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 0.6).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_expandController);
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 60),
    ]).animate(_expandController);

    _textController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 800),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurveTween(curve: Curves.easeOut).animate(_textController),
    );
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurveTween(curve: Curves.easeOut).animate(_textController),
    );

    _expandController.forward().then((_) {
      setState(() => _showText = true);
      _textController.forward();
    });

    // Auto-navigate to home after 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeFeedPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _expandController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final textColor = isLight ? const Color(0xFF1A1A1A) : AppColors.white;
    final gold = isLight ? const Color(0xFFB8860B) : const Color(0xFFD4AF37);
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: scaffoldBg,
          gradient: isLight ? const RadialGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF9F7F2)],
            center: Alignment.center, radius: 1.0,
          ) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedBuilder(
              animation: _expandController,
              builder: (context, _) {
                return Opacity(
                  opacity: _logoOpacity.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Image.asset('assets/images/logo.png', height: 120.0),
                  ),
                );
              },
            ),

            const SizedBox(height: 48.0),

            // Welcome text
            if (_showText) ...[
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      Text(
                        "Welcome to the Inner Circle,",
                        style: GoogleFonts.poppins(
                          color: textColor.withOpacity(0.7),
                          fontSize: 18.0, fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        "@${widget.username}",
                        style: GoogleFonts.poppins(
                          color: gold,
                          fontSize: 28.0, fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Subtle gold divider
                      Container(width: 40.0, height: 2.0, decoration: BoxDecoration(
                        color: gold.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(1.0),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
