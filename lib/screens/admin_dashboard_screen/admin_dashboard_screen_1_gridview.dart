import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:fl_chart/fl_chart.dart';

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
    var now = DateTime.now();
    double startdate =
        (DateTime(now.year, now.month - 1, 1).difference(DateTime(0)).inDays +
                1)
            .toDouble();
    double enddate = (DateTime(now.year, now.month, 1))
        .difference(DateTime(0))
        .inDays
        .toDouble();
    return Theme(
      data: customTheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ((screenWidth - 2000) / 2).clamp(20, double.nan),
              // horizontal: ((screenWidth - 2000) / 2).clamp(20, double.nan),
              vertical: 50.0,
            ),
            child: StreamBuilder(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.extent(
                    shrinkWrap: true,
                    maxCrossAxisExtent: 1000,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 1.5,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            color: Colors.amber.shade50,
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  height: constraints.maxHeight - 100,
                                  width: constraints.maxWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: LineChart(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      LineChartData(
                                        lineTouchData: LineTouchData(
                                          // touchCallback: (p0, p1) {
                                          //   p1.lineBarSpots
                                          // },
                                          touchTooltipData:
                                              LineTouchTooltipData(
                                                  getTooltipItems:
                                                      (touchedSpots) {
                                            return touchedSpots
                                                .map((LineBarSpot touchedSpot) {
                                              final textStyle = TextStyle(
                                                color: touchedSpot.bar.gradient
                                                        ?.colors[0] ??
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
                                        maxY: 10,
                                        titlesData: FlTitlesData(
                                          bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                              showTitles: true,
                                              interval: 1,
                                              reservedSize: 32,
                                              getTitlesWidget: (value, meta) =>
                                                  SideTitleWidget(
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
                                                          ? DateFormat('MM-dd')
                                                              .format(date)
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
                                                    value >= 0
                                                        ? value.toString()
                                                        : '',
                                                    textAlign: TextAlign.center,
                                                  );
                                                }),
                                          ),
                                          rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
                                          ),
                                          topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false),
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
                                                dotData: const FlDotData(
                                                    show: false),
                                                belowBarData:
                                                    BarAreaData(show: false),
                                                spots: [
                                                  for (int date =
                                                          startdate.toInt();
                                                      date <= enddate;
                                                      date++)
                                                    getSpots(snapshot.data!,
                                                        date, item.$1, item.$3)
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
                        },
                      ),
                      Container(color: Colors.amber.shade100),
                      Container(color: Colors.amber.shade200),
                      Container(color: Colors.amber.shade300),
                    ],
                  );
                } else {
                  return const Text('no data');
                }
              },
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
}
