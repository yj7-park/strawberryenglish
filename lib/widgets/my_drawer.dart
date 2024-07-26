import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

// ignore_for_file: library_private_types_in_public_api

import 'package:strawberryenglish/utils/my_dialogs.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late StudentProvider studentProvider;

  @override
  Widget build(BuildContext context) {
    studentProvider = Provider.of<StudentProvider>(context);
    return FutureBuilder<Student?>(
      future: studentProvider.getStudent(), // 새로운 Future 생성
      builder: (context, snapshot) {
        var student = snapshot.data;

        bool isLoggedIn = student != null;
        bool isAdmin =
            student != null && student.data['email'] == 'admin@admin.com';
        return PointerInterceptor(
          child: Drawer(
            width: 250,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: customTheme.colorScheme.secondary,
                        height: 120,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/small_logo.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                '딸기영어',
                                style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 3),
                        color: customTheme.colorScheme.secondary,
                        height: 65,
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              isLoggedIn
                                  ? isAdmin
                                      ? '🛡관리자모드🛡'
                                      : '${student.data['email']} 님'
                                  : '',
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    minimumSize: const Size(80, 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        customTheme.colorScheme.secondary,
                                    shadowColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    isLoggedIn
                                        ? Navigator.pushNamed(
                                            context, '/student_calendar')
                                        : Navigator.pushNamed(
                                            context, '/signup');
                                  },
                                  child: Text(
                                    isLoggedIn ? '마이페이지' : '회원가입',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    minimumSize: const Size(80, 30),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.white,
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  onPressed: isLoggedIn
                                      ? () async {
                                          // 로그아웃 전에 확인 메시지 표시
                                          bool confirmLogout =
                                              await LogoutDialog.show(context);
                                          if (confirmLogout) {
                                            // 사용자가 확인하면 로그아웃 처리
                                            studentProvider.logoutStudent();
                                            if (!context.mounted) return;
                                            Navigator.pushNamed(context, '/');
                                          }
                                        }
                                      : () {
                                          Navigator.pushNamed(context, '/login')
                                              .then((_) => setState(() {}));
                                        },
                                  child: Text(
                                    isLoggedIn ? '로그아웃' : '로그인',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            myDrawerTile(context, '딸기영어', '/introduction',
                                highlight: true),
                            myDrawerTile(context, '뭐가달라?', '/introduction'),
                            myDrawerTile(context, '공지사항', '/announcement'),
                            const SizedBox(height: 20),
                            myDrawerTile(context, '수업안내', '/lectures',
                                highlight: true),
                            myDrawerTile(context, '수강안내', '/lectures'),
                            myDrawerTile(context, '수업토픽', '/topics'),
                            myDrawerTile(context, '튜터소개', '/tutors'),
                            myDrawerTile(context, '수강료', '/tuitionfee'),
                            myDrawerTile(context, 'FAQ', '/faq'),
                            const SizedBox(height: 20),
                            myDrawerTile(context, '딸기후기', '/feedbacks',
                                highlight: true),
                            if (isAdmin) ...[
                              const SizedBox(height: 20),
                              myDrawerTile(
                                  context, '🛡관리자메뉴', '/admin_students',
                                  highlight: true),
                              myDrawerTile(
                                  context, '🛡학생정보', '/admin_students'),
                              myDrawerTile(
                                  context, '🛡후기관리', '/admin_feedbacks'),
                            ],
                            const SizedBox(height: 75),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isAdmin)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: customTheme.colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    customTheme.colorScheme.secondary,
                                backgroundColor: Colors.white,
                                shadowColor: Colors.white,
                                side: BorderSide(
                                  color: customTheme.colorScheme.secondary,
                                  width: 2,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/trial');
                                if (!isLoggedIn) {
                                  Navigator.popAndPushNamed(context, '/login')
                                      .then((_) => setState(() {}));
                                }
                              },
                              child: const Text(
                                '체험하기',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    customTheme.colorScheme.secondary,
                                shadowColor: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/enrollment');
                                if (!isLoggedIn) {
                                  Navigator.popAndPushNamed(context, '/login')
                                      .then((_) => setState(() {}));
                                }
                              },
                              child: const Text(
                                '수강신청',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget myDrawerTile(context, text, url, {highlight = false}) {
  return ListTile(
    dense: true,
    title: Text(
      text,
      textAlign: TextAlign.center,
      style: highlight
          ? const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
          : const TextStyle(fontSize: 15),
    ),
    onTap: () {
      Navigator.pushNamed(context, url).then((_) => context.setState(() {}));
    },
  );
}
