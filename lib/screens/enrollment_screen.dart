import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_1_input.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_2_payment_input.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_4_button.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_1_input.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class EnrollmentScreen extends StatefulWidget {
  EnrollmentScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController requestDayController = TextEditingController();
  final TextEditingController requestTimeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController skypeIdController = TextEditingController();
  final TextEditingController studyPurposeController = TextEditingController();
  final TextEditingController referralSourceController =
      TextEditingController();

  final TextEditingController lessonStartDateController =
      TextEditingController();
  final TextEditingController cashReceiptNumberController =
      TextEditingController();
  static Set<int> selectedMonths = {3};
  static Set<int> selectedDays = {3};
  static Set<int> selectedMins = {55};
  static int selectedTopic = 0;
  static int selectedTopicDetail = 0;

  static bool check = false;

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
                    // child: Text('로그인이 필요한 서비스입니다.'),
                  );
                } else if (snapshot.hasError) {
                  // 에러가 발생했을 때 표시할 화면
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  // 데이터가 로드되었을 때 표시할 화면
                  widget.nameController.text =
                      snapshot.data!.data['name'] ?? '';
                  widget.birthDateController.text =
                      snapshot.data!.data['birthDate'] ?? '';
                  widget.phoneNumberController.text =
                      snapshot.data!.data['phoneNumber'] ?? '';
                  widget.countryController.text =
                      snapshot.data!.data['country'] ?? '';
                  widget.skypeIdController.text =
                      snapshot.data!.data['skypeId'] ?? '';
                  widget.studyPurposeController.text =
                      snapshot.data!.data['studyPurpose'] ?? '';
                  widget.referralSourceController.text =
                      snapshot.data!.data['referralSource'] ?? '';
                  widget.lessonStartDateController.text =
                      snapshot.data!.data['lessonStartDate'] ?? '';
                  widget.requestDayController.text =
                      snapshot.data!.data['requestDay'] ?? '';
                  widget.requestTimeController.text =
                      snapshot.data!.data['requestTime'] ?? '';
                  widget.cashReceiptNumberController.text =
                      snapshot.data!.data['cashReceiptNumber'] ?? '';
                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 93), // Make space for the AppBar
                    children: [
                      // 제목
                      const MyHeader('수강신청'),
                      // 커버 페이지
                      SignupScreen2Input(
                        nameController: widget.nameController,
                        birthDateController: widget.birthDateController,
                      ),
                      TrialScreen1Input(
                        phoneNumberController: widget.phoneNumberController,
                        countryController: widget.countryController,
                        skypeIdController: widget.skypeIdController,
                        studyPurposeController: widget.studyPurposeController,
                        referralSourceController:
                            widget.referralSourceController,
                      ),
                      EnrollmentScreen1Input(
                        lessonStartDateController:
                            widget.lessonStartDateController,
                        requestDayController: widget.requestDayController,
                        requestTimeController: widget.requestTimeController,
                      ),
                      EnrollmentScreen2PaymentInput(
                        cashReceiptNumberController:
                            widget.cashReceiptNumberController,
                      ),
                      EnrollmentScreen4Button(
                        nameController: widget.nameController,
                        birthDateController: widget.birthDateController,
                        phoneNumberController: widget.phoneNumberController,
                        requestDayController: widget.requestDayController,
                        requestTimeController: widget.requestTimeController,
                        countryController: widget.countryController,
                        skypeIdController: widget.skypeIdController,
                        studyPurposeController: widget.studyPurposeController,
                        referralSourceController:
                            widget.referralSourceController,
                        lessonStartDateController:
                            widget.lessonStartDateController,
                        cashReceiptNumberController:
                            widget.cashReceiptNumberController,
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
            // Positioned(
            //   bottom: 30,
            //   right: 30,
            //   child: InkWell(
            //     onTap: () {
            //       js.context
            //           .callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
            //     },
            //     child: Image.asset(
            //       'assets/images/kakao_talk.png',
            //       width: 70,
            //     ),
            //   ),
            // ),
            const Positioned(
              child: MyMenuAppBar(),
            ),
          ],
        ),
        drawer: const MyDrawer(),
      ),
    );
  }
}
