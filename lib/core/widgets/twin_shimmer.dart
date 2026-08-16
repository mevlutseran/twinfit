import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TwinShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeBorder? shapeBorder;

  const TwinShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    this.shapeBorder,
  });

  const TwinShimmer.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shapeBorder = const CircleBorder();

  @override
  State<TwinShimmer> createState() => _TwinShimmerState();
}

class _TwinShimmerState extends State<TwinShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final highlightColor = isDark ? AppColors.darkSurfaceElevated : AppColors.lightSurfaceElevated;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.shapeBorder == null ? BorderRadius.circular(widget.borderRadius) : null,
            shape: widget.shapeBorder is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
