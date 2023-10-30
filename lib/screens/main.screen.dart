import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/accounts/accounts.screen.dart';
import 'package:fintracker/screens/categories/categories.screen.dart';
import 'package:fintracker/screens/home/home.screen.dart';
import 'package:fintracker/screens/onboard/onboard_screen.dart';
import 'package:fintracker/screens/settings/settings.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';

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
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state){
        AppCubit cubit = context.read<AppCubit>();
        if(cubit.state.currency == null || cubit.state.username == null){
          return OnboardScreen();
        }
        return  Scaffold(
          body: IndexedStack(
            index: _selected,
            children: const [
              HomeScreen(),
              AccountsScreen(),
              CategoriesScreen(),
              SettingsScreen()
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selected,
            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
              NavigationDestination(icon: Icon(Iconsax.wallet), label: "Accounts"),
              NavigationDestination(icon: Icon(Iconsax.category), label: "Categories"),
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