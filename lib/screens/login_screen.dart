// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/providers/tutor_provider.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  late StudentProvider studentProvider;
  late TutorProvider tutorProvider;

  @override
  Widget build(BuildContext context) {
    studentProvider = Provider.of<StudentProvider>(context);
    tutorProvider = Provider.of<TutorProvider>(context);

    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.8;
    double constrainedSize = imageSize > 300.0 ? 300.0 : imageSize;

    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: const MyMenuAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 로고 이미지 추가
                  Image.asset(
                    'assets/images/logo.jpg',
                    width: constrainedSize,
                    height: constrainedSize,
                  ),
                  // 로고와 관련된 텍스트 추가
                  // Text(
                  //   'Better life for tutors and students',
                  //   style: TextStyle(
                  //     color: customTheme.primaryColor, // 테마의 primaryColor 사용
                  //     fontSize: 16,
                  //   ),
                  // ),
                  // const SizedBox(height: 24), // 로고와 입력 필드 사이의 여백 추가
                  SizedBox(
                    width: constrainedSize,
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8), // 입력 필드 사이의 간격 조정
                  SizedBox(
                    width: constrainedSize,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      onSubmitted: (String _) async {
                        await handleLogin();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      width: constrainedSize, // 최대 너비를 300으로 설정
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 50), // 버튼 사이즈 조정
                        ),
                        onPressed: () async {
                          await handleLogin();
                        },
                        child: const Text(
                          'Login',
                        ),
                      )),
                  TextButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _usernameController.text,
                        );
                        setState(() {
                          _errorMessage =
                              'Password reset email sent. Please check your email.';
                        });
                      } catch (e) {
                        setState(() {
                          _errorMessage =
                              'Error sending password reset email. Please check ID field.';
                        });
                      }
                    },
                    child: const Text('Forgot your password? Reset it here.'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage,
                    style: TextStyle(color: customTheme.colorScheme.error),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleLogin() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    setState(() {
      _errorMessage = '';
    });

    if (username.isNotEmpty && password.isNotEmpty) {
      if (username == 'admin@admin.com') {
        Navigator.pushNamed(context, '/admin');
        return; // admin 계정으로 로그인 시 바로 종료
      }

      try {
        _errorMessage = await tutorProvider.loginTutor(username, password);

        if (_errorMessage.isEmpty) {
          if (tutorProvider.tutor != null) {
            // Navigator.pushNamed(context, '/tutor_calendar');
            Navigator.of(context).pop();
            return; // tutor 로그인 성공 시 바로 종료
          } else {
            _errorMessage = "Login failed. Please check ID / Password.";
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Tutor login 오류 발생: $e');
        }
      }

      try {
        _errorMessage = await studentProvider.loginStudent(username, password);

        if (_errorMessage.isEmpty) {
          if (studentProvider.student != null) {
            // Navigator.pushNamed(context, '/student_calendar');
            Navigator.of(context).pop(true);
            return; // student 로그인 성공 시 바로 종료
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Student login 오류 발생: $e');
        }
      }

      if (_errorMessage.isNotEmpty) {
        setState(() {
          _errorMessage = _errorMessage.replaceFirst(RegExp(r'\[.*\] '), '');
        });
      }
    }
  }
}
