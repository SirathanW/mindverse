import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/feature_screen.dart';

class ChatAIScreen extends StatelessWidget {
  const ChatAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScreen(
      title: AppStrings.featureChatAI,
      icon: Icons.chat_rounded,
      description: AppStrings.chatAIDesc,
    );
  }
}

