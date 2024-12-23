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
    var parsedInitialDate = DateTime.tryParse(initialDate) ?? DateTime.now();
    parsedInitialDate = parsedInitialDate.add(const Duration(days: 1));
    parsedInitialDate = parsedInitialDate.weekday == 6
        ? parsedInitialDate.add(const Duration(days: 2))
        : parsedInitialDate.weekday == 7
            ? parsedInitialDate.add(const Duration(days: 1))
            : parsedInitialDate;
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary:
                  customTheme.colorScheme.secondary, // header background color
              onPrimary: customTheme.colorScheme.onPrimary, // header text color
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
      initialDate: parsedInitialDate,
      firstDate: parsedInitialDate,
      lastDate: DateTime(2030, 12),
      selectableDayPredicate: (DateTime val) =>
          val.weekday == 6 || val.weekday == 7 ? false : true,
    );
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
                labelText: '*희망 수업 시간 (주의! 한국시간으로 말씀해주세요.)',
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
            // 개인정보 취급방침 동의
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: EnrollmentScreen.check,
                        onChanged: ((value) {
                          setState(
                            () {
                              EnrollmentScreen.check = value!;
                            },
                          );
                        }),
                      ),
                      const Text('[필수] 개인정보 취급방침 동의'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Scrollbar(
                                  controller: scrollController,
                                  interactive: true,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text("""
[필수] 개인정보 취급방침 동의

딸기아카데미는 고객님의 개인정보 보호를 위해 최소한의 정보만 수집합니다.

1. 개인정보의 처리 목적

딸기영어 웹사이트 (‘https://yj7-park.github.io/web_test/’) 및 서비스 운영 주체 ‘딸기아카데미’’(이하 딸기아카데미)는 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다.

- 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리, 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급.배송, 서비스에 대한 안내 및 이벤트/혜택사항 안내 등

2. 개인정보의 처리 및 보유 기간

① 딸기영어는 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.

② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다.

고객 가입 및 관리 : 서비스 이용계약 해지 후 5년까지 (고객 서비스 관리 및 분쟁조정을 위함)

- 전자상거래에서의 계약․청약철회, 대금결제, 재화 등 공급기록 : 5년

3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법

이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

① 정보주체는 딸기아카데미에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.

ㄱ. 개인정보 열람요구

ㄴ. 오류 등이 있을 경우 정정 요구

ㄷ. 삭제요구

ㄹ. 처리정지 요구

4. 처리하는 개인정보의 항목

① 딸기아카데미는 다음의 개인정보 항목을 처리하고 있습니다.

- 필수항목 : 이름, 생년월일, 휴대전화번호, 스카이프ID, 기타수강관련기재사항
- 선택항목 : 현금영수증발급정보, 기타수강관련기재사항

5. 개인정보의 파기

딸기아카데미는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

- 파기절차

이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

- 파기기한

이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

6. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

① 딸기아카데미는 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠기(cookie)’를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.

7. 개인정보 보호책임자

① 딸기아카데미는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자

성명 :윤소명

직책 :관리자

직급 :관리자

연락처 :01097230721, hgu0485@naver.com

※ 개인정보 보호 담당부서로 연결됩니다.

▶ 개인정보 보호 담당부서

부서명 :딸기아카데미

담당자 : 윤소명

연락처 :01097230721, hgu0485@naver.com

② 정보주체께서는 딸기아카데미의 서비스를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 딸기아카데미는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

8. 개인정보 처리방침 변경

①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.

9. 개인정보의 안전성 확보 조치

딸기아카데미는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

ㄱ. 개인정보 취급 직원의 최소화 및 교육

개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.

ㄴ. 개인정보의 암호화

이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

ㄷ. 개인정보에 대한 접근 제한

개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.

2024년 7월 31일부 개정
                                  """),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: const Text(
                      '내용 보기',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                            '(${EnrollmentScreen.selectedMonths.first}개월 ${NumberFormat("###,###").format(EnrollmentScreen1Input.fee[EnrollmentScreen.selectedMonths.first]![EnrollmentScreen.selectedDays.first]![EnrollmentScreen.selectedMins.first]! * EnrollmentScreen.selectedMonths.first)}원)'),
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
