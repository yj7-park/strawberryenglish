// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

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

  static const _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

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
            const Text(
              '수강 정보',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            // TODO: 날짜
            TextFormField(
              controller: widget.lessonStartDateController,
              decoration: InputDecoration(
                labelText: '*수업시작일',
                hintText: 'YYYY-MM-DD',
                border: const OutlineInputBorder(),
                enabledBorder:
                    myOutlineInputBorder(widget.lessonStartDateController),
                focusedBorder:
                    myOutlineInputBorder(widget.lessonStartDateController),
                labelStyle: TextStyle(
                  color: widget.lessonStartDateController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9-]"),
                ),
                // MaskedInputFormatter('####-##-##')
              ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            const Text('*구독기간', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 1,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text(
                        '1개월',
                        style: EnrollmentScreen1Input._textStyle,
                      ),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text(
                    '3개월',
                    style: EnrollmentScreen1Input._textStyle,
                  ),
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
            const SizedBox(height: 30),
            const Text('*수업횟수', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 2,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text(
                        '주2회',
                        style: EnrollmentScreen1Input._textStyle,
                      ),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 3,
                  label: Text(
                    '주3회',
                    style: EnrollmentScreen1Input._textStyle,
                  ),
                ),
                ButtonSegment(
                  value: 5,
                  label: Text(
                    '주5회',
                    style: EnrollmentScreen1Input._textStyle,
                  ),
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
            const SizedBox(height: 30),
            const Text('*수업길이', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: 30,
                  label: SizedBox(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: Text(
                        '30분',
                        style: EnrollmentScreen1Input._textStyle,
                      ),
                    ),
                  ),
                ),
                ButtonSegment(
                  value: 55,
                  label: Text(
                    '55분',
                    style: EnrollmentScreen1Input._textStyle,
                  ),
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
            const SizedBox(height: 60),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: customTheme.colorScheme.secondary),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      '${EnrollmentScreen.selectedMonths.first}개월 수강권',
                    ),
                    const SizedBox(width: 30),
                    Text(
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      '( 주${EnrollmentScreen.selectedDays.first}회 / ${EnrollmentScreen.selectedMins.first}분 )',
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: customTheme.colorScheme.secondary,
                            ),
                            '${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first]! * EnrollmentScreen.selectedMonths.first)}원'),
                        Text(
                            '(월 ${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first])}원)'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}