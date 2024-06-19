// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class TrialScreen2Input extends StatefulWidget {
  final TextEditingController trialDayController;
  final TextEditingController trialTimeController;

  const TrialScreen2Input({
    super.key,
    required this.trialDayController,
    required this.trialTimeController,
  });

  @override
  TrialScreen2InputState createState() => TrialScreen2InputState();
}

class TrialScreen2InputState extends State<TrialScreen2Input> {
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
              '체험 정보',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: widget.trialDayController,
              decoration: InputDecoration(
                labelText: '*희망 체험 수업 요일',
                hintText: 'ex) 월, 수, 금',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.trialDayController),
                focusedBorder: myOutlineInputBorder(widget.trialDayController),
                labelStyle: TextStyle(
                  color: widget.trialDayController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
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
              controller: widget.trialTimeController,
              decoration: InputDecoration(
                labelText: '*희망 체험 수업 시간',
                hintText: 'ex) 오전 10시~11시, 오후 6시~8시',
                border: const OutlineInputBorder(),
                enabledBorder: myOutlineInputBorder(widget.trialTimeController),
                focusedBorder: myOutlineInputBorder(widget.trialTimeController),
                labelStyle: TextStyle(
                  color: widget.trialTimeController.text.isEmpty
                      ? Colors.redAccent
                      : Colors.black,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
              textInputAction: TextInputAction.next,
            ),
            const Text('* 모든 시간은 한국 시간을 기준으로 입력해 주세요.'),
            const Text('* 희망 수업 시간을 여러 개 입력해 주시면 더 빠르게 수업이 확정됩니다.'),
          ],
        ),
      ),
    );
  }
}
