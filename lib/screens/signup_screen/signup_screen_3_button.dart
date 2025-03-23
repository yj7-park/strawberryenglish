import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    // print(errorMessage);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ((screenWidth - 500) / 2)),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            Text(
              errorMessageTranslate(errorMessage),
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
                      color: Colors.black),
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

  // submit 처리
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
      UserCredential _ =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      authCreated = true;

      // Add user data to Firestore
      // Student newStudent = Student(email: email);
      await FirebaseFirestore.instance.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'birthDate': birthDate,
        'adAgreed': SignupScreen.check3,

        // TODO: 초기화 위치 확정 필요
        'level': '',
        'points': 0,
        'skypeId': '',
      });

      bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "회원가입 완료",
        body: [
          const Text(
            "회원가입이 완료되었습니다.",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // color: customTheme.colorScheme.primary,
            ),
          ),
        ],
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
        Navigator.of(context).pop(true);
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

String errorMessageTranslate(String e) {
  if (e.isEmpty) return e;
  if (RegExp(r'[가-힣]').hasMatch(e)) return e;

  const errorMessageTranslated = {
    "The email address is already in use by another account.":
        "이미 사용 중인 이메일 주소입니다.",
    "The email address is badly formatted.": "이메일 주소의 형식이 올바르지 않습니다.",
    "The password is invalid or the user does not have a password.":
        "비밀번호가 잘못 되었습니다.",
    "The password must be 6 characters long or more.": "비밀번호는 6글자 이상이어야 합니다.",
    "The user account has been disabled by an administrator.":
        "이 계정은 관리자에 의해 비활성화 되었습니다.",
    "There is no user record corresponding to this identifier. The user may have been deleted.":
        "등록되지 않은 이메일 주소입니다.",
    "The supplied auth credential is incorrect, malformed or has expired.":
        "아이디 또는 비밀번호가 잘못 되었습니다.",
    // different from .js file
    "Password should be at least 6 characters": "비밀번호는 6글자 이상이어야 합니다.",
  };
  const errorMessageTranslatedDefault = "시스템 오류가 발생했습니다. 관리자에게 문의하세요.";

  return errorMessageTranslated[e] ?? errorMessageTranslatedDefault;
}
