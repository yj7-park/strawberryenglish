// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously
import 'dart:js' as js;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class EnrollmentScreen1Input extends StatefulWidget {
  const EnrollmentScreen1Input({super.key});

  @override
  EnrollmentScreen1InputState createState() => EnrollmentScreen1InputState();
}

class EnrollmentScreen1InputState extends State<EnrollmentScreen1Input> {
  static final fee = {
    1: {
      2: {
        30: 83900,
        55: 149000,
      },
      3: {
        30: 109900,
        55: 199000,
      },
      5: {
        30: 149900,
        55: 259000,
      },
    },
    3: {
      2: {
        30: 69000,
        55: 129000,
      },
      3: {
        30: 89000,
        55: 169000,
      },
      5: {
        30: 119000,
        55: 209000,
      },
    }
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lessonStartDateController =
      TextEditingController();
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

  List<bool> selected = [false, false];
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
  Set<int> selectedMonths = {3};
  Set<int> selectedDays = {3};
  Set<int> selectedMins = {55};
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
            // TODO: 생년월일
            TextFormField(
              controller: _lessonStartDateController,
              decoration: const InputDecoration(
                labelText: '수업시작일',
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
            const SizedBox(height: 20),
            Text('수업 기간'),
            SegmentedButton(
              segments: [
                ButtonSegment(
                  value: 1,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('1개월'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text('3개월'),
                ),
              ],
              showSelectedIcon: false,
              selected: selectedMonths,
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedMonths = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              '수업 횟수',
            ),
            SegmentedButton(
              segments: [
                ButtonSegment(
                  value: 2,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('주 2회'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text('주 3회'),
                ),
                ButtonSegment(
                  value: 5,
                  label: Text('주 5회'),
                ),
              ],
              showSelectedIcon: false,
              selected: selectedDays,
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedDays = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              '수업 길이',
            ),
            SegmentedButton(
              segments: [
                ButtonSegment(
                  value: 30,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('30분'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 55,
                  label: Text('55분'),
                ),
              ],
              showSelectedIcon: false,
              selected: selectedMins,
              onSelectionChanged: (newSelection) {
                setState(() {
                  selectedMins = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
                '${selectedMonths.first}개월 주 ${selectedDays.first}회 ${selectedMins.first}분'),
            Text(
                '${NumberFormat("###,###").format(fee[selectedMonths.first]![selectedDays.first]![selectedMins.first]! * selectedMonths.first)}원'),
            Text(
                '월(${NumberFormat("###,###").format(fee[selectedMonths.first]![selectedDays.first]![selectedMins.first])}원)'),
          ],
        ),
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
