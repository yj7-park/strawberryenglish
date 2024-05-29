import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class SignupScreen2Input extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController birthdayController;

  const SignupScreen2Input({
    super.key,
    required this.nameController,
    required this.birthdayController,
  });

  @override
  SignupScreen2InputState createState() => SignupScreen2InputState();
}

class SignupScreen2InputState extends State<SignupScreen2Input> {
  // String statusMessage = '';
  String errorMessage = '';

  // final TextEditingController phoneNumberController =
  //     TextEditingController(text: '+82');
  // final TextEditingController verificationCodeController =
  //     TextEditingController();
  // String verificationId = '';
  // bool isSent = false;
  // bool isVerified = false;
  // String selectedCountryCode = '+82'; // 추가된 부분
  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

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
            TextFormField(
              controller: widget.nameController,
              decoration: const InputDecoration(
                  labelText: '한글 이름', border: OutlineInputBorder()),
            ),
            const Text('* 실제 수강하는 사람의 이름을 적어주세요.'),
            const SizedBox(height: 20),
            // TODO: 생년월일
            TextFormField(
              controller: widget.birthdayController,
              decoration: const InputDecoration(
                labelText: '생년월일',
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
          ],
        ),
      ),
    );
  }
}
