import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/feature_screen.dart';

class HoroscopeScreen extends StatelessWidget {
  const HoroscopeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: AppStrings.featureHoroscope,
      icon: Icons.star_rounded,
      description: AppStrings.horoscopeDesc,
    );
  }
}

