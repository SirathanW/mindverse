import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/feature_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: AppStrings.navProfile,
      icon: Icons.person_rounded,
      description: AppStrings.profileDesc,
    );
  }
}

