import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TwinCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasGlow;
  final Color? glowColor;
  final Gradient? gradient;

  const TwinCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.hasGlow = false,
    this.glowColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBg = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);
    final effectiveBorder = borderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBg : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveBorder, width: 1),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: (glowColor ?? AppColors.primary).withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}
