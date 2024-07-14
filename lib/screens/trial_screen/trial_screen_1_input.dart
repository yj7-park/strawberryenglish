// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:universal_html/js.dart' as js;
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrialScreen1Input extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;

  const TrialScreen1Input({
    super.key,
    required this.phoneNumberController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
  });

  @override
  TrialScreen1InputState createState() => TrialScreen1InputState();
}

class TrialScreen1InputState extends State<TrialScreen1Input> {
  final scrollController = ScrollController();

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
              '개인 정보',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.phoneNumberController,
              decoration: InputDecoration(
                labelText: '*휴대폰번호',
                border: const OutlineInputBorder(),
                enabledBorder:
                    myOutlineInputBorder(widget.phoneNumberController),
                focusedBorder:
                    myOutlineInputBorder(widget.phoneNumberController),
                labelStyle: TextStyle(
                  color: widget.phoneNumberController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp("[0-9]"),
                ),
              ],
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.countryController,
              decoration: InputDecoration(
                labelText: '*거주 국가',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.countryController),
                focusedBorder: myOutlineInputBorder(widget.countryController),
                labelStyle: TextStyle(
                  color: widget.countryController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.skypeIdController,
              decoration: InputDecoration(
                labelText: '*Skype 이름',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.skypeIdController),
                focusedBorder: myOutlineInputBorder(widget.skypeIdController),
                labelStyle: TextStyle(
                  color: widget.skypeIdController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* Skype를 이용하여 수업이 진행됩니다.'),
            const SizedBox(height: 10),
            InkWell(
              child: const Text(
                '▶ Skype 다운로드',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onTap: () {
                js.context.callMethod('open',
                    ['https://skype.daesung.com/download/downloadMain.asp']);
              },
            ),
            Container(
              alignment: Alignment.centerLeft,
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
                        width: double.infinity,
                        child: Scrollbar(
                          controller: scrollController,
                          interactive: true,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  const Text(
                                    """
딸기영어는 Skype 메신저로 수업이 진행되며,
회원님의 정확한 Skype ID가 확인되어야 수업을 진행할 수 있습니다.
   
Skype 계정 ID는 아래와 같이 확인할 수 있습니다.""",
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 30),
                                  Builder(
                                    builder: (context) {
                                      var children = [
                                        Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.amber,
                                              width: 5,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/skypeid_help_1.png',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                          width: 30,
                                        ),
                                        Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.amber,
                                              width: 5,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/skypeid_help_2.png',
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                          width: 30,
                                        ),
                                        Container(
                                          width: 300,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.amber,
                                              width: 5,
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/images/skypeid_help_3.png',
                                          ),
                                        ),
                                      ];
                                      if (screenWidth < 1000) {
                                        return Column(
                                          children: children,
                                        );
                                      } else {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: children,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  '▶ Skype 이름확인',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            // InkWell(
            //   child: const Text(
            //     '▶ Skype 이름 확인',
            //     style: TextStyle(decoration: TextDecoration.underline),
            //   ),
            //   onTap: () {
            //     js.context.callMethod('open',
            //         ['https://www.skybel.co.kr/sub/sugang_skype_id.php']);
            //   },
            // ),
            const SizedBox(height: 60),
            const Text(
              '선택 정보',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.studyPurposeController,
              decoration: const InputDecoration(
                labelText: '영어 공부 목적',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.referralSourceController,
              decoration: const InputDecoration(
                labelText: '딸기영어를 알게된 경로',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
