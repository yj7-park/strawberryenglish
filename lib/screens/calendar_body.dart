import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:provider/provider.dart';
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

class CalendarBodyState extends State<CalendarBody>
    with SingleTickerProviderStateMixin {
  late CalendarController calendarController;
  late TabController tabController;

  String selectedHoldStartDate = '';
  DateTime selectedDate = DateTime.now();
  bool isBottomSheetOpened = false;

  @override
  void initState() {
    super.initState();

    var lectures = widget.user.lectures ?? {};

    calendarController = CalendarController();
    calendarController.selectedDate = DateTime.now();

    tabController = TabController(
      length: lectures.length,
      vsync: this,
      // initialIndex: 0,

      /// 탭 변경 애니메이션 시간
      animationDuration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 1000 || widget.updated != null;
    var lectures = widget.user.lectures ?? {};
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.updated == null
            ? ((screenWidth - 1000) / 2).clamp(20, double.nan)
            : 20,
        vertical: widget.updated == null ? 50.0 : 20,
      ),
      child: DefaultTabController(
        length: lectures.length,
        child: SizedBox(
          // TODO: 적절한 높이 값 지정 필요
          height: 1000,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // 장기 홀드 날짜 지정 중에는 탭을 바꿀 수 없도록 (오작동 방지)
              title: IgnorePointer(
                ignoring: selectedHoldStartDate.isNotEmpty,
                child: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  tabs: lectures.keys.map((k) => Tab(text: k)).toList(),
                ),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: lectures.values
                  .map(
                    (lecture) => SingleChildScrollView(
                      child: Column(
                        children: [
                          // 수업 중인 상태
                          if ((lecture.data['tutor'] ?? '').isNotEmpty) ...[
                            const Divider(),
                            // 여기에 사용자 정보를 보여주는 위젯 추가
                            _buildStudentDetails(
                                lecture, screenHeight > 1000, isMobile),
                            const Divider(),
                            _buildCalendar(lecture),
                          ]
                          // 수강 신청 중인 상태
                          else if ((lecture.data['lessonEndDate'] ?? '')
                              .isNotEmpty) ...[
                            const Text('수강 신청이 완료되어, 일정을 확인 중입니다.'),
                            const Text('수업 일정이 확정되면 카카오톡으로 연락 드리겠습니다.'),
                            const Text(
                                '신청 정보 수정이 필요하시면 [수강신청] 버튼을 눌러 수정하실 수 있습니다.'),
                          ]
                          // 체험 중인 상태
                          else if ((lecture.data['trialTutor'] ?? '')
                              .isNotEmpty) ...[
                            Text(
                              """
*체험 수업 확정

${widget.user.data['name']} 님의 체험 수업이 확정되었습니다 :)

날짜: ${DateFormat('yyyy년 MM월 dd일').format(DateTime.parse(widget.user.data['trialDate']))} ${_getWeekdayFromNumber(DateTime.parse(widget.user.data['trialDate']).weekday)}요일

시간: ${DateFormat('hh시 mm분').format(DateTime.parse(widget.user.data['trialDate']))} (한국시간)

Tutor: ${widget.user.data['trialTutor'] ?? ''}
 
체험 수업은 20분간 레벨 테스트 목적으로 진행되며 정규 수업과 수업 방식이 다르다는 점 안내드립니다 :)

튜터 분이 스카이프를 통해 친구 요청 메시지를 전달 드릴 예정입니다.
원활한 체험 수업 진행을 위해 수업 시작 30분 전까지 친구 수락이 되어야 체험 수업이 확정된다는 점 꼭 확인해 주세요.

감사합니다.
Enjoy your English with 🍓""",
                              textAlign: TextAlign.center,
                            ),
                          ]
                          // 체험 신청 중인 상태
                          else if ((lecture.data['trialDay'] ?? '')
                              .isNotEmpty) ...[
                            const Text('체험 수업 신청이 완료되어, 일정을 확인 중입니다.'),
                            const Text('체험 수업 일정이 확정되면 카카오톡으로 연락 드리겠습니다.'),
                            const Text(
                                '신청 정보 수정이 필요하시면 [체험하기] 버튼을 눌러 수정하실 수 있습니다.'),
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
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentDetails(Lecture lecture, bool isExpanded, bool isMobile) {
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
        //           _buildInfoRow('수업 시간', lecture.data['lessonTime']),
        //         ],
        //       ),
        //     ),
        //     Expanded(
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           // _buildInfoRow('수업 요일', lecture.data['lessonDay']),
        //           _buildInfoRow('적립금',
        //               '${NumberFormat("###,###").format(widget.user.data['points'] ?? 0)} 원'),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                // const SizedBox(height: 10),
                // _buildEarningInfo(student),
                _buildLessonInfo(lecture, isMobile),
            // _buildActionButtons(widget.user),
          ),
        ]);
  }

  Widget _buildCalendar(Lecture lecture) {
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
          dataSource: _getCalendarDataSource(lecture),
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
          onTap: ((details) {
            if (selectedHoldStartDate.isEmpty) {
              _buildOnTapWidget(lecture, details);
            } else {
              // 장기 홀드 끝날짜 선택
              DateTime startDate =
                  DateTime.parse(selectedHoldStartDate.replaceAll('. ', '-'));
              if (details.date!.isAfter(startDate) ||
                  details.date!.isAtSameMomentAs(startDate)) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(details.date!);
                lecture.data['holdRequestDates']
                    .add('$selectedHoldStartDate~$formattedDate');
                lecture.data['holdCountLeft'] =
                    lecture.data['holdCountLeft'] - 1;
                selectedHoldStartDate = '';
                _bottomSheetController?.close();
                _updateLastLessonDate(lecture);
                Provider.of<StudentProvider>(context, listen: false)
                    .updateStudentToFirestoreWithMap(widget.user)
                    .then((context) {
                  setState(() {
                    if (widget.updated != null) widget.updated!('');
                  });
                });
              }
            }
          }),
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

  Widget _buildLessonInfo(Lecture lecture, bool isMobile) {
    return Column(
      children: [
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow('이름', '${widget.user.data['name']}', isMobile),
            _buildInfoRow('튜터', lecture.data['tutor'] ?? '', isMobile),
            // _buildInfoRow('토픽', lecture.data['topic'] ?? ''),
            _buildInfoRow(
                '토픽',
                '${lecture.data['program'] ?? ''}\n${lecture.data['topic'] ?? ''}',
                isMobile),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow('수업 시간', lecture.data['lessonTime'] ?? '', isMobile),
            _buildInfoRow(
                '수업 시작일', lecture.data['lessonStartDate'] ?? '', isMobile),
            _buildInfoRow(
                '수업 종료일',
                lecture.data['modifiedLessonEndDate'] ??
                    lecture.data['lessonEndDate'] ??
                    '',
                isMobile),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment:
              isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            _buildInfoRow(
                '수업 취소', '${lecture.data['cancelCountLeft'] ?? 0}회', isMobile
                // '수업 취소 (잔여/전체)',
                // '${lecture.data['cancelCountLeft']}회 / ${lecture.data['cancelCountTotal']}회',
                ),
            _buildInfoRow(
                '장기 홀드', '${lecture.data['holdCountLeft'] ?? 0}회', isMobile
                // '장기 홀드 (잔여/전체)',
                // '${lecture.data['holdCountLeft']}회 / ${lecture.data['holdCountTotal']}회',
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

  CalendarDataSource _getCalendarDataSource(Lecture lecture) {
    List<Appointment> appointments = [];

    // modifiedLessonEndDate 계산
    _updateLastLessonDate(lecture);

    DateTime lessonStartDate;
    DateTime lastLessonDate;
    Map<int, DateTime> lessonDates = {};
    List<dynamic> cancelDates = [];
    List<dynamic> tutorCancelDates = [];
    List<dynamic> cancelRequestDates = [];
    List<dynamic> holdDates = [];
    List<dynamic> holdRequestDates = [];
    try {
      lessonStartDate =
          DateTime.parse(lecture.data['lessonStartDate'].replaceAll('. ', '-'));
      lastLessonDate = DateTime.parse(
          lecture.data['modifiedLessonEndDate'].replaceAll('. ', '-'));
    } catch (e) {
      if (kDebugMode) {
        print('lessonStartDate / modifiedLessonEndDate parsing failed. $e');
      }
      return StudentDataSource(appointments);
    }

    // lessonTime 파싱
    lessonDates = _getLessonDatesFromLessonTime(lecture.data['lessonTime']);

    if (lecture.data.containsKey('cancelDates')) {
      try {
        cancelDates = lecture.data['cancelDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('cancelDates parsing failed. $e');
        }
      }
    }
    if (lecture.data.containsKey('tutorCancelDates')) {
      try {
        tutorCancelDates = lecture.data['tutorCancelDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('tutorCancelDates parsing failed. $e');
        }
      }
    }
    if (lecture.data.containsKey('cancelRequestDates')) {
      try {
        cancelRequestDates = lecture.data['cancelRequestDates']
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      } catch (e) {
        if (kDebugMode) {
          print('cancelRequestDates parsing failed. $e');
        }
      }
    }
    if (lecture.data.containsKey('holdDates')) {
      try {
        List<DateTime> parsedHoldDates = [];

        for (String range in lecture.data['holdDates']) {
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
    if (lecture.data.containsKey('holdRequestDates')) {
      try {
        for (String range in lecture.data['holdRequestDates']) {
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

        if (cancelDates.contains(currentLessonDate)) {
          appointmentColor = Colors.red;
          subject = '[수업 취소] 학생 취소';
        } else if (tutorCancelDates.contains(currentLessonDate)) {
          appointmentColor = Colors.red.shade900;
          subject = '[수업 취소] 튜터 취소';
        } else if (cancelRequestDates.contains(currentLessonDate)) {
          appointmentColor = Colors.red.shade200;
          subject = '[수업 취소 요청 중]';
        } else if (holdDates.contains(currentLessonDate)) {
          appointmentColor = Colors.orange;
          subject = '[장기 홀드]';
        } else if (holdRequestDates.contains(currentLessonDate)) {
          appointmentColor = Colors.orange.shade200;
          subject = '[장기 홀드 요청 중]';
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

  Map<int, DateTime> _getLessonDatesFromLessonTime(String lessonTime) {
    List<String> lessonTimeLines = lessonTime.split('\n');
    Map<int, DateTime> lessonDates = {};

    for (String line in lessonTimeLines) {
      var parts = line.split('-');
      if (parts.length == 2) {
        String daysStr = parts[0].trim();
        String timeStr = parts[1].trim();

        List<String> daysList = daysStr.split(',');
        for (String day in daysList) {
          int targetDay = _getWeekdayFromString(day);
          var timeParts = timeStr.split(':');
          int hour = int.tryParse(timeParts[0]) ?? 0;
          int minute = int.tryParse(timeParts[1]) ?? 0;
          lessonDates[targetDay] = DateTime(0, 0, 0, hour, minute);
        }
      }
    }

    return lessonDates;
  }

  int _getWeekdayFromString(String weekday) {
    return '월화수목금토일'.indexOf(weekday) + 1;
  }

  String _getWeekdayFromNumber(int weekday) {
    return '월화수목금토일'[weekday];
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

  void _buildOnTapWidget(Lecture lecture, CalendarTapDetails details) {
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
              children: _buildLessonCancelMenu(lecture, details),
            );
          },
        );
      } else {
        _bottomSheetController?.close();
      }
    }
  }

  dynamic _buildLessonCancelMenu(Lecture lecture, CalendarTapDetails details) {
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
              '🛡수업 취소 신청 해제 (학생 취소)',
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
              '🛡수업 취소 신청 해제 (튜터 취소)',
              '',
              Icons.play_circle_outlined,
              Colors.indigoAccent,
              true,
            ));
          }
        } else if (appointment.subject.contains('[수업 취소 요청 중]')) {
          message = '해당 일자의 수업은 취소 요청 상태입니다.';
          buttonText.add((
            '수업 취소 신청 해제',
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
        } else if (appointment.subject.contains('[장기 홀드 요청 중]')) {
          message = '해당 일자의 수업은 장기 홀드 요청 상태입니다.';
          buttonText.add((
            '장기 홀드 신청 해제',
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
              '잔여 횟수 : ${lecture.data['cancelCountLeft'] ?? 0}/${lecture.data['cancelCountTotal'] ?? 0}',
              Icons.play_disabled_outlined,
              Colors.redAccent,
              (lecture.data['cancelCountLeft'] ?? 0) > 0,
            ));
            buttonText.add((
              '장기 홀드',
              '잔여 횟수 : ${lecture.data['holdCountLeft'] ?? 0}/${lecture.data['holdCountTotal'] ?? 0}',
              Icons.sync_disabled_outlined,
              Colors.orangeAccent,
              (lecture.data['holdCountLeft'] ?? 0) > 0,
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
      ListTile(title: Text(message)),
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
                if (!lecture.data['cancelRequestDates']
                    .contains(formattedDate)) {
                  lecture.data['cancelRequestDates'].add(formattedDate);
                  lecture.data['cancelCountLeft'] =
                      lecture.data['cancelCountLeft'] - 1;
                }
              } else if (items.$1 == '수업 취소 신청 해제') {
                if (lecture.data['cancelRequestDates'].remove(formattedDate)) {
                  lecture.data['cancelCountLeft'] =
                      lecture.data['cancelCountLeft'] + 1;
                }
              } else if (items.$1 == '장기 홀드') {
                // lecture.data['holdCountLeft'] = lecture.data['holdCountLeft'] - 1;
                selectedHoldStartDate = formattedDate;
                // lecture.data['holdRequestDates'].add(formattedDate);
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
              } else if (items.$1 == '장기 홀드 신청 해제') {
                for (String range in lecture.data['holdRequestDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      lecture.data['holdRequestDates'].remove(range);
                      lecture.data['holdCountLeft'] =
                          lecture.data['holdCountLeft'] + 1;
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡수업 취소 확정') {
                lecture.data['cancelRequestDates'].remove(formattedDate);
                lecture.data['cancelDates'].add(formattedDate);
              } else if (items.$1 == '🛡수업 취소 신청 해제 (학생 취소)') {
                if (lecture.data['cancelDates'].remove(formattedDate)) {
                  lecture.data['cancelCountLeft'] =
                      lecture.data['cancelCountLeft'] + 1;
                }
              } else if (items.$1 == '🛡장기 홀드 확정') {
                for (String range in lecture.data['holdRequestDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      lecture.data['holdRequestDates'].remove(range);
                      lecture.data['holdDates'].add(range);
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡장기 홀드 취소') {
                for (String range in lecture.data['holdDates']) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      lecture.data['holdDates'].remove(range);
                      lecture.data['holdCountLeft'] =
                          lecture.data['holdCountLeft'] + 1;
                      break;
                    }
                  }
                }
              } else if (items.$1 == '🛡튜터 취소') {
                lecture.data['tutorCancelDates'].add(formattedDate);
              } else if (items.$1 == '🛡수업 취소 신청 해제 (튜터 취소)') {
                if (lecture.data['tutorCancelDates'].remove(formattedDate)) {}
              }
              _bottomSheetController?.close();
              _updateLastLessonDate(lecture);
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

  void _updateLastLessonDate(Lecture lecture) {
    // 마지막 수업일 계산

    // 취소일 count
    // Student 취소일
    // int cancelCount = lecture.data['cancelDates'].length;
    num cancelCount = (lecture.data['cancelCountTotal'] ?? 0) -
        (lecture.data['cancelCountLeft'] ?? 0);

    // Tutor 취소일
    cancelCount += (lecture.data['tutorCancelDates'] ?? []).length;

    List<int> lessonDays =
        _getLessonDatesFromLessonTime(lecture.data['lessonTime'] ?? '')
            .keys
            .toList();
    if (lessonDays.isEmpty) return;

    // holdDays 계산
    if (lecture.data.containsKey('holdDates')) {
      List<int> lessonDays =
          _getLessonDatesFromLessonTime(lecture.data['lessonTime'])
              .keys
              .toList();

      for (String dateRange in lecture.data['holdDates']) {
        List<String> dateRangeParts = dateRange.split("~");
        if (dateRangeParts.length == 2) {
          DateTime startDate =
              DateTime.parse(dateRangeParts[0].replaceAll('. ', '-'));
          DateTime endDate =
              DateTime.parse(dateRangeParts[1].replaceAll('. ', '-'));

          int lessonDaysInRange = 0;

          // startDate와 endDate 사이에 있는 날짜를 확인하면서 lessonDays에 포함된 weekDay를 count
          for (DateTime date = startDate;
              date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
              date = date.add(const Duration(days: 1))) {
            int weekDay = date.weekday;
            if (lessonDays.contains(weekDay)) {
              lessonDaysInRange++;
            }
          }

          cancelCount += lessonDaysInRange;
        }
      }
    }
    // holdRequestDays 계산
    if (lecture.data.containsKey('holdRequestDates')) {
      List<int> lessonDays =
          _getLessonDatesFromLessonTime(lecture.data['lessonTime'])
              .keys
              .toList();

      for (String dateRange in lecture.data['holdRequestDates']) {
        List<String> dateRangeParts = dateRange.split("~");
        if (dateRangeParts.length == 2) {
          DateTime startDate =
              DateTime.parse(dateRangeParts[0].replaceAll('. ', '-'));
          DateTime endDate =
              DateTime.parse(dateRangeParts[1].replaceAll('. ', '-'));

          int lessonDaysInRange = 0;

          // startDate와 endDate 사이에 있는 날짜를 확인하면서 lessonDays에 포함된 weekDay를 count
          for (DateTime date = startDate;
              date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
              date = date.add(const Duration(days: 1))) {
            int weekDay = date.weekday;
            if (lessonDays.contains(weekDay)) {
              lessonDaysInRange++;
            }
          }

          cancelCount += lessonDaysInRange;
        }
      }
    }

    var lastLessonDate =
        DateTime.parse(lecture.data['lessonEndDate'].replaceAll('. ', '-'));
    while (!lessonDays.contains(lastLessonDate.weekday)) {
      lastLessonDate = lastLessonDate.subtract(const Duration(days: 1));
    }
    for (int i = 0; i < cancelCount; i++) {
      lastLessonDate = lastLessonDate.add(const Duration(days: 1));
      // 다음 수업 날짜를 찾을 때까지 반복합니다.
      while (!lessonDays.contains(lastLessonDate.weekday)) {
        lastLessonDate = lastLessonDate.add(const Duration(days: 1));
      }
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(lastLessonDate);
    lecture.data['modifiedLessonEndDate'] = formattedDate;
  }
}

class StudentDataSource extends CalendarDataSource {
  StudentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
