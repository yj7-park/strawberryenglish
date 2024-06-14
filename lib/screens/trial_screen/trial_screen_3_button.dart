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
  final TextEditingController lessonDayController;
  final TextEditingController lessonTimeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;

  const TrialScreen3Button({
    super.key,
    required this.nameController,
    required this.birthDateController,
    required this.phoneNumberController,
    required this.lessonDayController,
    required this.lessonTimeController,
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
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                ),
                onPressed: register,
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
    final lessonDay = widget.lessonDayController.text.trim();
    final lessonTime = widget.lessonTimeController.text.trim();
    final country = widget.countryController.text.trim();
    final skypeId = widget.skypeIdController.text.trim();
    final studyPurpose = widget.studyPurposeController.text.trim();
    final referralSource = widget.referralSourceController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        lessonDay.isEmpty ||
        lessonTime.isEmpty ||
        country.isEmpty ||
        skypeId.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    try {
      setState(() {});

      // 성공 시 동작
      Student? updatedStudent = await studentProvider.getStudent();
      updatedStudent!.name = name;
      updatedStudent.birthDate = birthDate;
      updatedStudent.phoneNumber = phoneNumber;
      updatedStudent.lessonDay = lessonDay;
      updatedStudent.lessonTime = lessonTime;
      updatedStudent.country = country;
      updatedStudent.skypeId = skypeId;
      updatedStudent.studyPurpose = studyPurpose;
      updatedStudent.referralSource = referralSource;
      studentProvider.updateStudentToFirestore(updatedStudent);

      // 확인 창
      await ConfirmDialog.show(
        context: context,
        title: "수강신청 완료",
        body: "체험 확정을 위해 카톡 채널로 '신청완료'라고 말씀해주세요.",
        trueButton: "카카오톡 채널로 문의하기",
        falseButton: "마이페이지로 이동",
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
