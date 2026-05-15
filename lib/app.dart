import 'package:flutter/material.dart';
import 'features/shared/onboarding/onboarding_carousel.dart';

final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.dark);

class KerebtaApp extends StatelessWidget {
  const KerebtaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Kerebta',
          themeMode: currentMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF9F7F2), // Warm Bone
            primaryColor: const Color(0xFFB8860B), // Darker Gold
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF080808), // Obsidian
            primaryColor: const Color(0xFFD4AF37), // Kerebta Gold
            useMaterial3: true,
          ),
          home: const OnboardingCarousel(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
