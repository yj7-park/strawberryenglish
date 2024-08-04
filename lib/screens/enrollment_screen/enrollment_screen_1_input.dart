// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/screens/topics_screen/topics_screen_1_announcement.dart';
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
    },
  };
  static final topic = {
    '스피킹 스킬': [
      'Structured Speaking',
      'Business English',
      'Power/Fluency',
    ],
    '주니어 스피킹': [
      'Kid’s English',
    ],
    '어학시험': [
      'IELTS Speaking',
      'TOEIC Speaking',
      'OPIC',
    ],
  };
  static final cancelCount = {
    1: {2: 2, 3: 3, 5: 5},
    3: {2: 5, 3: 7, 5: 12},
  };
  static final holdCount = {
    1: {2: 1, 3: 1, 5: 1},
    3: {2: 3, 3: 3, 5: 3},
  };

  static const _textStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  final TextEditingController lessonStartDateController;
  final TextEditingController requestDayController;
  final TextEditingController requestTimeController;

  const EnrollmentScreen1Input({
    super.key,
    required this.lessonStartDateController,
    required this.requestDayController,
    required this.requestTimeController,
  });

  @override
  EnrollmentScreen1InputState createState() => EnrollmentScreen1InputState();
}

class EnrollmentScreen1InputState extends State<EnrollmentScreen1Input> {
  final scrollController = ScrollController();

  Future<void> _selectDate(BuildContext context) async {
    String initialDate = widget.lessonStartDateController.value.text;
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customTheme
                    .colorScheme.secondary, // header background color
                onPrimary:
                    customTheme.colorScheme.onPrimary, // header text color
                onSurface: customTheme.colorScheme.onSurface, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor:
                      customTheme.colorScheme.primary, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: DateTime.tryParse(initialDate) ?? DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2030, 12));
    if (picked != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      if (formattedDate != initialDate) {
        setState(() {
          widget.lessonStartDateController.value =
              TextEditingValue(text: formattedDate);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<bool> isSelectedTopic =
        List.filled(EnrollmentScreen1Input.topic.length, false);
    List<bool> isSelectedTopicDetail = List.filled(
        EnrollmentScreen1Input.topic.values
            .elementAt(EnrollmentScreen.selectedTopic)
            .length,
        false);
    isSelectedTopic[EnrollmentScreen.selectedTopic] = true;
    isSelectedTopicDetail[EnrollmentScreen.selectedTopicDetail] = true;
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
            TextFormField(
              controller: widget.lessonStartDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: '*수업시작일',
                // hintText: 'YYYY-MM-DD',
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
              onTap: () => _selectDate(context),
              onChanged: (_) {
                setState(() {});
              },
              // inputFormatters: [
              //   FilteringTextInputFormatter.allow(
              //     RegExp("[0-9-]"),
              //   ),
              //   // MaskedInputFormatter('####-##-##')
              // ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.requestDayController,
              decoration: InputDecoration(
                labelText: '*희망 수업 요일',
                hintText: 'ex) 월, 수, 금',
                border: const OutlineInputBorder(),
                enabledBorder:
                    myOutlineInputBorder(widget.requestDayController),
                focusedBorder:
                    myOutlineInputBorder(widget.requestDayController),
                labelStyle: TextStyle(
                  color: widget.requestDayController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* 평일 수업만 가능합니다.'),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.requestTimeController,
              decoration: InputDecoration(
                labelText: '*희망 수업 시간',
                hintText: 'ex) 오전 10시~11시, 오후 6시~8시',
                border: const OutlineInputBorder(),
                enabledBorder:
                    myOutlineInputBorder(widget.requestTimeController),
                focusedBorder:
                    myOutlineInputBorder(widget.requestTimeController),
                labelStyle: TextStyle(
                  color: widget.requestTimeController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* 수업 가능 시간대를 넓게 주시면 수업 확정이 더 빠르게 진행 됩니다.'),
            const Text(
                '* 수업시간은 정시 혹은 30분 단위로 적어주세요.\n   ex) 오전 10시~ 오후 12시 30분 or 오전 10시 30분, 오전 11시 00분'),
            const SizedBox(height: 30),
            // 수업 토픽
            const Text('*수업토픽', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                ToggleButtons(
                  isSelected: isSelectedTopic,
                  direction: Axis.vertical,
                  borderColor: Colors.black,
                  selectedBorderColor: Colors.black,
                  fillColor: Colors.amber,
                  // highlightColor: customTheme.colorScheme.secondary,
                  children: [
                    for (var v in EnrollmentScreen1Input.topic.keys)
                      SizedBox(
                        width: 150,
                        height: 55,
                        child: Center(
                          child: Text(
                            v,
                            style: EnrollmentScreen1Input._textStyle,
                          ),
                        ),
                      )
                  ],

                  onPressed: (v) {
                    setState(() {
                      EnrollmentScreen.selectedTopic = v;
                      EnrollmentScreen.selectedTopicDetail = 0;
                    });
                  },
                  // showSelectedIcon: false,
                  // selected: EnrollmentScreen.selectedDays,
                  // onSelectionChanged: (newSelection) {
                  //   setState(() {
                  //     EnrollmentScreen.selectedDays = newSelection;
                  //   });
                  // },
                ),
                const SizedBox(width: 20),
                ToggleButtons(
                  isSelected: isSelectedTopicDetail,
                  direction: Axis.vertical,
                  borderColor: Colors.black,
                  selectedBorderColor: Colors.black,
                  fillColor: Colors.amber,
                  children: [
                    for (var v in EnrollmentScreen1Input.topic.values
                        .elementAt(EnrollmentScreen.selectedTopic))
                      SizedBox(
                        width: 326,
                        height: 55,
                        child: Center(
                          child: Text(
                            v,
                            style: EnrollmentScreen1Input._textStyle,
                          ),
                        ),
                      )
                  ],

                  onPressed: (v) {
                    setState(() {
                      EnrollmentScreen.selectedTopicDetail = v;
                    });
                  },
                  // showSelectedIcon: false,
                  // selected: EnrollmentScreen.selectedDays,
                  // onSelectionChanged: (newSelection) {
                  //   setState(() {
                  //     EnrollmentScreen.selectedDays = newSelection;
                  //   });
                  // },
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                    ),
                    context: context,
                    builder: (context) {
                      return Container(
                        color: Colors.white,
                        child: Scrollbar(
                          controller: scrollController,
                          interactive: true,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            child: const Padding(
                              padding: EdgeInsets.all(20),
                              child: TopicsScreen1Announcement(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  '▶ 수업토픽 상세정보 보기',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('*구독기간', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SegmentedButton(
              segments: [
                for (var v in EnrollmentScreen1Input.fee.keys)
                  ButtonSegment(
                    value: v,
                    label: SizedBox(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          '$v개월',
                          style: EnrollmentScreen1Input._textStyle,
                        ),
                      ),
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
              segments: [
                for (var v in EnrollmentScreen1Input.fee.values.first.keys)
                  ButtonSegment(
                    value: v,
                    label: SizedBox(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          '주$v회',
                          style: EnrollmentScreen1Input._textStyle,
                        ),
                      ),
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
            const Text('*수업시간', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SegmentedButton(
              segments: [
                for (var v in EnrollmentScreen1Input
                    .fee.values.first.values.first.keys)
                  ButtonSegment(
                    value: v,
                    label: SizedBox(
                      width: 100,
                      height: 50,
                      child: Center(
                        child: Text(
                          '$v분',
                          style: EnrollmentScreen1Input._textStyle,
                        ),
                      ),
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
            // 결제 금액 요약
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
                            '월 ${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first])}원'),
                        Text(
                            '(${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first]! * EnrollmentScreen.selectedMonths.first)}원)'),
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
