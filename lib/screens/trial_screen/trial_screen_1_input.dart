// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'dart:js' as js;
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrialScreen1Input extends StatefulWidget {
  const TrialScreen1Input({super.key});

  @override
  TrialScreen1InputState createState() => TrialScreen1InputState();
}

class TrialScreen1InputState extends State<TrialScreen1Input> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _skypeController = TextEditingController();
  final TextEditingController _studyPurposeController = TextEditingController();
  final TextEditingController _referralSourceController =
      TextEditingController();
  // String _statusMessage = '';
  String _errorMessage = '';

  // final TextEditingController _phoneNumberController =
  //     TextEditingController(text: '+82');
  // final TextEditingController _verificationCodeController =
  //     TextEditingController();
  // String _verificationId = '';
  // bool _isSent = false;
  // bool _isVerified = false;
  // String _selectedCountryCode = '+82'; // 추가된 부분
  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> _countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            '체험하기',
            style: TextStyle(
              fontSize: (screenWidth * 0.04).clamp(14, 32),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 60),
          SizedBox(
            width: screenWidth.clamp(500, 500),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: '한글 이름',
                      border: OutlineInputBorder(),
                    ),
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.allow(
                    //     RegExp("[ㄱ-힣]"),
                    //   ),
                    // ],
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  // TODO: 생년월일
                  TextFormField(
                    controller: _birthdayController,
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
                  const Text('* 회원 가입된 이름과 다를 경우에만 입력하세요.'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
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
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: '거주 국가',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dayController,
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
                    controller: _timeController,
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
                    controller: _skypeController,
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
                      js.context.callMethod('open', [
                        'https://skype.daesung.com/download/downloadMain.asp'
                      ]);
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
                    controller: _studyPurposeController,
                    decoration: const InputDecoration(
                      labelText: '영어 공부 목적',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _referralSourceController,
                    decoration: const InputDecoration(
                      labelText: '딸기영어를 알게된 경로',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  SizedBox(
                    width: screenWidth.clamp(500, 500),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize:
                            const Size(double.infinity, 60), // 버튼 사이즈 조정
                      ),
                      // TODO: 버튼 클릭 시 팝업
                      onPressed: _registerUser,
                      child: const Text('신청하기',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38)),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // void _sendVerificationCode() async {
  //   final phoneNumber = _phoneNumberController.text.trim();
  //   _errorMessage = '';

  //   try {
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //         FirebaseAuth.instance.signInWithCredential(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         setState(() {
  //           _errorMessage = 'Error: $e';
  //         });
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         setState(() {
  //           _verificationId = verificationId;
  //           _statusMessage = 'Verification code sent!';
  //           _isSent = true;
  //         });
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         setState(() {
  //           _verificationId = verificationId;
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Error: $e';
  //     });
  //   }
  // }

  // void _checkVerificationCode() async {
  //   final verificationCode = _verificationCodeController.text.trim();
  //   _errorMessage = '';

  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId,
  //       smsCode: verificationCode,
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     setState(() {
  //       _statusMessage = 'Phone number verified!';
  //       _isVerified = true;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _errorMessage = 'Error: $e';
  //     });
  //   }
  // }

// TODO: 정보 등록 처리
  void _registerUser() async {
    final name = _nameController.text.trim();
    final email = _phoneController.text.trim();
    // final phoneNumber = _phoneNumberController.text.trim();
    final password = _dayController.text.trim();
    final confirmPassword = _timeController.text.trim();
    _errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        email.isEmpty ||
        // phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        // _errorMessage = 'All fields are required.';
        _errorMessage = '모든 항목이 입력되어야 합니다.';
      });
      return;
    }

    // if (!_isVerified) {
    //   setState(() {
    //     _errorMessage = 'Phone Number is not verified.';
    //   });
    //   return;
    // }

    try {
      // UserCredential userCredential =
      //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //   email: email,
      //   password: password,
      // );

      // // Add user data to Firestore
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
      //   _statusMessage = 'User registered successfully!';
      // });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
