import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color>? gradientColors;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: gradientColors ?? AppColors.primaryGradient,
      ).createShader(bounds),
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}

