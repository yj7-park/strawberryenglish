// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'dart:js' as js;
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrialScreen1Input extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController dayController;
  final TextEditingController timeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;

  const TrialScreen1Input({
    super.key,
    required this.phoneNumberController,
    required this.dayController,
    required this.timeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
  });

  @override
  TrialScreen1InputState createState() => TrialScreen1InputState();
}

class TrialScreen1InputState extends State<TrialScreen1Input> {
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
              controller: widget.phoneNumberController,
              decoration: const InputDecoration(
                labelText: '휴대폰번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9]"),
                ),
              ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.countryController,
              decoration: const InputDecoration(
                labelText: '거주 국가',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.dayController,
              decoration: const InputDecoration(
                labelText: '희망 수업 요일',
                hintText: 'ex) 월, 수, 금',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const Text('* 희망 수업 요일을 여러 개 입력해 주시면 더 빠르게 수업이 확정됩니다.'),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.timeController,
              decoration: const InputDecoration(
                labelText: '희망 수업 시간',
                hintText: 'ex) 오전 10시~11시, 오후 6시~8시',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const Text('* 모든 시간은 한국 시간을 기준으로 입력해 주세요.'),
            const Text('* 희망 수업 시간을 여러 개 입력해 주시면 더 빠르게 수업이 확정됩니다.'),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.skypeIdController,
              decoration: const InputDecoration(
                labelText: 'Skype 이름',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const Text('* Skype를 이용하여 수업이 진행됩니다.'),
            InkWell(
              child: const Text(
                '▶ Skype 다운로드',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onTap: () {
                js.context.callMethod('open',
                    ['https://skype.daesung.com/download/downloadMain.asp']);
              },
            ),
            InkWell(
              child: const Text(
                '▶ Skype 이름 확인',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onTap: () {
                js.context.callMethod('open',
                    ['https://www.skybel.co.kr/sub/sugang_skype_id.php']);
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.studyPurposeController,
              decoration: const InputDecoration(
                labelText: '영어 공부 목적',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.referralSourceController,
              decoration: const InputDecoration(
                labelText: '딸기영어를 알게된 경로',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }

  // void sendVerificationCode() async {
  //   final phoneNumber = phoneNumberController.text.trim();
  //   errorMessage = '';

  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         FirebaseAuth.instance.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         setState(() {
  //           errorMessage = 'Error: $e';
  //         });
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         setState(() {
  //           verificationId = verificationId;
  //           statusMessage = 'Verification code sent!';
  //           isSent = true;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         setState(() {
  //           verificationId = verificationId;
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error: $e';
  //     });
  //   }
  // }

  // void checkVerificationCode() async {
  //   final verificationCode = verificationCodeController.text.trim();
  //   errorMessage = '';

  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: verificationCode,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     setState(() {
  //       statusMessage = 'Phone number verified!';
  //       isVerified = true;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error: $e';
  //     });
  //   }
  // }

// TODO: 정보 등록 처리
  // void registerUser() async {
  //   final name = widget.nameController.text.trim();
  //   final email = widget.phoneNumberController.text.trim();
  //   // final phoneNumber = phoneNumberController.text.trim();
  //   final password = widget.dayController.text.trim();
  //   final confirmPassword = widget.timeController.text.trim();
  //   errorMessage = '';

  //   // 필수 필드 값 확인
  //   if (name.isEmpty ||
  //       email.isEmpty ||
  //       // phoneNumber.isEmpty ||
  //       password.isEmpty ||
  //       confirmPassword.isEmpty) {
  //     setState(() {
  //       // errorMessage = 'All fields are required.';
  //       errorMessage = '모든 항목이 입력되어야 합니다.';
  //     });
  //     return;
  //   }

  //   // if (!_isVerified) {
  //   //   setState(() {
  //   //     errorMessage = 'Phone Number is not verified.';
  //   //   });
  //   //   return;
  //   // }

  //   try {
  //     // UserCredential userCredential =
  //     //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //     //   email: email,
  //     //   password: password,
  //     // );

  //     // // Add user data to Firestore
  //     // await FirebaseFirestore.instance
  //     //     .collection('users')
  //     //     .doc(userCredential.user!.uid)
  //     //     .set({
  //     //   'name': name,
  //     //   'email': email,
  //     //   // 'phoneNumber': phoneNumber,
  //     //   'lessonIDs': <String>[],
  //     //   'lessonInfo': <String, dynamic>{},
  //     // });

  //     // Navigate to calendar screen
  //     // Navigator.pushNamed(context, '/student_calendar');
  //     Navigator.pop(context);

  //     // setState(() {
  //     //   statusMessage = 'User registered successfully!';
  //     // });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
  //     });
  //   }
  // }
}
