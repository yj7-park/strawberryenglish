import 'package:strawberryenglish/screens/signup_screen/signup_screen_3_button.dart';
import 'package:universal_html/js.dart' as js;
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class TrialScreen3Button extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthDateController;
  final TextEditingController phoneNumberController;
  final TextEditingController trialDayController;
  final TextEditingController trialTimeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;

  const TrialScreen3Button({
    super.key,
    required this.nameController,
    required this.birthDateController,
    required this.phoneNumberController,
    required this.trialDayController,
    required this.trialTimeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
  });

  @override
  TrialScreen3ButtonState createState() => TrialScreen3ButtonState();
}

class TrialScreen3ButtonState extends State<TrialScreen3Button> {
  String errorMessage = '';
  late StudentProvider studentProvider;

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
              errorMessageTranslate(errorMessage),
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                ),
                onPressed: () {
                  register();
                },
                child: const Text(
                  '체험하기',
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

  // submit 처리
  void register() async {
    final name = widget.nameController.text.trim();
    final birthDate = widget.birthDateController.text.trim();
    final phoneNumber = widget.phoneNumberController.text.trim();
    final trialDay = widget.trialDayController.text.trim();
    final trialTime = widget.trialTimeController.text.trim();
    final country = widget.countryController.text.trim();
    final skypeId = widget.skypeIdController.text.trim();
    final studyPurpose = widget.studyPurposeController.text.trim();
    final referralSource = widget.referralSourceController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        trialDay.isEmpty ||
        trialTime.isEmpty ||
        country.isEmpty ||
        skypeId.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    try {
      // setState(() {});

      // 성공 시 동작
      Student? updatedStudent = studentProvider.student;
      // updatedStudent!.name = name;
      // updatedStudent.birthDate = birthDate;
      // updatedStudent.phoneNumber = phoneNumber;
      // updatedStudent.trialDay = trialDay;
      // updatedStudent.trialTime = trialTime;
      // updatedStudent.country = country;
      // updatedStudent.skypeId = skypeId;
      // updatedStudent.studyPurpose = studyPurpose;
      // updatedStudent.referralSource = referralSource;
      updatedStudent!.data['name'] = name;
      updatedStudent.data['birthDate'] = birthDate;
      updatedStudent.data['phoneNumber'] = phoneNumber;
      updatedStudent.data['trialDay'] = trialDay;
      updatedStudent.data['trialTime'] = trialTime;
      updatedStudent.data['country'] = country;
      updatedStudent.data['skypeId'] = skypeId;
      updatedStudent.data['studyPurpose'] = studyPurpose;
      updatedStudent.data['referralSource'] = referralSource;
      studentProvider.updateStudentToFirestoreWithMap(updatedStudent);

      // 확인 창
      bool? confirm = await ConfirmDialog.show(
          context: context,
          title: "체험 수업 신청 완료",
          body: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: const BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                child: Text(
                  "체험 확정을 위해 카톡 채널로 '신청완료'라고 말씀해주세요.\n"
                  "담당자가 확인 후 수업 확정 안내드리도록 하겠습니다.",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
          trueButton: "카카오톡 채널로 문의하기",
          falseButton: "마이페이지로 이동",
          routeToOnLeft: '/student_calendar');

      if (confirm == true) {
        js.context.callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);

        // TODO: 뒤로 돌아가기
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
