import 'package:universal_html/js.dart' as js;
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/screens/enrollment_screen/enrollment_screen_1_input.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class EnrollmentScreen4Button extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthDateController;
  final TextEditingController phoneNumberController;
  final TextEditingController requestDayController;
  final TextEditingController requestTimeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;
  final TextEditingController lessonStartDateController;
  final TextEditingController cashReceiptNumberController;

  const EnrollmentScreen4Button({
    super.key,
    required this.nameController,
    required this.birthDateController,
    required this.phoneNumberController,
    required this.requestDayController,
    required this.requestTimeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
    required this.lessonStartDateController,
    required this.cashReceiptNumberController,
  });

  @override
  EnrollmentScreen4ButtonState createState() => EnrollmentScreen4ButtonState();
}

class EnrollmentScreen4ButtonState extends State<EnrollmentScreen4Button> {
  final scrollController = ScrollController();
  // String statusMessage = '';
  String errorMessage = '';
  late StudentProvider studentProvider;

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
                onPressed: submit,
                child: const Text(
                  '수강신청',
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

  // TODO: 메일 주소 verification

  // submit 처리
  void submit() async {
    final TextEditingController pointsController = TextEditingController();
    final name = widget.nameController.text.trim();
    final birthDate = widget.birthDateController.text.trim();
    final phoneNumber = widget.phoneNumberController.text.trim();
    final requestDay = widget.requestDayController.text.trim();
    final requestTime = widget.requestTimeController.text.trim();
    final country = widget.countryController.text.trim();
    final skypeId = widget.skypeIdController.text.trim();
    final studyPurpose = widget.studyPurposeController.text.trim();
    final referralSource = widget.referralSourceController.text.trim();
    final lessonStartDate = widget.lessonStartDateController.text.trim();
    final cashReceiptNumber = widget.cashReceiptNumberController.text.trim();
    errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        requestDay.isEmpty ||
        requestTime.isEmpty ||
        country.isEmpty ||
        skypeId.isEmpty ||
        lessonStartDate.isEmpty) {
      setState(() {
        // errorMessage = 'All fields are required.';
        errorMessage = '모든 필수 항목이 입력되어야 합니다.';
      });
      return;
    }

    if (!EnrollmentScreen.check) {
      setState(() {
        errorMessage = '필수 항목의 동의가 필요합니다.';
      });
      return;
    }

    try {
      setState(() {});
      bool? confirm = await ConfirmDialog.show(
        context: context,
        title: "수강료 결제",
        body: [
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: customTheme.colorScheme.secondary),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            '${EnrollmentScreen.selectedMonths.first}개월 수강권',
                          ),
                          Text(
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            '( 주${EnrollmentScreen.selectedDays.first}회 / ${EnrollmentScreen.selectedMins.first}분 )',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customTheme.colorScheme.primary,
                          ),
                          '정가'),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          var price = EnrollmentScreen1Input.fee[
                                          EnrollmentScreen
                                              .selectedMonths.first]![
                                      EnrollmentScreen.selectedDays.first]![
                                  EnrollmentScreen.selectedMins.first]! *
                              EnrollmentScreen.selectedMonths.first;
                          return Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.primary,
                            ),
                            '${NumberFormat("###,###").format(price)} 원',
                          );
                        },
                      ),
                    ],
                  ),
                  // 적립금 사용
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: customTheme.colorScheme.primary,
                          ),
                          ' - 적립금 할인'),
                      const Spacer(),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextField(
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: customTheme.colorScheme.primary,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.all(5),
                                hintText: '0',
                                border: OutlineInputBorder(),
                              ),
                              controller: pointsController,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (v) {
                                int pointsHas =
                                    studentProvider.student?.data['points'] ??
                                        0;
                                int pointsUse = int.tryParse(v) ?? 0;
                                if (pointsUse > pointsHas) {
                                  pointsUse = pointsHas;
                                  pointsController.text = pointsHas.toString();
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.primary,
                            ),
                            ' 원',
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      style: TextStyle(
                        fontSize: 14,
                        color: customTheme.colorScheme.primary,
                      ),
                      '보유 적립금: ${NumberFormat("###,###").format(studentProvider.student?.data['points'] ?? 0)} 원',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: customTheme.colorScheme.primary,
                        ),
                        '결제금액',
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          var price = EnrollmentScreen1Input.fee[
                                          EnrollmentScreen
                                              .selectedMonths.first]![
                                      EnrollmentScreen.selectedDays.first]![
                                  EnrollmentScreen.selectedMins.first]! *
                              EnrollmentScreen.selectedMonths.first;
                          var pointDiscount =
                              int.tryParse(pointsController.text) ?? 0;
                          var finalPrice = price - pointDiscount;
                          return Text(
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.secondary,
                            ),
                            '${NumberFormat("###,###").format(finalPrice)} 원',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
        trueButton: "결제하기",
        falseButton: "나중에 결제하기",
      );

      if (confirm == true) {
        // 성공 시 동작
        // Student 정보
        Student? updatedStudent = studentProvider.student;
        updatedStudent!.data['name'] = name;
        updatedStudent.data['birthDate'] = birthDate;
        updatedStudent.data['phoneNumber'] = phoneNumber;
        updatedStudent.data['country'] = country;
        updatedStudent.data['studyPurpose'] = studyPurpose;
        updatedStudent.data['referralSource'] = referralSource;
        updatedStudent.data['cashReceiptNumber'] = cashReceiptNumber;
        updatedStudent.data['points'] = (updatedStudent.data['points'] ?? 0) -
            (int.tryParse(pointsController.text) ?? 0);
        // skypeId는 수업별 / 학생별 둘다 관리 (최근 수업 기준으로 학생 데이터에 저장)
        updatedStudent.data['skypeId'] = skypeId;

        // Lecture 정보
        var lectureIndex = (updatedStudent.lectures ?? {})
                .keys
                .toList()
                .map((e) => int.tryParse(
                    e.replaceAll('lecture', '').replaceAll('수업', '')))
                .toList()
                .length +
            1;
        Lecture updatedLecture = Lecture(data: {});
        updatedLecture.data['requestDay'] = requestDay;
        updatedLecture.data['requestTime'] = requestTime;
        updatedLecture.data['skypeId'] = skypeId;
        updatedLecture.data['lessonStartDate'] = lessonStartDate;
        // updatedLecture.data['lessonTime'] = '$requestDay-$requestTime';
        updatedLecture.data['lessonPeriod'] =
            EnrollmentScreen.selectedMins.first;
        updatedLecture.data['program'] = EnrollmentScreen1Input.topic.keys
            .elementAt(EnrollmentScreen.selectedTopic);
        updatedLecture.data['topic'] = EnrollmentScreen1Input.topic.values
                .elementAt(EnrollmentScreen.selectedTopic)[
            EnrollmentScreen.selectedTopicDetail];

        // 수업 종료 일자 계산
        updatedLecture.data['lessonEndDate'] = DateFormat('yyyy-MM-dd').format(
            DateTime.parse(lessonStartDate).add(
                Duration(days: 7 * 4 * EnrollmentScreen.selectedMonths.first)));

        // 수업 취소 횟수 계산
        updatedLecture.data['cancelCountTotal'] =
            updatedLecture.data['cancelCountLeft'] = EnrollmentScreen1Input
                    .cancelCount[EnrollmentScreen.selectedMonths.first]![
                EnrollmentScreen.selectedDays.first];
        updatedLecture.data['cancelDates'] = [];
        updatedLecture.data['cancelRequestDates'] = [];

        // 장기 홀드 횟수 계산
        updatedLecture.data['holdCountTotal'] =
            updatedLecture.data['holdCountLeft'] = EnrollmentScreen1Input
                    .holdCount[EnrollmentScreen.selectedMonths.first]![
                EnrollmentScreen.selectedDays.first];
        updatedLecture.data['holdDates'] = [];
        updatedLecture.data['holdRequestDates'] = [];

        updatedStudent.lectures!['수업$lectureIndex'] = updatedLecture;

        // EnrollmentScreen.selectedDays.first;
        studentProvider.updateStudentToFirestoreWithMap(updatedStudent);

        // 확인 창
        bool? confirm2 = await ConfirmDialog.show(
            context: context,
            title: "수강 신청 완료",
            body: [
              // 입금계좌 정보
              Text(
                '입금계좌 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: customTheme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: customTheme.colorScheme.secondary),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "국민은행\n"
                  "613202-04-131166\n"
                  "(예금주: 윤소명)",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const Text(
                "*등록자 성함을 반드시 적어서 입금해주세요.",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "입금 후, 카톡 채널로 '입금 완료'라고 말씀해주세요.\n"
                "담당자가 확인 후 수업 확정 안내드리도록 하겠습니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: customTheme.colorScheme.primary,
                ),
              ),
            ],
            trueButton: "카카오톡 채널로 문의하기",
            falseButton: "마이페이지로 이동",
            routeToOnLeft: '/student_calendar');

        if (confirm2 == true) {
          js.context.callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
