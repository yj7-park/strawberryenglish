import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_1_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_3_button.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class TrialScreen extends StatefulWidget {
  TrialScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirmPasswordController =
  //     TextEditingController();

  @override
  State<TrialScreen> createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {
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
              children: [
                // 제목
                MyHeader('체험하기'),
                // 커버 페이지
                SignupScreen2Input(
                  nameController: widget.nameController,
                  birthdayController: widget.birthdayController,
                  // confirmPasswordController: widget.confirmPasswordController,
                  // emailController: widget.emailController,
                  // passwordController: widget.birthdayController,
                ),
                TrialScreen1Input(),
                TrialScreen3Button(),
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
