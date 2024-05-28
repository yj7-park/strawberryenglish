import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/introduction_screen/introduction_screen_1_text.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_5_founder.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: MyMenuAppBar(),
        body: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.only(top: 56), // Make space for the AppBar
              children: const [
                // 커버 페이지
                MyHeader('뭐가 달라?'),
                HomeScreen5Founder(title: ''),
                IntroductionScreen1Text(),

                // 회사정보
                CompanyInfo(),
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
