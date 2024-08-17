import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AdminDashboardScreen1Gridview extends StatefulWidget {
  const AdminDashboardScreen1Gridview({
    super.key,
  });

  @override
  State<AdminDashboardScreen1Gridview> createState() =>
      _AdminDashboardScreen1GridviewState();
}

class _AdminDashboardScreen1GridviewState
    extends State<AdminDashboardScreen1Gridview> {
  late Stream<List<Student>> stream;
  late CalendarDataSource calendarDataSource;
  CalendarController controller = CalendarController();

  var barData = [
    (
      StudentState.lectureOnGoing,
      Colors.greenAccent.shade700,
      0.00,
      '수업진행',
    ),
    (
      StudentState.lectureFinished,
      Colors.deepOrangeAccent.shade200,
      -0.01,
      '수업종료',
    ),
    (
      StudentState.lectureOnHold,
      Colors.orangeAccent.shade200,
      0.01,
      '장기홀드',
    ),
    (
      StudentState.registeredOnly,
      Colors.blueGrey,
      -0.02,
      '유령회원',
    ),
    (
      StudentState.registeredOnly,
      Colors.yellow,
      0.02,
      '체험대기',
    ),
  ];

  var calData = [
    (
      StudentState.lectureOnGoing,
      Colors.greenAccent.shade700,
      0.00,
      '수업전환',
    ),
    (
      StudentState.lectureOnHold,
      Colors.orangeAccent.shade200,
      0.01,
      '체험진행',
    ),
  ];

  Stream<List<Student>> getStudentListStream() async* {
    yield* FirebaseFirestore.instance.collection('users').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((e) => Student(data: e.data())).toList());
  }

  @override
  void initState() {
    stream = getStudentListStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Builder(
                builder: (context) {
                  List<Widget> children = [
                    Localizations.override(
                        context: context,
                        locale: const Locale('ko'),
                        child: _buildCalendar(context, snapshot)),
                    const SizedBox(width: 50, height: 50),
                    _buildChart(context, snapshot),
                  ];
                  return screenWidth < 2200
                      ? Column(children: children)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        );
                },
              );
            } else {
              return const SizedBox(height: 1000, width: 700);
            }
          },
        ),
      ),
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //   children: [
      //     Padding(
      //       padding: EdgeInsets.symmetric(
      //         horizontal: ((screenWidth - 2000) / 2).clamp(20, double.nan),
      //         // horizontal: ((screenWidth - 2000) / 2).clamp(20, double.nan),
      //         vertical: 50.0,
      //       ),
      //       child: StreamBuilder(
      //         stream: stream,
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return GridView.extent(
      //               shrinkWrap: true,
      //               maxCrossAxisExtent: 1000,
      //               crossAxisSpacing: 10.0,
      //               mainAxisSpacing: 10.0,
      //               childAspectRatio: 1.5,
      //               children: [
      //                 _buildCalendar(context, snapshot),
      //                 _buildChart(context, snapshot),
      //                 Container(color: Colors.amber.shade200),
      //                 Container(color: Colors.amber.shade300),
      //               ],
      //             );
      //           } else {
      //             return const Text('no data');
      //           }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildCalendar(context, snapshot) {
    return Container(
      width: 1000,
      color: Colors.amber.shade50,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    '체험 수업 일정',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  for (var e in calData)
                    Row(
                      children: [
                        Icon(Icons.circle, color: e.$2),
                        Text(e.$4),
                        const SizedBox(width: 30),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: 600,
            width: 1000,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                color: Colors.amber.shade100,
                child: SfCalendar(
                  showNavigationArrow: true,
                  showDatePickerButton: true,
                  headerDateFormat: 'yyyy년 M월   ', // 원하는 형식으로 지정
                  view: CalendarView.workWeek,
                  todayHighlightColor: const Color(0xfffcc021),
                  dataSource: _getCalendarDataSource(snapshot),
                  controller: controller,
                  timeSlotViewSettings: const TimeSlotViewSettings(
                    startHour: 8,
                    endHour: 24,
                    timeIntervalHeight: 25,
                  ),
                  onTap: (_) {
                    setState(() {});
                  },
                  allowedViews: const [
                    CalendarView.workWeek,
                    CalendarView.month,
                    CalendarView.schedule,
                  ],
                  allowAppointmentResize: false,
                  // appointmentTextStyle: TextStyle(
                  //   fontSize: 12,
                  //   color: Colors.white,
                  // ),
                  scheduleViewSettings: const ScheduleViewSettings(
                    hideEmptyScheduleWeek: true,
                  ),
                  allowDragAndDrop: true,
                  // onDragStart: null,
                  dragAndDropSettings: const DragAndDropSettings(
                      showTimeIndicator: true,
                      indicatorTimeFormat: 'h a',
                      timeIndicatorStyle: TextStyle(
                        color: Colors.red,
                        // backgroundColor: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )
                      // autoNavigateDelay: Duration(milliseconds: 500),
                      ),
                  onDragEnd: (appointmentDragEndDetails) {
                    final Appointment appointment =
                        appointmentDragEndDetails.appointment! as Appointment;
                    // final CalendarResource? sourceResource =
                    //     appointmentDragEndDetails.sourceResource;
                    // final CalendarResource? targetResource =
                    //     appointmentDragEndDetails.targetResource;
                    final DateTime draggingTime =
                        appointmentDragEndDetails.droppingTime!;
                    DateTime newTime = DateTime(
                      draggingTime.year,
                      draggingTime.month,
                      draggingTime.day,
                      draggingTime.hour < 8 ? 8 : draggingTime.hour,
                    );
                    appointment.startTime = newTime;
                    getStudentFromFirestore(appointment.notes!).then((student) {
                      var dateStrings = DateFormat('yyyy-MM-dd HH:00')
                          .format(newTime)
                          .split(' ');
                      student.data['trialDate'] = dateStrings[0];
                      student.data['trialTime'] = dateStrings[1];
                      updateStudentToFirestoreWithMap(student);
                    });
                  },
                  monthViewSettings: const MonthViewSettings(
                    agendaItemHeight: 40,
                    agendaViewHeight: 160,
                    appointmentDisplayMode:
                        MonthAppointmentDisplayMode.indicator,
                    // appointmentDisplayCount: 1,
                    // showTrailingAndLeadingDates: true,
                    agendaStyle: AgendaStyle(
                      appointmentTextStyle: TextStyle(fontSize: 12.0),
                      backgroundColor: Color.fromARGB(255, 246, 246, 246),
                    ),
                    showAgenda: true,
                    navigationDirection: MonthNavigationDirection.horizontal,
                    monthCellStyle: MonthCellStyle(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(context, snapshot) {
    var now = controller.selectedDate ?? DateTime.now();
    double startdate =
        (DateTime(now.year, now.month, 1).difference(DateTime(0)).inDays + 1)
            .toDouble();
    double enddate = (DateTime(now.year, now.month + 1, 1))
        .difference(DateTime(0))
        .inDays
        .toDouble();
    return Container(
      width: 1000,
      color: Colors.amber.shade50,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  SizedBox(width: 30),
                  Text(
                    '회원 현황',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  for (var e in barData)
                    Row(
                      children: [
                        Icon(Icons.circle, color: e.$2),
                        Text(e.$4),
                        const SizedBox(width: 30),
                      ],
                    ),
                ],
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            width: 1000,
            height: 600,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: LineChart(
                duration: const Duration(milliseconds: 500),
                LineChartData(
                  lineTouchData: LineTouchData(
                    // touchCallback: (p0, p1) {
                    //   p1.lineBarSpots
                    // },
                    touchTooltipData:
                        LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        // var date = DateTime(0).add(
                        //     Duration(days: touchedSpot.x.toInt()));
                        return LineTooltipItem(
                            '${barData[touchedSpot.barIndex].$4}, ${touchedSpot.y.toInt()}',
                            textStyle);
                      }).toList();
                    }),
                  ),
                  gridData: const FlGridData(
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    show: true,
                    horizontalInterval: 10,
                  ),
                  minX: startdate,
                  maxX: enddate,
                  minY: -5,
                  maxY: 100,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Builder(
                            builder: (context) {
                              var date = DateTime(0).add(
                                Duration(
                                  days: value.toInt(),
                                ),
                              );
                              return Text(
                                date.day % 5 == 1
                                    ? DateFormat('MM-dd').format(date)
                                    : '',
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // bottomTitles: AxisTitles(
                    //   sideTitles:
                    //       SideTitles(showTitles: false),
                    // ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value >= 0 ? value.toString() : '',
                              textAlign: TextAlign.center,
                            );
                          }),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  lineBarsData: [
                    for (var item in barData)
                      LineChartBarData(
                          // isCurved: true,
                          color: item.$2,
                          curveSmoothness: 0.1,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                          spots: [
                            for (int date = startdate.toInt();
                                date <= enddate;
                                date++)
                              getSpots(snapshot.data!, date, item.$1, item.$3)
                          ]
                          // [
                          // FlSpot(1024, 2.8),
                          // FlSpot(1025, 1.9),
                          // FlSpot(1026, 3),
                          // FlSpot(1028, 1.3),
                          // FlSpot(1030, 2.5),
                          // ],
                          )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getSpots(List<Student> list, int i, var item, var offset) {
    return FlSpot(
        i.toDouble(),
        list
                .where((e) =>
                    e.getStudentLectureState(
                        now: DateTime(0).add(Duration(days: i.toInt()))) ==
                    item)
                .length
                .toDouble() +
            offset);
  }

  CalendarDataSource _getCalendarDataSource(snapshot) {
    List<Appointment> appointments = [];
    List<CalendarResource> resourceColl = <CalendarResource>[];

    resourceColl.add(
      CalendarResource(
        displayName: 'John',
        id: '0001',
        color: Colors.red,
        image: const ExactAssetImage('images/kakao_talk.png'),
      ),
    );

    for (Student student in snapshot.data) {
      var trialTime = DateTime.tryParse(
          '${student.data['trialDate']} ${student.data['trialTime']}');
      if (trialTime != null) {
        appointments.add(
          Appointment(
            startTime: trialTime,
            endTime: trialTime.add(const Duration(hours: 1)),
            color: (student.getStudentLectureState() !=
                        StudentState.registeredOnly &&
                    student.getStudentLectureState() !=
                        StudentState.lectureRequested)
                ? Colors.greenAccent.shade700
                : Colors.orangeAccent.shade200,
            subject: '${student.data['name']} (${student.data['trialTutor']})',
            notes: '${student.data['email']}',
            resourceIds: ['0001'],
            // isAllDay: true,
          ),
        );
      }
    }

    return _AppointmentDataSource(appointments, resourceColl);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(
      List<Appointment> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  List<Object> getResourceIds(int index) {
    return appointments![index].ids;
  }
}

Future<Student> getStudentFromFirestore(String email) async {
  try {
    var values =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    // print(response.values);
    return Student(data: values.data()!);
  } catch (e) {
    if (kDebugMode) {
      print('Firestore에서 Student 가져오는 중 오류 발생: $e');
    }
  }
  throw Exception('Student를 찾을 수 없습니다.');
}

Future<void> updateStudentToFirestoreWithMap(Student updatedStudent) async {
  try {
    // currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser != null) {
    // Google Sheets에서 기존 사용자 데이터 가져오기
    FirebaseFirestore.instance
        .collection('users')
        // .doc(currentUser!.email)
        .doc(updatedStudent.data['email'])
        .set(updatedStudent.data);
    // }
  } catch (e) {
    if (kDebugMode) {
      print('Student 데이터 업데이트 중 오류 발생: $e');
    }
  }
}
