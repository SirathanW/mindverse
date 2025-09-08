import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../providers/navigation_provider.dart';
import '../../../widgets/gradient_text.dart';
import '../../../widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge),
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.only(bottom: AppSizes.paddingXXLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GradientText(
                    text: AppStrings.appTitle,
                    style: const TextStyle(
                      fontSize: AppSizes.fontXXLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Features List
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FeatureCard(
                    icon: Icons.camera_alt_rounded,
                    title: AppStrings.featureAuraScan,
                    onTap: () => _navigateToFeature(context, 1),
                  ),
                  FeatureCard(
                    icon: Icons.chat_rounded,
                    title: AppStrings.featureChatAI,
                    onTap: () => _navigateToFeature(context, 2),
                  ),
                  FeatureCard(
                    icon: Icons.star_rounded,
                    title: AppStrings.featureHoroscope,
                    onTap: () => _navigateToFeature(context, 3),
                  ),
                  FeatureCard(
                    icon: Icons.self_improvement_rounded,
                    title: AppStrings.featureMeditate,
                    onTap: () {},
                  ),
                  FeatureCard(
                    icon: Icons.blur_circular,
                    title: AppStrings.feature3DMeditate,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToFeature(BuildContext context, int index) {
    context.read<NavigationProvider>().changeTab(index);
  }
}

