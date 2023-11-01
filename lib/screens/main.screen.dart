import 'package:fintracker/providers/app_provider.dart';
import 'package:fintracker/screens/accounts/accounts.screen.dart';
import 'package:fintracker/screens/categories/categories.screen.dart';
import 'package:fintracker/screens/home/home.screen.dart';
import 'package:fintracker/screens/onboard/onboard_screen.dart';
import 'package:fintracker/screens/payments/payments_screen.dart';
import 'package:fintracker/screens/settings/settings.screen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  int _selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _){
        if(provider.currency == null || provider.username == null){
          return OnboardScreen();
        }
        return  Scaffold(
          body: IndexedStack(
            index: _selected,
            children: const [
              HomeScreen(),
              PaymentsScreen(),
              AccountsScreen(),
              CategoriesScreen(),
              SettingsScreen()
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selected,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home_2), label: "Home"),
              NavigationDestination(icon: Icon(Iconsax.activity), label: "Payments"),
              NavigationDestination(icon: Icon(Iconsax.wallet), label: "Accounts"),
              NavigationDestination(icon: Icon(Iconsax.category_2), label: "Categories"),
              NavigationDestination(icon: Icon(Iconsax.setting), label: "Settings"),
            ],
            onDestinationSelected: (int selected){
              setState(() {
                _selected = selected;
              });
            },
          ),
        );
      },
    );

  }
}