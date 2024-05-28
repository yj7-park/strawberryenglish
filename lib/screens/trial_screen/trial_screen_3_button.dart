import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

class TrialScreen3Button extends StatefulWidget {
  const TrialScreen3Button({super.key});

  @override
  TrialScreen3ButtonState createState() => TrialScreen3ButtonState();
}

class TrialScreen3ButtonState extends State<TrialScreen3Button> {
  final _scrollController = ScrollController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  // String _statusMessage = '';
  String _errorMessage = '';

  bool _check1 = false;
  bool _check2 = false;
  bool _check3 = false;

  // final TextEditingController _phoneNumberController =
  //     TextEditingController(text: '+82');
  // final TextEditingController _verificationCodeController =
  //     TextEditingController();
  // String _verificationId = '';
  // bool _isSent = false;
  // bool _isVerified = false;
  // String _selectedCountryCode = '+82'; // 추가된 부분
  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> _countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ((screenWidth - 500) / 2)),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            SizedBox(
              width: 500,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 60), // 버튼 사이즈 조정
                ),
                onPressed: _registerUser,
                child: const Text(
                  '체험하기',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // TODO: 메일 주소 verification

  // TODO: 회원 가입 처리
  void _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    // final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    _errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        email.isEmpty ||
        // phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        // _errorMessage = 'All fields are required.';
        _errorMessage = '모든 항목이 입력되어야 합니다.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        // _errorMessage = 'Passwords do not match.';
        _errorMessage = '비밀번호가 일치하지 않습니다.';
      });
      return;
    }

    if (!_check1 || !_check2) {
      setState(() {
        _errorMessage = '필수 항목의 동의가 필요합니다.';
      });
      return;
    }

    try {
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst(RegExp(r'\[.*\] '), '');
      });
    }
  }
}
