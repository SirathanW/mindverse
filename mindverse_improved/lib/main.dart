import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_sizes.dart';
import 'providers/navigation_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/aura_scan/screens/aura_scan_screen.dart';
import 'features/chat_ai/screens/chat_ai_screen.dart';
import 'features/horoscope/screens/horoscope_screen.dart';
import 'features/profile/screens/profile_screen.dart';

void main() {
  runApp(const MindVerseApp());
}

class MindVerseApp extends StatelessWidget {
  const MindVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const List<Widget> _screens = [
    HomeScreen(),
    AuraScanScreen(),
    ChatAIScreen(),
    HoroscopeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: AppColors.radialGradient,
              ),
            ),
            child: _screens[navigationProvider.currentIndex],
          ),
          bottomNavigationBar: Container(
            height: AppSizes.bottomNavHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.backgroundGradient,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusMedium),
                topRight: Radius.circular(AppSizes.radiusMedium),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusMedium),
                topRight: Radius.circular(AppSizes.radiusMedium),
              ),
              child: BottomNavigationBar(
                currentIndex: navigationProvider.currentIndex,
                onTap: (index) {
                  navigationProvider.changeTab(index);
                  HapticFeedback.lightImpact();
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: AppColors.primaryGold,
                unselectedItemColor: AppColors.textSecondary,
                selectedFontSize: AppSizes.fontMedium,
                unselectedFontSize: AppSizes.fontSmall,
                elevation: 0,
                items: [
                  _buildNavItem(Icons.home_rounded, AppStrings.navHome, 0, navigationProvider.currentIndex),
                  _buildNavItem(Icons.camera_alt_rounded, AppStrings.navAuraScan, 1, navigationProvider.currentIndex),
                  _buildNavItem(Icons.chat_rounded, AppStrings.navChatAI, 2, navigationProvider.currentIndex),
                  _buildNavItem(Icons.star_rounded, AppStrings.navHoroscope, 3, navigationProvider.currentIndex),
                  _buildNavItem(Icons.person_rounded, AppStrings.navProfile, 4, navigationProvider.currentIndex),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, int index, int currentIndex) {
    final bool selected = currentIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(AppSizes.paddingSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
          gradient: selected
              ? const LinearGradient(
                  colors: AppColors.primaryGradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryGold.withOpacity(0.3),
                    blurRadius: AppSizes.shadowBlurSmall,
                    offset: const Offset(0, AppSizes.shadowOffsetSmall),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: AppSizes.iconSmall,
          color: selected ? AppColors.textOnGold : AppColors.textSecondary,
        ),
      ),
      label: label,
    );
  }
}

