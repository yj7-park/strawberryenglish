import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen1Gridview extends StatelessWidget {
  const AdminDashboardScreen1Gridview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            child: GridView.extent(
              shrinkWrap: true,
              maxCrossAxisExtent: 1000,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 1.5,
              children: [
                // LineChart(LineChartData())
                Container(
                  color: Colors.amber.shade50,
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          verticalInterval: 1,
                        ),
                        minX: 1023,
                        maxX: 1032,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) => SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 10,
                                child: Text(
                                  DateFormat('MM-dd').format(
                                    DateTime(
                                      (value / 10000).toInt(),
                                      ((value / 100) % 100).toInt(),
                                      (value % 100).toInt(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            curveSmoothness: 0.1,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            // dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                            spots: [
                              FlSpot(1024, 2.8),
                              FlSpot(1025, 1.9),
                              FlSpot(1026, 3),
                              FlSpot(1028, 1.3),
                              FlSpot(1030, 2.5),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(color: Colors.amber.shade100),
                Container(color: Colors.amber.shade200),
                Container(color: Colors.amber.shade300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
