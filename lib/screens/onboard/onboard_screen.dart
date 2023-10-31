import 'package:fintracker/screens/onboard/widgets/landing.dart';
import 'package:fintracker/screens/onboard/widgets/profile.dart';
import 'package:flutter/material.dart';

class OnboardScreen extends StatelessWidget {
  OnboardScreen({super.key});
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          LandingPage(onGetStarted: (){
            _pageController.animateToPage(1,duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
          },),
          ProfileWidget(),
        ],
      ),
    );
  }
}
