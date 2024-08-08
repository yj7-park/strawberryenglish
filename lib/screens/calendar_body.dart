import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarBody extends StatefulWidget {
  final Student user;
  final bool? isAdmin;

  final ValueChanged<String>? updated; // for 관리자메뉴 학생정보
  const CalendarBody(
      {super.key, required this.user, this.isAdmin, this.updated});

  @override
  CalendarBodyState createState() => CalendarBodyState();
}

class CalendarBodyState extends State<CalendarBody> {
  late CalendarController calendarController;
  late TextEditingController feedbackTitleController;
  late TextEditingController feedbackBodyController;

  String selectedHoldStartDate = '';
  late DateTime selectedDate;
  bool isBottomSheetOpened = false;
  bool feedbackNeeded = false;
  late CalendarDataSource calendarDataSource;
  bool needCalendar = false;
  Map<String, String> holidayData = {};
  Map<String, String> breakdayData = {};

  Future<dynamic> getHolidayData() async {
    final collection = FirebaseFirestore.instance.collection("holiday");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        holidayData = {
          for (var doc in snapshot.docs) doc.id: doc.data()['name'] ?? '',
        };
      });
    });
  }

  Future<dynamic> getBreakdayData() async {
    final collection = FirebaseFirestore.instance.collection("breakday");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        breakdayData = {
          for (var doc in snapshot.docs) doc.id: doc.data()['name'] ?? '',
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getHolidayData();
    getBreakdayData();
  }

  @override
  Widget build(BuildContext context) {
    needCalendar =
        (widget.user.getStudentState() == StudentState.lectureOnGoing) ||
            (widget.user.getStudentState() == StudentState.lectureOnHold) ||
            (widget.user.getStudentState() == StudentState.lectureFinished);
    if (needCalendar) {
      calendarController = CalendarController();
      selectedDate = calendarController.selectedDate ?? DateTime.now();
      calendarController.selectedDate = DateTime.now();

      feedbackTitleController = TextEditingController();
      feedbackBodyController = TextEditingController();

      calendarDataSource = _getCalendarDataSource();
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 1000 || widget.updated != null;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.updated == null
            ? ((screenWidth - 1000) / 2).clamp(20, double.nan)
            : 20,
        vertical: widget.updated == null ? 50.0 : 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 체험 신청 중인 상태
            if (widget.user.getStudentState() ==
                StudentState.trialRequested) ...[
              const Text(
                """
*체험 수업 신청 완료

체험 수업 신청이 완료되어, 일정을 확인 중입니다.

체험 수업 일정이 확정되면 카카오톡으로 연락 드리겠습니다.

신청 정보 수정이 필요하시면 카카오톡 채널로 문의해주시기 바랍니다.

""",
                textAlign: TextAlign.center,
              ),
            ]
            // 체험 확정 상태
            else if (widget.user.getStudentState() ==
                StudentState.trialConfirmed) ...[
              Text(
                """
*체험 수업 확정

${widget.user.data['name']} 님의 체험 수업이 확정되었습니다 :)

날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.user.data['trialDate']))} ${getWeekdayFromNumber(DateTime.parse(widget.user.data['trialDate']).weekday)}요일

시간: ${DateFormat('H시 mm분').format(DateTime.parse('${widget.user.data['trialDate']} ${widget.user.data['trialTime']}'))} (한국시간)

Tutor: ${widget.user.data['trialTutor'] ?? ''}
 
체험 수업은 20분간 레벨 테스트 목적으로 진행되며 정규 수업과 수업 방식이 다르다는 점 안내드립니다 :)

튜터 분이 스카이프를 통해 친구 요청 메시지를 전달 드릴 예정입니다.
원활한 체험 수업 진행을 위해 수업 시작 30분 전까지 친구 수락이 되어야 체험 수업이 확정된다는 점 꼭 확인해 주세요.

감사합니다.
Enjoy your English with 🍓

""",
                textAlign: TextAlign.center,
              ),
            ]
            // 체험 완료 상태
            else if (widget.user.getStudentState() ==
                StudentState.trialFinished) ...[
              Text(
                """
*체험 수업 종료

${widget.user.data['name']} 님의 체험 수업이 종료되었습니다 :)

날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.user.data['trialDate']))} ${getWeekdayFromNumber(DateTime.parse(widget.user.data['trialDate']).weekday)}요일

시간: ${DateFormat('H시 mm분').format(DateTime.parse('${widget.user.data['trialDate']} ${widget.user.data['trialTime']}'))} (한국시간)

Tutor: ${widget.user.data['trialTutor'] ?? ''}
 
무료 체험은 계정당 1회만 신청 가능합니다.

추가 문의사항은 카카오톡 채널을 이용해주시기 바랍니다.

""",
                textAlign: TextAlign.center,
              ),
              Center(
                child: SizedBox(
                  width: 500,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/enrollment');
                    },
                    child: const Text(
                      '수강신청',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ]
            // 수강 신청 중인 상태
            else if (widget.user.getStudentState() ==
                StudentState.lectureRequested) ...[
              const Text(
                """
*수강 신청 완료

수강 신청이 완료되어, 일정을 확인 중입니다.

수업 일정이 확정되면 카카오톡으로 연락 드리겠습니다.

신청 정보 수정이 필요하시면 카카오톡 채널로 문의해주시기 바랍니다.

""",
                textAlign: TextAlign.center,
              ),
            ]
            // {수업 중 / 장기 홀드 중 / 수업 완료} 인 상태
            else if (needCalendar) ...[
              // 후기 작성 요청
              if (feedbackNeeded)
                ExpansionTile(
                  // backgroundColor: Color.fromARGB(255, 246, 246, 246),
                  // collapsedBackgroundColor: Color.fromARGB(255, 246, 246, 246),
                  shape: InputBorder.none,
                  dense: true,
                  tilePadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0), // ListTile의 contentPadding 조절
                  title:
                      // const Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      const Text(
                    '🎁 [이벤트] 후기 작성하고 적립금 받아가세요!!',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  trailing: const SizedBox(),
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  childrenPadding: const EdgeInsets.all(20),
                  children: [
                    const Text(
                      """딸기영어에 대한 후기를 남겨주세요.
정성스러운 후기를 남겨주신 분들께는 수강신청 시 현금처럼 사용하실 수 있는
1000원의 적립금을 드립니다!!""",
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: feedbackTitleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '제목',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      controller: feedbackBodyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '내용',
                        isDense: true,
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          bool? confirm = await ConfirmDialog.show(
                            context: context,
                            title: "후기 작성",
                            body: [
                              Text(
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                    color: customTheme.colorScheme.primary,
                                  ),
                                  '작성하신 후기를 제출하시겠습니까?'),
                            ],
                            trueButton: "확인",
                            falseButton: "취소",
                          );

                          if (confirm == true) {
                            // 성공 시 동작
                            // Student DB: lastFeedbackDate 저장
                            var dateText =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            widget.user.data['lastFeedbackDate'] = dateText;

                            Provider.of<StudentProvider>(context, listen: false)
                                .updateStudentToFirestoreWithMap(widget.user);
                            // Feedback DB: 후기 데이터 저장
                            FirebaseFirestore.instance
                                .collection('feedback')
                                // .doc(currentUser!.email)
                                .doc('$dateText(${widget.user.data['name']})')
                                .set({
                              'title': feedbackTitleController.text,
                              'body': feedbackBodyController.text.split('\n'),
                              'date': dateText,
                              'tutor': widget.user.data['tutor'],
                              'name': widget.user.data['name'],
                              'email': widget.user.data['email'],
                              'show': false,
                              'checked': false,
                            });

                            // 확인 창
                            await ConfirmDialog.show(
                              context: context,
                              title: "후기 작성 완료",
                              body: [
                                Text(
                                  "후기 제출이 완료되었습니다.\n"
                                  "소중한 후기를 작성해주셔서 감사합니다.\n\n"
                                  "※ 적립금은 담당자 확인 후 순차적으로 지급될 예정이며,\n"
                                  "홈페이지 [딸기후기] 페이지에 익명으로 게시될 수 있습니다.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    // fontWeight: FontWeight.bold,
                                    color: customTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                              trueButton: "확인",
                            );
                          }
                        } catch (e) {
                          // setState(() {
                          //   errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
                          // });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                        foregroundColor: Colors.white,
                        backgroundColor: customTheme.colorScheme.secondary,
                        shadowColor: Colors.white,
                      ),
                      child: const Text(
                        '작성 완료',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              const Divider(height: 0),
              // 여기에 사용자 정보를 보여주는 위젯 추가
              _buildStudentDetails(screenHeight > 1000, isMobile),
              const Divider(height: 0),
              const SizedBox(height: 20),
              _buildCalendar(),
            ]
            // 회원 가입만 된 상태
            else ...[
              const Text('딸기영어에 오신 것을 환영합니다.'),
              const Text('[체험하기] 버튼을 눌러 체험 수업을 신청하시거나,'),
              const Text('[수강신청] 버튼을 눌러 수강 신청을 하실 수 있습니다.'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetails(bool isExpanded, bool isMobile) {
    return ExpansionTile(
        // backgroundColor: Color.fromARGB(255, 246, 246, 246),
        // collapsedBackgroundColor: Color.fromARGB(255, 246, 246, 246),
        shape: InputBorder.none,
        tilePadding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 0), // ListTile의 contentPadding 조절
        initiallyExpanded: isExpanded,
        title:
            // const Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            const Text(
          'Information',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        //   ],
        // ),
        // subtitle: Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           _buildInfoRow('이름', '${widget.user.data['name']}'),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           _buildInfoRow('수업 시간', widget.user.data['lessonTime']),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           // _buildInfoRow('수업 요일', widget.user.data['lessonDay']),
        //           _buildInfoRow('적립금',
        //               '${NumberFormat("###,###").format(widget.user.data['points'] ?? 0)} 원'),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child:
                // const SizedBox(height: 10),
                // _buildEarningInfo(student),
                _buildLessonInfo(isMobile),
            // _buildActionButtons(widget.user),
          ),
        ]);
  }

  Widget _buildCalendar() {
    return SizedBox(
      height: 430,
      child: Localizations.override(
        context: context,
        locale: const Locale('ko'),
        child: SfCalendar(
          view: CalendarView.month,
          // selectionDecoration: BoxDecoration(
          //   color: const Color(0xfffcc021), // 선택된 셀의 배경색
          //   borderRadius: BorderRadius.circular(10), // 모서리 반경
          // ),
          showNavigationArrow: true,
          dataSource: calendarDataSource,
          controller: calendarController,
          showDatePickerButton: true,
          headerDateFormat: 'yyyy년 M월', // 원하는 형식으로 지정
          todayHighlightColor: const Color(0xfffcc021),
          // allowAppointmentResize: true,
          // allowDragAndDrop: true,
          monthViewSettings: const MonthViewSettings(
            agendaItemHeight: 50,
            agendaViewHeight: 60,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            appointmentDisplayCount: 1,
            showTrailingAndLeadingDates: false,
            agendaStyle: AgendaStyle(
                appointmentTextStyle: TextStyle(fontSize: 15.0),
                backgroundColor: Color.fromARGB(255, 246, 246, 246)),
            showAgenda: true,
            navigationDirection: MonthNavigationDirection.horizontal,
            monthCellStyle: MonthCellStyle(
              backgroundColor: Colors.white,
            ),
          ),
          // monthCellBuilder: _buildMonthCell,
          onTap: selectedHoldStartDate.isEmpty
              ? _buildOnTapWidget
              : // 장기 홀드 끝날짜 선택
              (details) {
                  DateTime startDate = DateTime.parse(
                      selectedHoldStartDate.replaceAll('. ', '-'));
                  if (details.date!.isAfter(startDate) ||
                      details.date!.isAtSameMomentAs(startDate)) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(details.date!);
                    widget.user.data['holdRequestDates']
                        .add('$selectedHoldStartDate~$formattedDate');
                    widget.user.data['holdCountLeft'] =
                        widget.user.data['holdCountLeft'] - 1;
                    selectedHoldStartDate = '';
                    _bottomSheetController?.close();
                    _updateLessonInformation();
                    Provider.of<StudentProvider>(context, listen: false)
                        .updateStudentToFirestoreWithMap(widget.user);
                    //     .then((context) {
                    //   setState(() {
                    //     if (widget.updated != null) widget.updated!('');
                    //   });
                    // });
                  }
                },
        ),
      ),
    );
  }
// Widget _buildEarningInfo(Student student) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text('적립금: ${student.earningAmount}'),
//       const SizedBox(height: 10),
//     ],
//   );
// }

  Widget _buildLessonInfo(bool isMobile) {
    return Column(
      children: [
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow('이름', '${widget.user.data['name']}', isMobile),
            _buildInfoRow('튜터', widget.user.data['tutor'] ?? '', isMobile),
            // _buildInfoRow('토픽', widget.user.data['topic'] ?? ''),
            _buildInfoRow(
                '토픽',
                '${widget.user.data['program'] ?? ''}\n${widget.user.data['topic'] ?? ''}',
                isMobile),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow('수업 시간',
                (widget.user.data['lessonTime'] ?? []).join('\n'), isMobile),
            _buildInfoRow(
                '수업 시작일', widget.user.data['lessonStartDate'], isMobile),
            _buildInfoRow(
                '수업 종료일',
                widget.user.data['modifiedLessonEndDate'] ??
                    widget.user.data['lessonEndDate'],
                isMobile),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow('수업 취소',
                '${widget.user.data['cancelCountLeft'] ?? 0}회', isMobile
                // '수업 취소 (잔여/전체)',
                // '${widget.user.data['cancelCountLeft']}회 / ${widget.user.data['cancelCountTotal']}회',
                ),
            _buildInfoRow(
                '장기 홀드', '${widget.user.data['holdCountLeft'] ?? 0}회', isMobile
                // '장기 홀드 (잔여/전체)',
                // '${widget.user.data['holdCountLeft']}회 / ${widget.user.data['holdCountTotal']}회',
                ),
            _buildInfoRow(
                '적립금',
                '${NumberFormat("###,###").format(widget.user.data['points'] ?? 0)}원',
                isMobile),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String content, bool isMobile) {
    var children = [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.amber[100],
        ),
        width: 120,
        height: 32,
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              // color: Colors.white,
              // fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        content,
        textAlign: !isMobile ? TextAlign.left : TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      // const SizedBox(height: 10),
    ];
    return Expanded(
      child: !isMobile
          ? Row(
              children: children,
            )
          : Column(
              children: children,
            ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    // modifiedLessonEndDate 계산
    _updateLessonInformation();

    DateTime lessonStartDate;
    DateTime lastLessonDate;
    Map<int, DateTime> lessonDates = {};
    List<dynamic> cancelDates = [];
    List<dynamic> tutorCancelDates = [];
    List<dynamic> cancelRequestDates = [];
    List<dynamic> holdDates = [];
    List<dynamic> holdRequestDates = [];
    try {
      lessonStartDate = DateTime.parse(
          widget.user.data['lessonStartDate'].replaceAll('. ', '-'));
      lastLessonDate = DateTime.parse(
          widget.user.data['modifiedLessonEndDate'].replaceAll('. ', '-'));
    } catch (e) {
      if (kDebugMode) {
        print('lessonStartDate / modifiedLessonEndDate parsing failed. $e');
      }
      return StudentDataSource(appointments);
    }

    // lessonTime 파싱
    lessonDates =
        _getLessonDatesFromLessonTime(widget.user.data['lessonTime'] ?? []);

    if (widget.user.data.containsKey('cancelDates')) {
      try {
        cancelDates = widget.user.data['cancelDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('cancelDates parsing failed. $e');
        }
      }
    }
    if (widget.user.data.containsKey('tutorCancelDates')) {
      try {
        tutorCancelDates = widget.user.data['tutorCancelDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('tutorCancelDates parsing failed. $e');
        }
      }
    }
    if (widget.user.data.containsKey('cancelRequestDates')) {
      try {
        cancelRequestDates = widget.user.data['cancelRequestDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('cancelRequestDates parsing failed. $e');
        }
      }
    }
    if (widget.user.data.containsKey('holdDates')) {
      try {
        List<DateTime> parsedHoldDates = [];

        for (String range in widget.user.data['holdDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1]);

            if (startDate.isBefore(endDate) ||
                startDate.isAtSameMomentAs(endDate)) {
              for (int i = 0;
                  startDate.add(Duration(days: i)).isBefore(endDate) ||
                      startDate
                          .add(Duration(days: i))
                          .isAtSameMomentAs(endDate);
                  i++) {
                parsedHoldDates.add(startDate.add(Duration(days: i)));
              }
            }
          }
        }
        holdDates = parsedHoldDates;
      } catch (e) {
        if (kDebugMode) {
          print('holdDates parsing failed. $e');
        }
      }
    }
    if (widget.user.data.containsKey('holdRequestDates')) {
      try {
        for (String range in widget.user.data['holdRequestDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1]);

            if (startDate.isBefore(endDate) ||
                startDate.isAtSameMomentAs(endDate)) {
              for (int i = 0;
                  startDate.add(Duration(days: i)).isBefore(endDate) ||
                      startDate
                          .add(Duration(days: i))
                          .isAtSameMomentAs(endDate);
                  i++) {
                holdRequestDates.add(startDate.add(Duration(days: i)));
              }
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('holdRequestDates parsing failed. $e');
        }
      }
    }

    // 후기 작성 계산
    // 최근 리뷰 작성일 이후로 완료된 수업 일수를 계산하여
    // 주간 수업 횟수 * 4가 되면 리뷰 작성 활성화
    // 리뷰를 작성할 경우 리뷰 작성일을 업데이트하고, DB에 반영
    DateTime lastFeedbackDate =
        DateTime.tryParse(widget.user.data['lastFeedbackDate'] ?? '') ??
            DateTime.parse(widget.user.data['lessonStartDate']);
    var lessonCountAfterFeedback = 0;
    var lessonsToFeedback = lessonDates.length * 4;

    DateTime currentLessonDate = lessonStartDate;
    while (currentLessonDate.isBefore(lastLessonDate) ||
        currentLessonDate.isAtSameMomentAs(lastLessonDate)) {
      if (lessonDates.keys.contains(currentLessonDate.weekday)) {
        Color appointmentColor;
        String subject;

        DateTime lessonTime = lessonDates[currentLessonDate.weekday]!;
        DateTime currentLessonTime = DateTime(
          currentLessonDate.year,
          currentLessonDate.month,
          currentLessonDate.day,
          lessonTime.hour,
          lessonTime.minute,
        );

        var mmdd = DateFormat('MM-dd').format(currentLessonDate);
        var yymmdd = DateFormat('yyyy-MM-dd').format(currentLessonDate);
        if (holidayData.keys.contains(mmdd)) {
          appointmentColor = Colors.red;
          subject = '[휴일] ${holidayData[mmdd]}';
        } else if (breakdayData.keys.contains(yymmdd)) {
          appointmentColor = Colors.red;
          subject = '[임시휴일] ${breakdayData[yymmdd]}';
        } else if (cancelDates.contains(currentLessonDate)) {
          appointmentColor = Colors.red;
          subject = '[수업 취소] 학생 취소';
        } else if (tutorCancelDates.contains(currentLessonDate)) {
          appointmentColor = Colors.red.shade900;
          subject = '[수업 취소] 튜터 취소';
        } else if (cancelRequestDates.contains(currentLessonDate)) {
          appointmentColor = Colors.orange;
          subject = '[수업 취소중]';
        } else if (holdDates.contains(currentLessonDate)) {
          appointmentColor = Colors.grey;
          subject = '[장기 홀드]';
        } else if (holdRequestDates.contains(currentLessonDate)) {
          appointmentColor = Colors.orange;
          subject = '[장기 홀드중]';
        } else {
          appointmentColor = Colors.blue;
          subject =
              '[수업] ${lessonTime.hour}:${lessonTime.minute.toString().padLeft(2, '0')}';
        }

        if (!(DateTime.now().year == currentLessonTime.year &&
                DateTime.now().month == currentLessonTime.month &&
                DateTime.now().day == currentLessonTime.day) &&
            (DateTime.now().isAfter(currentLessonTime))) {
          if (subject.contains('[수업]')) {
            appointmentColor = const Color.fromARGB(255, 171, 212, 245);
            subject = '[수업 종료]';
            if (currentLessonTime.isAfter(lastFeedbackDate)) {
              lessonCountAfterFeedback++;
              if (lessonCountAfterFeedback >= lessonsToFeedback) {
                feedbackNeeded = true;
              }
            }
          }
        }

        appointments.add(
          Appointment(
            startTime: currentLessonTime,
            endTime: currentLessonTime.add(const Duration(minutes: 29)),
            color: appointmentColor,
            subject: subject,
            isAllDay: true,
          ),
        );
      }

      currentLessonDate = currentLessonDate.add(const Duration(days: 1));
    }
    return StudentDataSource(appointments);
  }

  Map<int, DateTime> _getLessonDatesFromLessonTime(List<dynamic> lessonTime) {
    Map<int, DateTime> lessonDates = {};

    for (var line in lessonTime) {
      var parts = line.split('-');
      if (parts.length == 2) {
        String daysStr = parts[0].trim();
        String timeStr = parts[1].trim();

        daysStr.runes.forEach((int rune) {
          var day = String.fromCharCode(rune);
          int targetDay = getWeekdayFromString(day);
          var timeParts = timeStr.split(':');
          int hour = int.tryParse(timeParts[0]) ?? 0;
          int minute = int.tryParse(timeParts[1]) ?? 0;
          lessonDates[targetDay] = DateTime(0, 0, 0, hour, minute);
        });
      }
    }

    return lessonDates;
  }

  // Widget _buildCustomAppointment(BuildContext context,
  //     CalendarAppointmentDetails calendarAppointmentDetails) {
  //   final Appointment appointment =
  //       calendarAppointmentDetails.appointments.first;
  //   return Column(
  //     children: [
  //       Container(
  //           width: calendarAppointmentDetails.bounds.width,
  //           height: calendarAppointmentDetails.bounds.height / 2,
  //           color: appointment.color,
  //           child: Center(
  //             child: Icon(
  //               Icons.group,
  //               color: Colors.black,
  //             ),
  //           )),
  //       Container(
  //         width: calendarAppointmentDetails.bounds.width,
  //         height: calendarAppointmentDetails.bounds.height / 2,
  //         color: appointment.color,
  //         child: Text(
  //           appointment.subject,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(fontSize: 10),
  //         ),
  //       )
  //     ],
  //   );
  // }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isSameMonth(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month;
  }

  // Widget _buildMonthCell(BuildContext context, MonthCellDetails details) {
  //   //   if (details.appointments.isNotEmpty) {
  //   //     Appointment appointment = details.appointments[0] as Appointment;
  //   //     return Container(
  //   //       color: appointment.color,
  //   //       child: Text(details.date.day.toString() + '\n' + appointment.subject),
  //   //     );
  //   //   }
  //   //   return Container(
  //   //     // color: Colors.blueGrey,
  //   //     child: Text(details.date.day.toString()),
  //   //   );
  //   // }
  //   final DateTime date = details.date;
  //   final DateTime today = DateTime.now();
  //   final List<Object> appointments = details.appointments;

  //   Color borderColor;
  //   if (appointments
  //       .any((appointment) => (appointment as Appointment).subject == '수업')) {
  //     borderColor = Colors.blue;
  //   } else if (appointments
  //       .any((appointment) => (appointment as Appointment).subject == '수업취소')) {
  //     borderColor = Colors.red;
  //   } else if (appointments.any(
  //       (appointment) => (appointment as Appointment).subject == '수업 취소 요청중')) {
  //     borderColor = Colors.orange;
  //   } else if (appointments
  //       .any((appointment) => (appointment as Appointment).subject == '장기홀드')) {
  //     borderColor = Colors.grey;
  //   } else {
  //     borderColor = Colors.transparent;
  //   }

  //   return Opacity(
  //       opacity:
  //           isSameMonth(date, _calendarController.displayDate) ? 1.0 : 0.2,
  //       child: Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(color: borderColor, width: 2.0),
  //           ),
  //           child: Ink(
  //             decoration: ShapeDecoration(
  //               shape: const CircleBorder(),
  //               color: isSameDate(today, date)
  //                   ? customTheme.colorScheme.secondary
  //                   : customTheme.colorScheme.background,
  //               // 터치 가능한 원의 배경색을 설정합니다.
  //             ),
  //             child: InkWell(
  //               onTap: () {
  //                 // 여기에서 원 클릭 시 동작을 추가할 수 있습니다.
  //               },
  //               child: Center(
  //                 child: Text(
  //                   date.day.toString(),
  //                   style: TextStyle(
  //                     color: isSameDate(today, date)
  //                         ? Colors.white
  //                         : date.weekday == 7
  //                             ? Colors.red
  //                             : date.weekday == 6
  //                                 ? Colors.blue
  //                                 : customTheme.colorScheme.primary,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )));
  // }

  PersistentBottomSheetController? _bottomSheetController;

  void _buildOnTapWidget(CalendarTapDetails details) {
    if (selectedDate == details.date! && isBottomSheetOpened) {
      _bottomSheetController?.close();
      isBottomSheetOpened = false;
      return;
    }
    if (details.targetElement == CalendarElement.calendarCell ||
        details.targetElement == CalendarElement.appointment) {
      selectedDate = details.date!;
      calendarController.selectedDate = selectedDate;
      List selectedAppointments = details.appointments!
          .where((appointment) =>
              appointment.startTime.year == selectedDate.year &&
              appointment.startTime.month == selectedDate.month &&
              appointment.startTime.day == selectedDate.day)
          .toList();
      if (selectedAppointments.isNotEmpty) {
        _bottomSheetController = showBottomSheet(
          context: context,
          backgroundColor: Colors.grey[200],
          builder: (BuildContext context) {
            isBottomSheetOpened = true;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: _buildLessonCancelMenu(details),
            );
          },
        );
      } else {
        _bottomSheetController?.close();
      }
    }
  }

  dynamic _buildLessonCancelMenu(CalendarTapDetails details) {
    String message = '';
    List<(String, String, IconData, MaterialAccentColor, bool)> buttonText = [];

    details.appointments!
        .where((appointment) =>
            appointment.startTime.year == details.date!.year &&
            appointment.startTime.month == details.date!.month &&
            appointment.startTime.day == details.date!.day)
        .forEach(
      (appointment) {
        if ((appointment as Appointment).subject.contains('[수업 취소] 학생 취소')) {
          message = '해당 일자의 수업은 학생의 요청에 의해 취소 처리되었습니다.\n재개를 원하시면 관리자에게 문의하세요.';
          if (widget.isAdmin == true) {
            buttonText.add((
              '🛡수업 재개 (학생 취소)',
              '',
              Icons.play_circle_outlined,
              Colors.indigoAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[수업 취소] 튜터 취소')) {
          message = '해당 일자의 수업은 튜터에 의해 취소 처리되었습니다.\n자세한 내용은 관리자에게 문의하세요.';
          if (widget.isAdmin == true) {
            buttonText.add((
              '🛡수업 재개 (튜터 취소)',
              '',
              Icons.play_circle_outlined,
              Colors.indigoAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[수업 취소중]')) {
          message = '해당 일자의 수업은 취소 요청 상태입니다.';
          buttonText.add((
            '수업 재개',
            '',
            Icons.play_circle_outlined,
            Colors.indigoAccent,
            true,
          ));
          if (widget.isAdmin == true) {
            buttonText.add((
              '🛡수업 취소 확정',
              '',
              Icons.check_circle_outline_outlined,
              Colors.redAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[장기 홀드]')) {
          message = '해당 일자의 수업은 장기 홀드 처리되었습니다.\n해제를 원하시면 관리자에게 문의하세요.';
          if (widget.isAdmin == true) {
            buttonText.add((
              '🛡장기 홀드 취소',
              '',
              Icons.play_circle_outlined,
              Colors.indigoAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[장기 홀드중]')) {
          message = '해당 일자의 수업은 장기 홀드 요청 상태입니다.';
          buttonText.add((
            '장기 홀드 해제',
            '',
            Icons.sync_outlined,
            Colors.lightBlueAccent,
            true,
          ));
          if (widget.isAdmin == true) {
            buttonText.add((
              '🛡장기 홀드 확정',
              '',
              Icons.check_circle_outline_outlined,
              Colors.redAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[수업 종료]')) {
          message = '종료된 수업입니다.';
        } else if (appointment.subject.contains('[수업]')) {
          DateTime now = DateTime.now();
          DateTime limitTime =
              appointment.startTime.subtract(const Duration(hours: 12));
          if (!now.isBefore(limitTime)) {
            message = '정상 수업 예정입니다.\n(수업 취소 / 장기 홀드는 수업 시작 12시간 전까지만 가능합니다.)';
          } else {
            message = '정상 수업 예정입니다.';
            buttonText.add((
              '수업 취소',
              '잔여 횟수 : ${widget.user.data['cancelCountLeft'] ?? 0}/${widget.user.data['cancelCountTotal'] ?? 0}',
              Icons.play_disabled_outlined,
              Colors.redAccent,
              (widget.user.data['cancelCountLeft'] ?? 0) > 0,
            ));
            buttonText.add((
              '장기 홀드',
              '잔여 횟수 : ${widget.user.data['holdCountLeft'] ?? 0}/${widget.user.data['holdCountTotal'] ?? 0}',
              Icons.sync_disabled_outlined,
              Colors.orangeAccent,
              (widget.user.data['holdCountLeft'] ?? 0) > 0,
            ));
            if (widget.isAdmin == true) {
              buttonText.add((
                '🛡튜터 취소',
                '',
                Icons.check_circle_outline_outlined,
                Colors.blueAccent,
                true,
              ));
            }
          }
        }
      },
    );
    return [
      if (buttonText.isNotEmpty) ListTile(title: Text(message)),
      ...buttonText.map(
        (items) {
          var text1 = items.$1;
          var text2 = items.$2;
          var icon = items.$3;
          var mainColor = items.$5 ? items.$4[700] : Colors.grey[700];
          var highlightColor = items.$4[100];
          var tileColor =
              items.$5 ? items.$4.withOpacity(0.2) : Colors.grey[400];
          return ListTile(
            leading: Icon(icon, color: mainColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text1,
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.w600)),
                Text(
                  text2,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            tileColor: tileColor,
            enabled: items.$5,
            hoverColor: highlightColor,
            onTap: () {
              // 요청 처리 로직 추가
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(details.date!);
              if (items.$1 == '수업 취소') {
                if (!widget.user.data['cancelRequestDates']
                    .contains(formattedDate)) {
                  widget.user.data['cancelRequestDates'].add(formattedDate);
                  widget.user.data['cancelCountLeft'] =
                      widget.user.data['cancelCountLeft'] - 1;
                }
              } else if (items.$1 == '수업 재개') {
                if (widget.user.data['cancelRequestDates']
                    .remove(formattedDate)) {
                  widget.user.data['cancelCountLeft'] =
                      widget.user.data['cancelCountLeft'] + 1;
                }
              } else if (items.$1 == '장기 홀드') {
                // widget.user.data['holdCountLeft'] = widget.user.data['holdCountLeft'] - 1;
                selectedHoldStartDate = formattedDate;
                // widget.user.data['holdRequestDates'].add(formattedDate);
                _bottomSheetController?.close(); // Close the bottom sheet
                _bottomSheetController = showBottomSheet(
                  context: context,
                  backgroundColor: Colors.grey[200],
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                            title: Text(
                                '장기 홀드 마지막 날짜를 선택해주세요. (시작일: $selectedHoldStartDate)')),
                        ListTile(
                          leading: Icon(Icons.cancel, color: mainColor),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '취소',
                                style: TextStyle(
                                  color: mainColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          tileColor: tileColor,
                          hoverColor: highlightColor,
                          onTap: () {
                            selectedHoldStartDate = '';
                            _bottomSheetController?.close();
                          },
                        ),
                      ],
                    );
                  },
                );
                setState(() {
                  selectedHoldStartDate = formattedDate;
                });
                return;
              } else if (items.$1 == '장기 홀드 해제') {
                for (String range in widget.user.data['holdRequestDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      widget.user.data['holdRequestDates'].remove(range);
                      widget.user.data['holdCountLeft'] =
                          widget.user.data['holdCountLeft'] + 1;
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡수업 취소 확정') {
                widget.user.data['cancelRequestDates'].remove(formattedDate);
                widget.user.data['cancelDates'].add(formattedDate);
              } else if (items.$1 == '🛡수업 재개 (학생 취소)') {
                if (widget.user.data['cancelDates'].remove(formattedDate)) {
                  widget.user.data['cancelCountLeft'] =
                      widget.user.data['cancelCountLeft'] + 1;
                }
              } else if (items.$1 == '🛡장기 홀드 확정') {
                for (String range in widget.user.data['holdRequestDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      widget.user.data['holdRequestDates'].remove(range);
                      widget.user.data['holdDates'].add(range);
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡장기 홀드 취소') {
                for (String range in widget.user.data['holdDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      widget.user.data['holdDates'].remove(range);
                      widget.user.data['holdCountLeft'] =
                          widget.user.data['holdCountLeft'] + 1;
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡튜터 취소') {
                widget.user.data['tutorCancelDates'].add(formattedDate);
              } else if (items.$1 == '🛡수업 재개 (튜터 취소)') {
                if (widget.user.data['tutorCancelDates']
                    .remove(formattedDate)) {}
              }
              _bottomSheetController?.close();
              _updateLessonInformation();
              Provider.of<StudentProvider>(context, listen: false)
                  .updateStudentToFirestoreWithMap(widget.user)
                  .then((context) {
                setState(() {
                  if (widget.updated != null) widget.updated!('');
                });
              });
            },
          );
        },
      ),
    ];
  }

  void _updateLessonInformation() {
    // 마지막 수업일 계산
    var data = widget.user.data;

    // 수업취소
    var cancelDates = ((data['cancelDates'] ?? []) +
            (data['cancelRequestDates'] ?? []) +
            (data['tutorCancelDates'] ?? []))
        .map((e) => DateTime.tryParse(e))
        .toSet();

    // 장기홀드
    for (String dateRange
        in ((data['holdDates'] ?? []) + (data['holdRequestDates'] ?? []))) {
      List<String> dateRangeParts = dateRange.split("~");
      if (dateRangeParts.length == 2) {
        DateTime startDate =
            DateTime.parse(dateRangeParts[0].replaceAll('. ', '-'));
        DateTime endDate =
            DateTime.parse(dateRangeParts[1].replaceAll('. ', '-'));

        // startDate와 endDate 사이에 있는 날짜를 확인하면서 lessonDays에 포함된 weekDay를 count
        for (DateTime date = startDate;
            date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
            date = date.add(const Duration(days: 1))) {
          cancelDates.add(date);
        }
      }
    }

    List<int> lessonDays =
        _getLessonDatesFromLessonTime(data['lessonTime'] ?? []).keys.toList();
    if (lessonDays.isEmpty) return;

    var lessonStartDate =
        DateTime.parse(data['lessonStartDate'].replaceAll('. ', '-'));
    var lessonEndDate =
        DateTime.parse(data['lessonEndDate'].replaceAll('. ', '-'));
    var today = lessonStartDate;
    while (today.isBefore(lessonEndDate) ||
        today.isAtSameMomentAs(lessonEndDate)) {
      if (lessonDays.contains(today.weekday)) {
        if (cancelDates.contains(today) ||
            holidayData.keys.contains(DateFormat('MM-dd').format(today)) ||
            breakdayData.keys
                .contains(DateFormat('yyyy-MM-dd').format(today))) {
          lessonEndDate = lessonEndDate.add(const Duration(days: 1));
          while (!lessonDays.contains(lessonEndDate.weekday)) {
            lessonEndDate = lessonEndDate.add(const Duration(days: 1));
          }
        }
      }
      today = today.add(const Duration(days: 1));
    }

    // 데이터 저장
    String formattedDate = DateFormat('yyyy-MM-dd').format(lessonEndDate);
    widget.user.data['modifiedLessonEndDate'] = formattedDate;
  }
}

class StudentDataSource extends CalendarDataSource {
  StudentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

int getWeekdayFromString(String weekday) {
  return '월화수목금토일'.indexOf(weekday) + 1;
}

String getWeekdayFromNumber(int weekday) {
  weekday = weekday % 7;
  return '일월화수목금토'[weekday];
}
