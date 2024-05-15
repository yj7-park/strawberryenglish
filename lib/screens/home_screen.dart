import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/home_screen/company_info.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_1_cover.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_2_feedback.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_3_tutor.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_4_price.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_5_founder.dart';
import 'package:strawberryenglish/themes/theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: MyMenuAppBar(),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(top: 56), // Make space for the AppBar
              children: [
                // 커버 페이지
                const HomeScreen1Cover(),
                HomeScreen2Feedback(),
                const HomeScreen3Tutor(),
                const HomeScreen4Price(),
                const HomeScreen5Founder(),

                // 회사정보
                const CompanyInfo(),
              ],
            ),
            const Positioned(
              child: MyMenuAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}
