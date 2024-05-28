import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class TuitionfeeScreen1Table extends StatelessWidget {
  const TuitionfeeScreen1Table({
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
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 50.0,
            ),
            child: SizedBox(
              width: screenWidth > 1440
                  ? 1400
                  : screenWidth > 690
                      ? 650
                      : 300,
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 1440 ? 2 : 1,
                  childAspectRatio: screenWidth > 690 ? 1.8 : 0.42,
                  mainAxisSpacing: 50,
                  crossAxisSpacing: 100,
                ),
                children: [
                  Column(
                    children: [
                      const Text(
                        '30분 수업',
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 690 ? 2 : 1,
                          childAspectRatio: 1,
                          mainAxisSpacing: 50,
                          crossAxisSpacing: 50,
                        ),
                        children: [
                          _buildTable(30, 1, 83900, 109900, 149900),
                          _buildTable(30, 3, 69000, 89000, 119000),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '55분 수업',
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 690 ? 2 : 1,
                          childAspectRatio: 1,
                          mainAxisSpacing: 50,
                          crossAxisSpacing: 50,
                        ),
                        children: [
                          _buildTable(55, 1, 149000, 199000, 259000),
                          _buildTable(55, 3, 129000, 169000, 209000),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(int time, int months, int price1, int price2, int price3) {
    return Column(
      children: [
        Text(
          '$months개월 결제시',
          style: const TextStyle(
            // color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DataTable(
          columnSpacing: 0,
          horizontalMargin: 0,
          dataRowMinHeight: 65,
          dataRowMaxHeight: 65,
          border: TableBorder.all(),
          columns: [
            const DataColumn(
              label: SizedBox(
                width: 180,
                child: Text(''),
              ),
            ),
            DataColumn(
              label: SizedBox(
                width: 120,
                child: Text(
                  '$time분 수업',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
          rows: [
            DataRow(
              cells: [
                const DataCell(
                  Center(
                    child: Text(
                      '주 2회(4주 기준)\n"Speaking Up"',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '${NumberFormat("###,###").format(price1)} 원',
                    ),
                  ),
                ),
              ],
            ),
            DataRow(
              cells: [
                const DataCell(
                  Center(
                    child: Text(
                      '주 3회(4주 기준)\n"Speaking High"',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '${NumberFormat("###,###").format(price2)} 원',
                    ),
                  ),
                ),
              ],
            ),
            DataRow(
              cells: [
                const DataCell(
                  Center(
                    child: Text(
                      '주 5회(4주 기준)\n"Speaking High Plus"',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Text(
                      '${NumberFormat("###,###").format(price3)} 원',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
