import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class SignupScreen2Input extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  // final TextEditingController emailController;
  // final TextEditingController passwordController;
  // final TextEditingController confirmPasswordController;

  SignupScreen2Input({
    super.key,
    required this.nameController,
    required this.birthdayController,
    // required this.emailController,
    // required this.passwordController,
    // required this.confirmPasswordController,
  });

  @override
  SignupScreen2InputState createState() => SignupScreen2InputState();
}

class SignupScreen2InputState extends State<SignupScreen2Input> {
  // String statusMessage = '';
  String errorMessage = '';

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;

  // final TextEditingController phoneNumberController =
  //     TextEditingController(text: '+82');
  // final TextEditingController verificationCodeController =
  //     TextEditingController();
  // String verificationId = '';
  // bool isSent = false;
  // bool isVerified = false;
  // String selectedCountryCode = '+82'; // 추가된 부분
  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: ((screenWidth - 500) / 2).clamp(20, double.nan),
      ),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.nameController,
              decoration: const InputDecoration(
                  labelText: '한글 이름', border: OutlineInputBorder()),
            ),
            const Text('* 실제 수강하는 사람의 이름을 적어주세요.'),
            const SizedBox(height: 20),
            // TODO: 생년월일
            TextFormField(
              controller: widget.birthdayController,
              decoration: const InputDecoration(
                labelText: '생년월일',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9-]"),
                ),
                // MaskedInputFormatter('####-##-##')
              ],
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }

  // TODO: 메일 주소 verification

  // TODO: 회원 가입 처리
//   void registerUser() async {
//     final name = widget.nameController.text.trim();
//     final email = widget.emailController.text.trim();
//     // final phoneNumber = phoneNumberController.text.trim();
//     final password = widget.passwordController.text.trim();
//     final confirmPassword = widget.confirmPasswordController.text.trim();
//     errorMessage = '';

//     // 필수 필드 값 확인
//     if (name.isEmpty ||
//         email.isEmpty ||
//         // phoneNumber.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty) {
//       setState(() {
//         // errorMessage = 'All fields are required.';
//         errorMessage = '모든 항목이 입력되어야 합니다.';
//       });
//       return;
//     }

//     if (password != confirmPassword) {
//       setState(() {
//         // errorMessage = 'Passwords do not match.';
//         errorMessage = '비밀번호가 일치하지 않습니다.';
//       });
//       return;
//     }

//     if (!check1 || !check2) {
//       setState(() {
//         errorMessage = '필수 항목의 동의가 필요합니다.';
//       });
//       return;
//     }

//     try {
//       Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
//       });
//     }
//   }
}
