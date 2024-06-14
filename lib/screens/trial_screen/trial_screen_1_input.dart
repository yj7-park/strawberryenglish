// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:universal_html/js.dart' as js;
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TrialScreen1Input extends StatefulWidget {
  final TextEditingController phoneNumberController;
  final TextEditingController lessonDayController;
  final TextEditingController lessonTimeController;
  final TextEditingController countryController;
  final TextEditingController skypeIdController;
  final TextEditingController studyPurposeController;
  final TextEditingController referralSourceController;

  const TrialScreen1Input({
    super.key,
    required this.phoneNumberController,
    required this.lessonDayController,
    required this.lessonTimeController,
    required this.countryController,
    required this.skypeIdController,
    required this.studyPurposeController,
    required this.referralSourceController,
  });

  @override
  TrialScreen1InputState createState() => TrialScreen1InputState();
}

class TrialScreen1InputState extends State<TrialScreen1Input> {
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
                      : Colors.black38,
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
                      : Colors.black38,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.lessonDayController,
              decoration: InputDecoration(
                labelText: '*희망 수업 요일',
                hintText: 'ex) 월, 수, 금',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.lessonDayController),
                focusedBorder: myOutlineInputBorder(widget.lessonDayController),
                labelStyle: TextStyle(
                  color: widget.lessonDayController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black38,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* 희망 수업 요일을 여러 개 입력해 주시면 더 빠르게 수업이 확정됩니다.'),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.lessonTimeController,
              decoration: InputDecoration(
                labelText: '*희망 수업 시간',
                hintText: 'ex) 오전 10시~11시, 오후 6시~8시',
                border: const OutlineInputBorder(),
                enabledBorder:
                    myOutlineInputBorder(widget.lessonTimeController),
                focusedBorder:
                    myOutlineInputBorder(widget.lessonTimeController),
                labelStyle: TextStyle(
                  color: widget.lessonTimeController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black38,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* 모든 시간은 한국 시간을 기준으로 입력해 주세요.'),
            const Text('* 희망 수업 시간을 여러 개 입력해 주시면 더 빠르게 수업이 확정됩니다.'),
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
                      : Colors.black38,
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
            InkWell(
              child: const Text(
                '▶ Skype 이름 확인',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onTap: () {
                js.context.callMethod('open',
                    ['https://www.skybel.co.kr/sub/sugang_skype_id.php']);
              },
            ),
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
