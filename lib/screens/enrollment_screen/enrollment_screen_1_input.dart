// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';

class EnrollmentScreen1Input extends StatefulWidget {
  static final fee = {
    1: {
      2: {
        30: 83900,
        55: 149000,
      },
      3: {
        30: 109900,
        55: 199000,
      },
      5: {
        30: 149900,
        55: 259000,
      },
    },
    3: {
      2: {
        30: 69000,
        55: 129000,
      },
      3: {
        30: 89000,
        55: 169000,
      },
      5: {
        30: 119000,
        55: 209000,
      },
    }
  };

  final TextEditingController lessonStartDateController;

  const EnrollmentScreen1Input({
    super.key,
    required this.lessonStartDateController,
  });

  @override
  EnrollmentScreen1InputState createState() => EnrollmentScreen1InputState();
}

class EnrollmentScreen1InputState extends State<EnrollmentScreen1Input> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: ((screenWidth - 500) / 2).clamp(20, double.nan),
      ),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: 날짜
            TextFormField(
              controller: widget.lessonStartDateController,
              decoration: const InputDecoration(
                labelText: '*수업시작일',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9-]"),
                ),
                // MaskedInputFormatter('####-##-##')
              ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text('*구독기간'),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 1,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('1개월'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text('3개월'),
                ),
              ],
              showSelectedIcon: false,
              selected: EnrollmentScreen.selectedMonths,
              onSelectionChanged: (newSelection) {
                setState(() {
                  EnrollmentScreen.selectedMonths = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '*수업횟수',
            ),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 2,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('주 2회'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text('주 3회'),
                ),
                ButtonSegment(
                  value: 5,
                  label: Text('주 5회'),
                ),
              ],
              showSelectedIcon: false,
              selected: EnrollmentScreen.selectedDays,
              onSelectionChanged: (newSelection) {
                setState(() {
                  EnrollmentScreen.selectedDays = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '*수업길이',
            ),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 30,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text('30분'),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 55,
                  label: Text('55분'),
                ),
              ],
              showSelectedIcon: false,
              selected: EnrollmentScreen.selectedMins,
              onSelectionChanged: (newSelection) {
                setState(() {
                  EnrollmentScreen.selectedMins = newSelection;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
                '${EnrollmentScreen.selectedMonths.first}개월 주 ${EnrollmentScreen.selectedDays.first}회 ${EnrollmentScreen.selectedMins.first}분'),
            Text(
                '${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first]! * EnrollmentScreen.selectedMonths.first)}원'),
            Text(
                '월(${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first])}원)'),
          ],
        ),
      ),
    );
  }
}
