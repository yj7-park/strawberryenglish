import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

// ignore_for_file: library_private_types_in_public_api

import 'package:strawberryenglish/utils/my_dialogs.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Drawer(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  color: customTheme.colorScheme.secondary,
                  height: 65,
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${FirebaseAuth.instance.currentUser!.email!} 님'),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size(80, 30),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: Colors.white,
                              foregroundColor:
                                  customTheme.colorScheme.secondary,
                              shadowColor: Colors.white,
                            ),
                            onPressed: () {
                              isLoggedIn
                                  ? Navigator.pushNamed(
                                      context, '/student_calendar')
                                  : Navigator.pushNamed(context, '/signup');
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                      await FirebaseAuth.instance.signOut();
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
                      MyDrawerTile(context, '딸기영어', '/introduction',
                          highlight: true),
                      MyDrawerTile(context, '뭐가달라?', '/introduction'),
                      MyDrawerTile(context, '공지사항', '/announcement'),
                      const SizedBox(height: 20),
                      MyDrawerTile(context, '수업안내', '/lectures',
                          highlight: true),
                      MyDrawerTile(context, '수강안내', '/lectures'),
                      MyDrawerTile(context, '수업토픽', '/topics'),
                      MyDrawerTile(context, '튜터소개', '/tutors'),
                      MyDrawerTile(context, '수강료', '/tuitionfee'),
                      MyDrawerTile(context, 'FAQ', '/faq'),
                      const SizedBox(height: 20),
                      MyDrawerTile(context, '딸기후기', '/feedbacks',
                          highlight: true),
                      const SizedBox(height: 75),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                        foregroundColor: customTheme.colorScheme.secondary,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.white,
                        side: BorderSide(
                          color: customTheme.colorScheme.secondary,
                          width: 2,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/trial');
                        if (FirebaseAuth.instance.currentUser == null) {
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
                        backgroundColor: customTheme.colorScheme.secondary,
                        shadowColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/enrollment');
                        if (FirebaseAuth.instance.currentUser == null) {
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
    );
  }
}

Widget MyDrawerTile(context, text, url, {highlight = false}) {
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
