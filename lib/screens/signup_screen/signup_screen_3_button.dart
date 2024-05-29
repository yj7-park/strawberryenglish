import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/signup_screen.dart';

class SignupScreen3Button extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final TextEditingController birthdayController;

  const SignupScreen3Button({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.birthdayController,
  });

  @override
  SignupScreen3ButtonState createState() => SignupScreen3ButtonState();
}

class SignupScreen3ButtonState extends State<SignupScreen3Button> {
  final scrollController = ScrollController();
  // String statusMessage = '';
  String errorMessage = '';

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
      padding: EdgeInsets.symmetric(horizontal: ((screenWidth - 500) / 2)),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                ),
                onPressed: registerUser,
                child: const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // TODO: 메일 주소 verification

  // TODO: 회원 가입 처리
  void registerUser() async {
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text.trim();
    final confirmPassword = widget.confirmPasswordController.text.trim();
    final name = widget.nameController.text.trim();
    final birthday = widget.birthdayController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        email.isEmpty ||
        birthday.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    // if (!_isVerified) {
    //   setState(() {
    //     errorMessage = 'Phone Number is not verified.';
    //   });
    //   return;
    // }

    if (password != confirmPassword) {
      setState(() {
        // errorMessage = 'Passwords do not match.';
        errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    if (!SignupScreen.check1 || !SignupScreen.check2) {
      setState(() {
        errorMessage = '필수 항목의 동의가 필요합니다.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to Firestore
      // await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userCredential.user!.uid)
      //     .set({
      //   'name': name,
      //   'email': email,
      //   // 'phoneNumber': phoneNumber,
      //   'lessonIDs': <String>[],
      //   'lessonInfo': <String, dynamic>{},
      // });

      // Navigate to calendar screen
      // Navigator.pushNamed(context, '/student_calendar');
      Navigator.pop(context);

      // setState(() {
      //   statusMessage = 'User registered successfully!';
      // });
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
