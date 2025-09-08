import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_sizes.dart';
import 'gradient_text.dart';

class FeatureScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;

  const FeatureScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientText(
              text: title,
              style: const TextStyle(
                fontSize: AppSizes.fontXXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXXLarge),
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingHuge),
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
                    blurRadius: AppSizes.shadowBlurXLarge,
                    offset: const Offset(0, AppSizes.shadowOffsetLarge),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: AppSizes.iconLarge,
                color: AppColors.textOnGold,
              ),
            ),
            const SizedBox(height: AppSizes.paddingXXLarge),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: AppSizes.fontLarge,
                color: AppColors.primaryGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

