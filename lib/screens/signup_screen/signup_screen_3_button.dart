import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/signup_screen.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class SignupScreen3Button extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController nameController;
  final TextEditingController birthDateController;

  const SignupScreen3Button({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.nameController,
    required this.birthDateController,
  });

  @override
  SignupScreen3ButtonState createState() => SignupScreen3ButtonState();
}

class SignupScreen3ButtonState extends State<SignupScreen3Button> {
  final scrollController = ScrollController();
  late StudentProvider studentProvider;

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
    studentProvider = Provider.of<StudentProvider>(context);
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
                onPressed: submit,
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
  void submit() async {
    final email = widget.emailController.text.trim();
    final password = widget.passwordController.text.trim();
    final confirmPassword = widget.confirmPasswordController.text.trim();
    final name = widget.nameController.text.trim();
    final birthDate = widget.birthDateController.text.trim();
    errorMessage = '';

    bool authCreated = false;

    // 필수 필드 값 확인
    if (name.isEmpty ||
        email.isEmpty ||
        birthDate.isEmpty ||
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

      authCreated = true;

      // Add user data to Firestore
      Student newStudent = Student(email: email);
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'adAgreed': SignupScreen.check3,
      });

      bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "회원가입이 완료되었습니다.",
        trueButton: "확인",
      );

      studentProvider.loginStudent(email, password);

      if (errorMessage.isEmpty) {
        if (studentProvider.student != null) {
          // Navigator.pushNamed(context, '/student_calendar');
          Navigator.of(context).pop(true);
          return; // student 로그인 성공 시 바로 종료
        }
      }

      if (confirm == true) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (authCreated) {
        await FirebaseAuth.instance.currentUser!.delete();
      }
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
