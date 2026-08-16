import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum TwinButtonVariant { primary, secondary, outline, ghost, danger }

class TwinButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TwinButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const TwinButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = TwinButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 52,
    this.borderRadius = 14,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buttonChild = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(_getTextColor(isDark)),
            ),
          ),
          const SizedBox(width: 10),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: 18, color: _getTextColor(isDark)),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            color: _getTextColor(isDark),
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        if (!isLoading && trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18, color: _getTextColor(isDark)),
        ],
      ],
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
            decoration: _getBoxDecoration(isDark),
            child: buttonChild,
          ),
        ),
      ),
    );
  }

  Color _getTextColor(bool isDark) {
    switch (variant) {
      case TwinButtonVariant.primary:
        return const Color(0xFF07090C); // High contrast dark text on neon
      case TwinButtonVariant.secondary:
        return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
      case TwinButtonVariant.outline:
      case TwinButtonVariant.ghost:
        return isDark ? AppColors.primary : const Color(0xFF00A362);
      case TwinButtonVariant.danger:
        return Colors.white;
    }
  }

  BoxDecoration _getBoxDecoration(bool isDark) {
    switch (variant) {
      case TwinButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryGlow,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        );
      case TwinButtonVariant.secondary:
        return BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        );
      case TwinButtonVariant.outline:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: isDark ? AppColors.primary.withValues(alpha: 0.5) : const Color(0xFF00A362).withValues(alpha: 0.5),
            width: 1.5,
          ),
        );
      case TwinButtonVariant.ghost:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case TwinButtonVariant.danger:
        return BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        );
    }
  }
}
