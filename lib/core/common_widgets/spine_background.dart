import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SpineBackground extends StatefulWidget {
  final Widget child;
  final Color? spineColorOverride;
  const SpineBackground({Key? key, required this.child, this.spineColorOverride}) : super(key: key);

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
        // Razor-thin spine explicitly placed BEHIND the UI
        Align(
          alignment: Alignment.center,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _opacityAnimation,
              builder: (context, child) {
                final bool isLightMode = Theme.of(context).brightness == Brightness.light;
                final Color defaultGold = isLightMode ? const Color(0xFFB8860B) : AppColors.kerebtaGold;
                final Color activeColor = widget.spineColorOverride ?? defaultGold;
                
                return Container(
                  width: 0.8, // Razor-thin
                  color: activeColor.withOpacity(widget.spineColorOverride != null ? 1.0 : _opacityAnimation.value),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
