import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth_screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.all(16.0.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  OnboardingPage(
                    imagePath: 'assets/images/9583b279267d88e97aec880b38176f85.gif',
                    title: 'Explore Products',
                    description: 'Browse a wide range of products from your favorite categories.',
                  ),
                  OnboardingPage(
                    imagePath: 'assets/images/15547248.gif',
                    title: 'Best Deals',
                    description: 'Get amazing offers and discounts on top-selling items.',
                  ),
                  OnboardingPage(
                    imagePath: 'assets/images/17091786.gif',
                    title: 'Easy Payment',
                    description: 'Enjoy smooth and secure payment methods for hassle-free shopping.',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () async {
                    await _markOnboardingCompleted();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                  child: Text('Skip',style:TextStyle(
                    fontFamily:'Sevillana',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 25.sp
                  )),
                ),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: SwapEffect(
                    dotColor: Colors.grey,
                    activeDotColor: Colors.black,
                    dotHeight: 12.h,
                    dotWidth: 12.w,
                    spacing: 16.w,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (isLastPage) {
                      await _markOnboardingCompleted();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(isLastPage ? 'Done' : 'Next',style:TextStyle(
                    fontFamily:'Sevillana',
                      color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp

                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          height: 300.h,
        ),
        SizedBox(height: 24.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
