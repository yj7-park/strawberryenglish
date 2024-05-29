import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_1_input.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_4_button.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_Input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_1_input.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class EnrollmentScreen extends StatefulWidget {
  EnrollmentScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController lessonDayController = TextEditingController();
  final TextEditingController lessonTimeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController skypeIdController = TextEditingController();
  final TextEditingController studyPurposeController = TextEditingController();
  final TextEditingController referralSourceController =
      TextEditingController();

  final TextEditingController lessonStartDateController =
      TextEditingController();
  static Set<int> selectedMonths = {3};
  static Set<int> selectedDays = {3};
  static Set<int> selectedMins = {55};

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: MyMenuAppBar(),
        body: Stack(
          children: [
            FutureBuilder<Student?>(
              future: Provider.of<StudentProvider>(context)
                  .getStudent(), // 새로운 Future 생성
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  // 로딩중일 때 표시할 화면
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // 에러가 발생했을 때 표시할 화면
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  // 데이터가 로드되었을 때 표시할 화면
                  widget.nameController.text = snapshot.data!.name ?? '';
                  widget.birthDateController.text =
                      snapshot.data!.birthDate ?? '';

                  widget.phoneNumberController.text =
                      snapshot.data!.phoneNumber ?? '';
                  widget.countryController.text = snapshot.data!.country ?? '';
                  widget.skypeIdController.text = snapshot.data!.skypeId ?? '';
                  widget.studyPurposeController.text =
                      snapshot.data!.studyPurpose ?? '';
                  widget.referralSourceController.text =
                      snapshot.data!.referralSource ?? '';
                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 56), // Make space for the AppBar
                    children: [
                      // 제목
                      MyHeader('수강신청'),
                      // 커버 페이지
                      SignupScreen2Input(
                        nameController: widget.nameController,
                        birthDateController: widget.birthDateController,
                      ),
                      TrialScreen1Input(
                        phoneNumberController: widget.phoneNumberController,
                        lessonDayController: widget.lessonDayController,
                        lessonTimeController: widget.lessonTimeController,
                        countryController: widget.countryController,
                        skypeIdController: widget.skypeIdController,
                        studyPurposeController: widget.studyPurposeController,
                        referralSourceController:
                            widget.referralSourceController,
                      ),
                      EnrollmentScreen1Input(
                        lessonStartDateController:
                            widget.lessonStartDateController,
                      ),
                      EnrollmentScreen4Button(
                        nameController: widget.nameController,
                        birthDateController: widget.birthDateController,
                        phoneNumberController: widget.phoneNumberController,
                        lessonDayController: widget.lessonDayController,
                        lessonTimeController: widget.lessonTimeController,
                        countryController: widget.countryController,
                        skypeIdController: widget.skypeIdController,
                        studyPurposeController: widget.studyPurposeController,
                        referralSourceController:
                            widget.referralSourceController,
                        lessonStartDateController:
                            widget.lessonStartDateController,
                      ),
                      // 회사정보
                      // const CompanyInfo(),
                    ],
                  );
                } else {
                  // 데이터가 없을 때 표시할 화면
                  return const Center(
                      // child: Text('No data available'),
                      );
                }
              },
            ),
            const Positioned(
              child: MyMenuAppBar(),
            ),
          ],
        ),
      ),
    );
  }
}
