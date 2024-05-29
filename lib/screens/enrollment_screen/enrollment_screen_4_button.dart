import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_1_input.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class EnrollmentScreen4Button extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;
  final TextEditingController phoneNumberController;
  final TextEditingController dayController;
  final TextEditingController timeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;
  final TextEditingController lessonStartDateController;

  const EnrollmentScreen4Button({
    super.key,
    required this.nameController,
    required this.birthdayController,
    required this.phoneNumberController,
    required this.dayController,
    required this.timeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
    required this.lessonStartDateController,
  });

  @override
  EnrollmentScreen4ButtonState createState() => EnrollmentScreen4ButtonState();
}

class EnrollmentScreen4ButtonState extends State<EnrollmentScreen4Button> {
  final scrollController = ScrollController();
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
                  '수강신청',
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

  // // TODO: 회원 가입 처리
  void submit() async {
    final name = widget.nameController.text.trim();
    final birthday = widget.birthdayController.text.trim();
    final phoneNumber = widget.phoneNumberController.text.trim();
    final day = widget.dayController.text.trim();
    final time = widget.timeController.text.trim();
    final country = widget.countryController.text.trim();
    final skypeId = widget.skypeIdController.text.trim();
    final studyPurpose = widget.studyPurposeController.text.trim();
    final referralSource = widget.referralSourceController.text.trim();
    final lessonStartDate = widget.lessonStartDateController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        birthday.isEmpty ||
        phoneNumber.isEmpty ||
        day.isEmpty ||
        time.isEmpty ||
        country.isEmpty ||
        skypeId.isEmpty ||
        studyPurpose.isEmpty ||
        referralSource.isEmpty ||
        lessonStartDate.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    try {
      setState(() {});
      // 결제창 표시
      bool? confirm = await ConfirmDialog.show(
          context,
          "수강료 결제",
          "" +
              "구독기간 : ${EnrollmentScreen.selectedMonths.first} 개월\n" +
              "수업횟수 : 주 ${EnrollmentScreen.selectedDays.first}회\n" +
              "수업길이 : ${EnrollmentScreen.selectedMins.first}분\n" +
              "수업토픽 : Power/Fluency\n" +
              "결제금액 : ${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first]! * EnrollmentScreen.selectedMonths.first)}원" +
              (EnrollmentScreen.selectedMonths.first > 1
                  ? "(월 ${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first])}원)"
                  : ""),
          "결제하기",
          "나중에 결제하기");

      if (confirm == true) {
        // TODO: 성공 시 동작
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
