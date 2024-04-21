// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '+82');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  String _verificationId = '';
  String _statusMessage = '';
  String _errorMessage = '';
  bool _isSent = false;
  bool _isVerified = false;
  // String _selectedCountryCode = '+82'; // 추가된 부분

  // 국가 코드 목록 (필요한 경우 확장 가능)
  // List<String> _countryCodes = ['+82', '+1', '+44', '+81', '+86', '+33'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isVerified ? null : _sendVerificationCode,
                  child: Text(_isVerified ? 'Verified' : 'Verify'),
                ),
                // DropdownButton<String>(
                //   value: _selectedCountryCode,
                //   onChanged: (String? value) {
                //     setState(() {
                //       _selectedCountryCode = value!;
                //     });
                //   },
                //   items: _countryCodes
                //       .map<DropdownMenuItem<String>>((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
            if (_isSent && !_isVerified)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _verificationCodeController,
                      decoration:
                          const InputDecoration(labelText: 'Verification Code'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _checkVerificationCode,
                    child: const Text('Check'),
                  ),
                ],
              ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Sign In'),
            ),
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _sendVerificationCode() async {
    final phoneNumber = _phoneNumberController.text.trim();
    _errorMessage = '';

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _errorMessage = 'Error: $e';
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _statusMessage = 'Verification code sent!';
            _isSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  void _checkVerificationCode() async {
    final verificationCode = _verificationCodeController.text.trim();
    _errorMessage = '';

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: verificationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        _statusMessage = 'Phone number verified!';
        _isVerified = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }

  void _registerUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    _errorMessage = '';

    // 필수 필드 값 확인
    if (name.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    if (!_isVerified) {
      setState(() {
        _errorMessage = 'Phone Number is not verified.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'lessonIDs': <String>[],
        'lessonInfo': <String, dynamic>{},
      });

      // Navigate to calendar screen
      Navigator.pushNamed(context, '/student_calendar');

      setState(() {
        _statusMessage = 'User registered successfully!';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    }
  }
}
