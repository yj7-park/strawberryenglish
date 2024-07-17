import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/enrollment_screen/trial_screen_2_input.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_1_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_3_button.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class TrialScreen extends StatefulWidget {
  TrialScreen({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirmPasswordController =
  //     TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController trialDayController = TextEditingController();
  final TextEditingController trialTimeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController skypeIdController = TextEditingController();
  final TextEditingController studyPurposeController = TextEditingController();
  final TextEditingController referralSourceController =
      TextEditingController();

  static String errorMessage = '';

  @override
  State<TrialScreen> createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {
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
                  widget.trialDayController.text =
                      snapshot.data!.data['trialDay'] ?? '';
                  widget.trialTimeController.text =
                      snapshot.data!.data['trialTime'] ?? '';
                  // trialDate가 있고, 날짜가 이미 지난 경우
                  var isFinished = false;
                  var trialDate = DateTime.tryParse(
                          snapshot.data!.data['trialDate'] ?? '') ??
                      DateTime.now();
                  if (DateTime.now().isAfter(trialDate)) {
                    isFinished = true;
                  }
                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 93), // Make space for the AppBar
                    children: [
                      // 제목
                      const MyHeader('체험하기'),
                      // 커버 페이지
                      if (isFinished) ...[
                        const SizedBox(height: 20),
                        Text(
                          """
무료 체험은 계정당 1회만 신청 가능합니다.
추가 문의사항은 카카오톡 채널을 이용해주시기 바랍니다.
[수강신청] 버튼을 눌러 수강 신청을 하실 수 있습니다.

*진행이 완료된 무료 체험

날짜: ${DateFormat('yyyy년 MM월 dd일').format(trialDate)}

시간: ${DateFormat('hh시 mm분').format(trialDate)} (한국시간)

Tutor: ${snapshot.data!.data['trialTutor'] ?? ''}
 
""",
                          textAlign: TextAlign.center,
                        )
                      ] else ...[
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
                        TrialScreen2Input(
                          trialDayController: widget.trialDayController,
                          trialTimeController: widget.trialTimeController,
                        ),
                        TrialScreen3Button(
                          nameController: widget.nameController,
                          birthDateController: widget.birthDateController,
                          phoneNumberController: widget.phoneNumberController,
                          trialDayController: widget.trialDayController,
                          trialTimeController: widget.trialTimeController,
                          countryController: widget.countryController,
                          skypeIdController: widget.skypeIdController,
                          studyPurposeController: widget.studyPurposeController,
                          referralSourceController:
                              widget.referralSourceController,
                        ),
                        // 회사정보
                        // const CompanyInfo(),
                      ]
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
