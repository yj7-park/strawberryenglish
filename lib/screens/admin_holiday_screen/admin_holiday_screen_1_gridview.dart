import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminHolidayScreen1Gridview extends StatelessWidget {
  const AdminHolidayScreen1Gridview({
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
                    child: LineChart(LineChartData(lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        curveSmoothness: 0.1,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        // dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                        spots: [
                          FlSpot(1, 2.8),
                          FlSpot(3, 1.9),
                          FlSpot(6, 3),
                          FlSpot(10, 1.3),
                          FlSpot(13, 2.5),
                        ],
                      )
                    ]))),
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
