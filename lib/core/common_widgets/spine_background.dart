import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SpineBackground extends StatefulWidget {
  final Widget child;
  const SpineBackground({Key? key, required this.child}) : super(key: key);

  @override
  _SpineBackgroundState createState() => _SpineBackgroundState();
}

class _SpineBackgroundState extends State<SpineBackground> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // Very slow breathing loop
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Razor-thin spine explicitly threaded in front of all elements
        Align(
          alignment: Alignment.center,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                return Container(
                  width: 0.8, // Razor-thin
                  color: AppColors.kerebtaGold.withOpacity(_opacityAnimation.value),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
