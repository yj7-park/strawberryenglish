import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarBody extends StatefulWidget {
  final Student user;
  static String selectedHoldStartDate = '';

  const CalendarBody({super.key, required this.user});

  @override
  CalendarBodyState createState() => CalendarBodyState();
}

class CalendarBodyState extends State<CalendarBody> {
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _calendarController.selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
        vertical: 50.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            // 여기에 사용자 정보를 보여주는 위젯 추가
            _buildStudentDetails(screenHeight > 1000),
            const Divider(),
            SizedBox(
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
                  dataSource: _getCalendarDataSource(),
                  controller: _calendarController,
                  showDatePickerButton: true,
                  headerDateFormat: 'yyyy년 M월', // 원하는 형식으로 지정
                  todayHighlightColor: const Color(0xfffcc021),
                  // allowAppointmentResize: true,
                  // allowDragAndDrop: true,
                  monthViewSettings: const MonthViewSettings(
                    agendaItemHeight: 50,
                    agendaViewHeight: 60,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.appointment,
                    appointmentDisplayCount: 1,
                    showTrailingAndLeadingDates: false,
                    agendaStyle: AgendaStyle(
                        appointmentTextStyle: TextStyle(fontSize: 15.0),
                        backgroundColor: Color.fromARGB(255, 246, 246, 246)),
                    showAgenda: true,
                    navigationDirection: MonthNavigationDirection.horizontal,
                    monthCellStyle: MonthCellStyle(
                      backgroundColor: Color.fromARGB(255, 246, 246, 246),
                      todayBackgroundColor: Color.fromARGB(255, 246, 246, 246),
                    ),
                  ),
                  // monthCellBuilder: _buildMonthCell,
                  onTap: CalendarBody.selectedHoldStartDate.isEmpty
                      ? _buildOnTapWidget
                      : // 장기 홀드 끝날짜 선택
                      (details) {
                          DateTime startDate = DateTime.parse(CalendarBody
                              .selectedHoldStartDate
                              .replaceAll('. ', '-'));
                          if (details.date!.isAfter(startDate) ||
                              details.date!.isAtSameMomentAs(startDate)) {
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(details.date!);
                            widget.user.holdRequestDates!.add(
                                '${CalendarBody.selectedHoldStartDate}~$formattedDate');
                            widget.user.holdCountLeft =
                                widget.user.holdCountLeft! - 1;
                            CalendarBody.selectedHoldStartDate = '';
                            _bottomSheetController?.close();
                            _updateLastLessonDate();
                            Provider.of<StudentProvider>(context, listen: false)
                                .updateStudentToFirestore(widget.user);
                          }
                        },
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStudentDetails(bool isExpanded) {
    return ExpansionTile(
        // backgroundColor: Color.fromARGB(255, 246, 246, 246),
        // collapsedBackgroundColor: Color.fromARGB(255, 246, 246, 246),
        tilePadding: const EdgeInsets.only(
            left: 16.0, right: 16.0), // ListTile의 contentPadding 조절
        initiallyExpanded: isExpanded,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   'Information',
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            // ),
            // SizedBox(height: 10),
          ],
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('이름', '${widget.user.name}'
                      // '\n${widget.user.email}'
                      ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('수업 시간', widget.user.lessonTime!),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildInfoRow('수업 요일', widget.user.lessonDay),
                  _buildInfoRow('적립금',
                      '${NumberFormat("###,###").format(widget.user.points!)} 원'),
                ],
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 10),
                // _buildEarningInfo(student),
                _buildLessonInfo(),
                // _buildActionButtons(widget.user),
              ],
            ),
          )
        ]);
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

  Widget _buildLessonInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('튜터', widget.user.tutor!),
              _buildInfoRow('프로그램', widget.user.program!),
              _buildInfoRow('토픽', widget.user.topic!),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('수업 시작일', widget.user.lessonStartDate!),
              _buildInfoRow('수업 종료일', widget.user.modifiedLessonEndDate!),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow(
                '수업 취소 (잔여/전체)',
                '${widget.user.cancelCountLeft}회 / ${widget.user.cancelCountTotal}회',
              ),
              _buildInfoRow(
                '장기 홀드 (잔여/전체)',
                '${widget.user.holdCountLeft}회 / ${widget.user.holdCountTotal}회',
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 32.0,
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        Text(
          content,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = [];

    // modifiedLessonEndDate 계산
    _updateLastLessonDate();

    DateTime lessonStartDate;
    DateTime lastLessonDate;
    Map<int, DateTime> lessonDates = {};
    List<DateTime> cancelDates = [];
    List<DateTime> tutorCancelDates = [];
    List<DateTime> cancelRequestDates = [];
    List<DateTime> holdDates = [];
    List<DateTime> holdRequestDates = [];
    try {
      lessonStartDate =
          DateTime.parse(widget.user.lessonStartDate!.replaceAll('. ', '-'));
      lastLessonDate = DateTime.parse(
          widget.user.modifiedLessonEndDate!.replaceAll('. ', '-'));

      // lessonTime 파싱
      lessonDates = _getLessonDatesFromLessonTime(widget.user.lessonTime!);

      if (widget.user.cancelDates != null) {
        cancelDates = widget.user.cancelDates!
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      }
      if (widget.user.tutorCancelDates != null) {
        tutorCancelDates = widget.user.tutorCancelDates!
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      }
      if (widget.user.cancelRequestDates != null) {
        cancelRequestDates = widget.user.cancelRequestDates!
            .map((element) => DateTime.parse(element.replaceAll('. ', '-')))
            .toList();
      }
      if (widget.user.holdDates != null) {
        List<DateTime> parsedHoldDates = [];

        for (String range in widget.user.holdDates!) {
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
      }

      if (widget.user.holdRequestDates != null) {
        for (String range in widget.user.holdRequestDates!) {
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
      }
    } catch (e) {
      if (kDebugMode) {
        print('cal date parsing failed. $e');
      }
      return StudentDataSource(appointments);
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
  //           isSameMonth(date, _calendarController.displayDate!) ? 1.0 : 0.2,
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
    if (details.targetElement == CalendarElement.calendarCell) {
      DateTime selectedDate = details.date!;
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
        if ((appointment as Appointment).subject.contains('[수업 취소]')) {
          message = '해당 일자의 수업은 취소 처리되었습니다.\n재개를 원하시면 관리자에게 문의하세요.';
        } else if (appointment.subject.contains('[수업 취소중]')) {
          message = '해당 일자의 수업은 취소 상태입니다.';
          buttonText.add((
            '수업 재개',
            '',
            Icons.play_circle_outlined,
            Colors.indigoAccent,
            true,
          ));
        } else if (appointment.subject.contains('[장기 홀드]')) {
          message = '해당 일자의 수업은 장기 홀드 처리되었습니다.\n해제를 원하시면 관리자에게 문의하세요.';
        } else if (appointment.subject.contains('[장기 홀드중]')) {
          message = '해당 일자의 수업은 장기 홀드 상태입니다.';
          buttonText.add((
            '홀드 해제',
            '',
            Icons.sync_outlined,
            Colors.lightBlueAccent,
            true,
          ));
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
              '잔여 횟수 : ${widget.user.cancelCountLeft}/${widget.user.cancelCountTotal}',
              Icons.play_disabled_outlined,
              Colors.redAccent,
              widget.user.cancelCountLeft! > 0
            ));
            buttonText.add((
              '장기 홀드',
              '잔여 횟수 : ${widget.user.holdCountLeft}/${widget.user.holdCountTotal}',
              Icons.sync_disabled_outlined,
              Colors.orangeAccent,
              widget.user.holdCountLeft! > 0
            ));
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
          var highlightColor = items.$4[200];
          var tileColor = items.$5 ? items.$4[100] : Colors.grey[400];
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
                if (!widget.user.cancelRequestDates!.contains(formattedDate)) {
                  widget.user.cancelRequestDates!.add(formattedDate);
                  widget.user.cancelCountLeft =
                      widget.user.cancelCountLeft! - 1;
                }
              } else if (items.$1 == '수업 재개') {
                if (widget.user.cancelRequestDates!.remove(formattedDate)) {
                  widget.user.cancelCountLeft =
                      widget.user.cancelCountLeft! + 1;
                }
              } else if (items.$1 == '장기 홀드') {
                // widget.user.holdCountLeft = widget.user.holdCountLeft! - 1;
                CalendarBody.selectedHoldStartDate = formattedDate;
                // widget.user.holdRequestDates!.add(formattedDate);
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
                                '장기 홀드 끝 날짜를 선택해주세요. (시작일: ${CalendarBody.selectedHoldStartDate})')),
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
                            CalendarBody.selectedHoldStartDate = '';
                            _bottomSheetController?.close();
                          },
                        ),
                      ],
                    );
                  },
                );
                setState(() {
                  CalendarBody.selectedHoldStartDate = formattedDate;
                });
                return;
              } else if (items.$1 == '홀드 해제') {
                for (String range in widget.user.holdRequestDates!) {
                  List<String> dateParts =
                      range.split('~').map((e) => e.trim()).toList();
                  if (dateParts.length == 2) {
                    DateTime startDate = DateTime.parse(dateParts[0]);
                    DateTime endDate = DateTime.parse(dateParts[1]);

                    if (details.date!.isAtSameMomentAs(startDate) |
                        details.date!.isAtSameMomentAs(endDate) |
                        (details.date!.isBefore(endDate) &&
                            details.date!.isAfter(startDate))) {
                      widget.user.holdRequestDates!.remove(range);
                      widget.user.holdCountLeft =
                          widget.user.holdCountLeft! + 1;
                      break;
                    }
                  }
                }
              }
              _bottomSheetController?.close();
              _updateLastLessonDate();
              Provider.of<StudentProvider>(context, listen: false)
                  .updateStudentToFirestore(widget.user);
            },
          );
        },
      ),
    ];
  }

  void _updateLastLessonDate() {
    // 마지막 수업일 계산

    // 취소일 count
    // Student 취소일
    // int cancelCount = widget.user.cancelDates!.length;
    int cancelCount =
        widget.user.cancelCountTotal! - widget.user.cancelCountLeft!;

    // Tutor 취소일
    cancelCount += widget.user.tutorCancelDates!.length;

    List<int> lessonDays =
        _getLessonDatesFromLessonTime(widget.user.lessonTime!).keys.toList();

    // holdDays 계산
    if (widget.user.holdDates != null) {
      List<int> lessonDays =
          _getLessonDatesFromLessonTime(widget.user.lessonTime!).keys.toList();

      for (String dateRange in widget.user.holdDates!) {
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
    if (widget.user.holdRequestDates != null) {
      List<int> lessonDays =
          _getLessonDatesFromLessonTime(widget.user.lessonTime!).keys.toList();

      for (String dateRange in widget.user.holdRequestDates!) {
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
        DateTime.parse(widget.user.lessonEndDate!.replaceAll('. ', '-'));
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
    widget.user.modifiedLessonEndDate = formattedDate;
  }
}

class StudentDataSource extends CalendarDataSource {
  StudentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
