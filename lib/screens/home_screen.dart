import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_1_cover.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_2_feedback.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_3_tutor.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_4_price.dart';
import 'package:strawberryenglish/themes/theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        appBar: MyMenuAppBar(),
        body: ListView(
          children: [
            // 커버 페이지
            const HomeScreen1Cover(),
            HomeScreen2Feedback(),
            const HomeScreen3Tutor(),
            const HomeScreen4Price()
            // 다른 내용들을 추가하세요.
          ],
        ),
      ),
    );
  }
}
