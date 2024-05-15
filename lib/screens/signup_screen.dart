import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_1_input.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                SignUpScreen1Input(),
                // 회사정보
                // const CompanyInfo(),
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
