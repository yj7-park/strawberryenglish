import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/screens/enrollment_screen/trial_screen_2_input.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_2_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_1_input.dart';
import 'package:strawberryenglish/screens/trial_screen/trial_screen_3_button.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:strawberryenglish/widgets/my_header.dart';
import 'package:universal_html/js.dart' as js;

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

  @override
  State<TrialScreen> createState() => _TrialScreenState();
}

class _TrialScreenState extends State<TrialScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = (screenWidth * 0.025).clamp(12, 18);
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
                  return ListView(
                    padding: const EdgeInsets.only(
                        top: 93), // Make space for the AppBar
                    children: [
                      // 제목
                      const MyHeader('체험하기'),
                      // 커버 페이지
                      if (snapshot.data!.getStudentTrialState() ==
                          StudentState.trialRequested) ...[
                        Text(
                          """

*체험 수업 신청 완료

체험 수업 확정 안내를 위해 

반드시 카카오톡 채널을 통해 '체험 수업 신청 완료'라고 말씀해 주세요. 

체험 수업 일정이 확정되면 카카오톡으로 안내드리겠습니다.

그 외 정보 수정 및 문의사항 있으시다면 카카오톡 채널로 문의해 주세요.

""",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]
                      // 체험 확정 상태
                      else if (snapshot.data!.getStudentTrialState() ==
                          StudentState.trialConfirmed) ...[
                        Text(
                          """

*체험 수업 확정

${snapshot.data!.data['name']} 님의 체험 수업이 확정되었습니다 :)

날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(snapshot.data!.data['trialDate']))} ${getWeekdayFromNumber(DateTime.parse(snapshot.data!.data['trialDate']).weekday)}요일

시간: ${DateFormat('H시 mm분').format(DateTime.parse('${snapshot.data!.data['trialDate']} ${snapshot.data!.data['trialTime']}'))} (한국시간)

Tutor: ${snapshot.data!.data['trialTutor'] ?? ''}
 
체험 수업은 20분간 레벨 테스트 목적으로 진행되며 정규 수업과 수업 방식이 다르다는 점 안내드립니다 :)

튜터 분이 스카이프를 통해 친구 요청 메시지를 전달 드릴 예정입니다.
원활한 체험 수업 진행을 위해 수업 시작 30분 전까지 친구 수락이 되어야 체험 수업이 확정된다는 점 꼭 확인해 주세요.

감사합니다.
Enjoy your English with 🍓

""",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ]
                      // 체험 완료 상태
                      else if (snapshot.data!.getStudentTrialState() ==
                          StudentState.trialFinished) ...[
                        Text(
                          """

*체험 수업 종료

${snapshot.data!.data['name']} 님의 체험 수업이 종료되었습니다 :)

날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(snapshot.data!.data['trialDate']))} ${getWeekdayFromNumber(DateTime.parse(snapshot.data!.data['trialDate']).weekday)}요일

시간: ${DateFormat('H시 mm분').format(DateTime.parse('${snapshot.data!.data['trialDate']} ${snapshot.data!.data['trialTime']}'))} (한국시간)

Tutor: ${snapshot.data!.data['trialTutor'] ?? ''}
 
무료 체험은 계정당 1회만 신청 가능합니다.

추가 문의사항은 카카오톡 채널을 이용해주시기 바랍니다.

""",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: (screenWidth * 0.5).clamp(100, 500),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(
                                    double.infinity, 60), // 버튼 사이즈 조정
                              ),
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                        context, '/enrollment')
                                    .then((_) => setState(() {}));
                              },
                              child: Text(
                                '수강신청',
                                style: TextStyle(
                                    fontSize:
                                        (screenWidth * 0.025).clamp(10, 16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
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
            Positioned(
              bottom: 30,
              right: 30,
              child: InkWell(
                onTap: () {
                  js.context
                      .callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
                },
                child: Image.asset(
                  'assets/images/kakao_talk.png',
                ),
              ),
            ),
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
