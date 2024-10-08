import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_1_login_info.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_input.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_3_button.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:strawberryenglish/widgets/my_header.dart';
import 'package:universal_html/js.dart' as js;

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  static bool check1 = false;
  static bool check2 = false;
  static bool check3 = false;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    SignupScreen.check1 = SignupScreen.check2 = SignupScreen.check3 = false;
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: MyMenuAppBar(),
        body: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.only(top: 93), // Make space for the AppBar
              children: [
                // 제목
                const MyHeader('회원가입'),
                // 커버 페이지
                SignupScreen1LoginInfo(
                  emailController: widget.emailController,
                  confirmPasswordController: widget.confirmPasswordController,
                  passwordController: widget.passwordController,
                ),
                SignupScreen2Input(
                  nameController: widget.nameController,
                  birthDateController: widget.birthDateController,
                ),
                SignupScreen3Button(
                  emailController: widget.emailController,
                  passwordController: widget.passwordController,
                  confirmPasswordController: widget.confirmPasswordController,
                  nameController: widget.nameController,
                  birthDateController: widget.birthDateController,
                ),
                // 회사정보
                // const CompanyInfo(),
              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: InkWell(
                onTap: () {
                  js.context
                      .callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
                },
                child: Image.asset(
                  'assets/images/kakao_talk.png',
                ),
              ),
            ),
            const Positioned(
              child: MyMenuAppBar(),
            ),
          ],
        ),
        drawer: const MyDrawer(),
      ),
    );
  }
}
