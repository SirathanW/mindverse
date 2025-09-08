import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import 'gradient_text.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        height: AppSizes.featureCardHeight,
        margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          gradient: const LinearGradient(
            colors: AppColors.surfaceGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: AppColors.primaryGold.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withOpacity(0.1),
              blurRadius: AppSizes.shadowBlurLarge,
              offset: const Offset(0, AppSizes.shadowOffsetMedium),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingXLarge),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: AppColors.primaryGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGold.withOpacity(0.4),
                      blurRadius: AppSizes.shadowBlurMedium,
                      offset: const Offset(0, AppSizes.shadowOffsetMedium),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: AppColors.textOnGold,
                  size: AppSizes.iconMedium,
                ),
              ),
              const SizedBox(width: AppSizes.paddingLarge),
              GradientText(
                text: title,
                style: const TextStyle(
                  fontSize: AppSizes.fontXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

