import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/feature_screen.dart';

class AuraScanScreen extends StatelessWidget {
  const AuraScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: AppStrings.featureAuraScan,
      icon: Icons.camera_alt_rounded,
      description: AppStrings.auraScanDesc,
    );
  }
}

