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

class _OnboardingCarouselState extends State<OnboardingCarousel> with SingleTickerProviderStateMixin {
  bool isAmharic = false;
  late AnimationController _entranceController;
  late Animation<Offset> _buttonSlideAnimation;

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

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color textColor = isLightMode ? const Color(0xFF080808) : AppColors.white;
    final Color subTextColor = isLightMode ? const Color(0xFF080808).withOpacity(0.7) : AppColors.white.withOpacity(0.7);
    final Color toggleBorderColor = isLightMode ? const Color(0xFF080808).withOpacity(0.2) : AppColors.white.withOpacity(0.3);
    
    final Color bgColor = isLightMode ? const Color(0xFFFAFAFA) : const Color(0xFF080808);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [

          SafeArea(
            child: Column(
              children: [
                // Top Action Bar (Theme Switch & Language Toggle)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dynamic Theme Toggle
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
                        
                        const SizedBox(width: 12.0),
                        
                        // Glassmorphic Language Toggle
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
                                    Icon(Icons.language_rounded, color: textColor, size: 16.0), // Globe icon
                                    const SizedBox(width: 6.0),
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 300),
                                      child: Text(
                                        isAmharic ? "English" : "አማርኛ",
                                        key: ValueKey(isAmharic),
                                        style: GoogleFonts.poppins(
                                          color: textColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w500,
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
                ),

                const Spacer(flex: 1),

                // Logo (Bigger & much closer to text)
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 180.0, // Massively increased size
                  ),
                ),

                const SizedBox(height: 12.0), // Pulled extremely close to the text

                // Floating Free Typography (Bigger text)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: isAmharic 
                        ? TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 44.0, // Increased size
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
                              fontSize: 44.0, // Increased size
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
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(flex: 1),

                // Refined Primary CTA with 16px horizontal padding
                SlideTransition(
                  position: _buttonSlideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 48.0, left: 16.0, right: 16.0), // 16px horizontal padding
                    child: SizedBox(
                      width: double.infinity, // Spans entire width minus the 16px horizontal padding
                      height: 56.0,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kerebtaGold,
                          foregroundColor: AppColors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            isAmharic ? "ይጀምሩ" : "Get Started",
                            key: ValueKey(isAmharic),
                            style: GoogleFonts.poppins(
                              fontSize: 16.0, // Refined font size
                              fontWeight: FontWeight.w600, // Refined font weight
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
