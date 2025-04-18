// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/signup_screen/signup_screen_3_button.dart';
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
  bool isClicked = false;

  late StudentProvider studentProvider;
  // late TutorProvider tutorProvider;

  @override
  Widget build(BuildContext context) {
    studentProvider = Provider.of<StudentProvider>(context);
    // tutorProvider = Provider.of<TutorProvider>(context);

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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: constrainedSize,
                    child: TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: '아이디(이메일)',
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
                        labelText: '비밀번호',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      onSubmitted: (String _) async {
                        isClicked = true;
                        setState(() {});
                        await handleLogin();
                        isClicked = false;
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
                        isClicked = true;
                        setState(() {});
                        await handleLogin();
                        isClicked = false;
                      },
                      child: isClicked
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: customTheme.colorScheme.primary,
                              ),
                            )
                          : const Text(
                              '로그인',
                            ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _usernameController.text,
                            );
                            setState(() {
                              _errorMessage =
                                  '입력된 이메일 주소로 비밀번호 재설정 이메일이 전송되었습니다.';
                            });
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error reset password in: $e');
                            }
                            setState(() {
                              _errorMessage = e
                                  .toString()
                                  .replaceFirst(RegExp(r'\[.*\] '), '');
                              // _errorMessage =
                              //     '비밀번호 재설정 이메일 전송에 실패하였습니다. 이메일 주소를 다시 확인해주세요.';
                            });
                          }
                        },
                        child: const Text('비밀번호 재설정'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    errorMessageTranslate(_errorMessage),
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
    var username = _usernameController.text.trim();
    var password = _passwordController.text;

    setState(() {
      _errorMessage = '';
    });

    if (username.isNotEmpty && password.isNotEmpty) {
      // if ((username??'').endsWith('@sb.english.com')) {
      //   Navigator.pushNamed(context, '/admin');
      //   return; // admin 계정으로 로그인 시 바로 종료
      // }

      // try {
      //   _errorMessage = await tutorProvider.loginTutor(username, password);

      //   if (_errorMessage.isEmpty) {
      //     if (tutorProvider.tutor != null) {
      //       // Navigator.pushNamed(context, '/tutor_calendar');
      //       Navigator.of(context).pop();
      //       return; // tutor 로그인 성공 시 바로 종료
      //     } else {
      //       _errorMessage = "Login failed. Please check ID / Password.";
      //     }
      //   }
      // } catch (e) {
      //   if (kDebugMode) {
      //     print('Tutor login 오류 발생: $e');
      //   }
      // }

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
