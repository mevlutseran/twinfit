import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum SfrRating { low, medium, high, elite }

class TwinBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool isAiBadge;
  final EdgeInsetsGeometry padding;

  const TwinBadge({
    super.key,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.isAiBadge = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  factory TwinBadge.ai({String label = 'TWINFIT AI'}) {
    return TwinBadge(
      label: label,
      icon: Icons.auto_awesome,
      isAiBadge: true,
    );
  }

  factory TwinBadge.sfr(String rating) {
    Color bg;
    Color fg;
    Color border;
    String text;

    switch (rating.toLowerCase()) {
      case 'elite':
        bg = AppColors.hypertrophyGold.withValues(alpha: 0.15);
        fg = AppColors.hypertrophyGold;
        border = AppColors.hypertrophyGold.withValues(alpha: 0.4);
        text = 'SFR: ELİT (MAX)';
        break;
      case 'high':
        bg = AppColors.primary.withValues(alpha: 0.15);
        fg = AppColors.primary;
        border = AppColors.primary.withValues(alpha: 0.4);
        text = 'SFR: YÜKSEK';
        break;
      case 'medium':
        bg = AppColors.info.withValues(alpha: 0.15);
        fg = AppColors.info;
        border = AppColors.info.withValues(alpha: 0.4);
        text = 'SFR: ORTA';
        break;
      default:
        bg = Colors.grey.withValues(alpha: 0.15);
        fg = Colors.grey;
        border = Colors.grey.withValues(alpha: 0.4);
        text = 'SFR: DÜŞÜK';
    }

    return TwinBadge(
      label: text,
      backgroundColor: bg,
      textColor: fg,
      borderColor: border,
    );
  }

  factory TwinBadge.cns(int score) {
    Color bg;
    Color fg;
    Color border;

    if (score >= 8) {
      bg = AppColors.heartRed.withValues(alpha: 0.15);
      fg = AppColors.heartRed;
      border = AppColors.heartRed.withValues(alpha: 0.4);
    } else if (score >= 5) {
      bg = AppColors.energyOrange.withValues(alpha: 0.15);
      fg = AppColors.energyOrange;
      border = AppColors.energyOrange.withValues(alpha: 0.4);
    } else {
      bg = AppColors.primary.withValues(alpha: 0.15);
      fg = AppColors.primary;
      border = AppColors.primary.withValues(alpha: 0.4);
    }

    return TwinBadge(
      label: 'CNS YÜKÜ: $score/10',
      icon: Icons.bolt,
      backgroundColor: bg,
      textColor: fg,
      borderColor: border,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAiBadge) {
      return Container(
        padding: padding,
        decoration: BoxDecoration(
          gradient: AppColors.aiBadgeGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: Colors.white),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor ?? AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor ?? AppColors.primary),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor ?? AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
