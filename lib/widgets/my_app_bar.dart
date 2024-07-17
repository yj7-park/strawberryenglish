// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';

class MyMenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyMenuAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _MyMenuAppBarState createState() => _MyMenuAppBarState();
}

class _MyMenuAppBarState extends State<MyMenuAppBar> {
  static const _defaultHeight = 56.0;
  static const _expendedHeight = 256.0;
  double _height = _defaultHeight;

  @override
  Widget build(BuildContext context) {
    setState(() {});
    double screenWidth = MediaQuery.of(context).size.width;
    double widgetPadding = ((screenWidth - 1000) / 2).clamp(10, double.nan);
    bool isMobile = screenWidth < 1000;
    // TODO: 모바일일 경우에는 화면이 크더라도 isMobile true로 설정 필요
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    bool isAdmin = FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.email == 'admin@admin.com';
    // TODO: for test
    isAdmin = true;
    return Stack(
      children: [
        SizedBox(
          height: _height > _defaultHeight ? double.infinity : 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color:
                Colors.black38.withOpacity(_height > _defaultHeight ? 0.5 : 0),
            height: double.infinity,
          ),
        ),
        Column(
          children: [
            // if (!isMobile)
            Container(
              height: 35,
              color: customTheme.colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isLoggedIn
                        ? isAdmin
                            ? '🛡관리자모드🛡'
                            : '${FirebaseAuth.instance.currentUser!.email} 님'
                        : '',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(80, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.white,
                      foregroundColor: customTheme.colorScheme.secondary,
                      shadowColor: Colors.white,
                    ),
                    onPressed: () {
                      isLoggedIn
                          ? Navigator.pushNamed(context, '/student_calendar')
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
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  SizedBox(width: widgetPadding)
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _height,
              decoration: const BoxDecoration(color: Colors.white),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 8, horizontal: widgetPadding),
                child: OverflowBox(
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/small_logo.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                '딸기영어',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isMobile) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _height = _expendedHeight;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _height = _defaultHeight;
                                });
                              },
                              child: Column(
                                children: [
                                  myMenuItemButton(
                                      context, '딸기영어', '/introduction'),
                                  myMenuItemButton(
                                      context, '뭐가달라?', '/introduction'),
                                  myMenuItemButton(
                                      context, '공지사항', '/announcement'),
                                ],
                              ),
                            ),
                            // ),
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _height = _expendedHeight;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _height = _defaultHeight;
                                });
                              },
                              child: Column(
                                children: [
                                  myMenuItemButton(
                                      context, '수업안내', '/lectures'),
                                  myMenuItemButton(
                                      context, '수강안내', '/lectures'),
                                  myMenuItemButton(context, '수업토픽', '/topics'),
                                  myMenuItemButton(context, '튜터소개', '/tutors'),
                                  myMenuItemButton(
                                      context, '수강료', '/tuitionfee'),
                                  myMenuItemButton(context, 'FAQ', '/faq'),
                                ],
                              ),
                            ),
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  _height = _expendedHeight;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  _height = _defaultHeight;
                                });
                              },
                              child: myMenuItemButton(
                                  context, '딸기후기', '/feedbacks'),
                            ),
                            if (isAdmin)
                              MouseRegion(
                                onEnter: (_) {
                                  setState(() {
                                    _height = _expendedHeight;
                                  });
                                },
                                onExit: (_) {
                                  setState(() {
                                    _height = _defaultHeight;
                                  });
                                },
                                child: Column(
                                  children: [
                                    myMenuItemButton(
                                        context, '🛡관리자메뉴', '/admin_students'),
                                    myMenuItemButton(
                                        context, '🛡학생정보', '/admin_students'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 4),
                            if (!isAdmin)
                              Row(
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
                                        color:
                                            customTheme.colorScheme.secondary,
                                        width: 2,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/trial');
                                      if (FirebaseAuth.instance.currentUser ==
                                          null) {
                                        Navigator.popAndPushNamed(
                                                context, '/login')
                                            .then((_) => setState(() {}));
                                      }
                                    },
                                    child: const Text(
                                      '체험하기',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                      Navigator.pushNamed(
                                          context, '/enrollment');
                                      if (FirebaseAuth.instance.currentUser ==
                                          null) {
                                        Navigator.popAndPushNamed(
                                                context, '/login')
                                            .then((_) => setState(() {}));
                                      }
                                    },
                                    child: const Text(
                                      '수강신청',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ] else ...[
                        const Spacer(),
                        DrawerButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        //   child:
                        // Icon(Icons.list_alt_rounded,
                        //     size: 40, color: customTheme.colorScheme.secondary),onTap: drawer,),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              color: customTheme.colorScheme.secondary,
            ),
          ],
        ),
      ],
    );
  }
}

Widget myMenuItemButton(context, text, url) {
  return MenuItemButton(
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 17),
    ),
    onPressed: () {
      Navigator.pushNamed(context, url).then((_) => context.setState(() {}));
    },
  );
}

// final myAppBarTitle = Padding(
//   padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
//   child: Row(
//     children: [
//       Image.asset(
//         'assets/images/small_logo.png',
//         width: 30,
//         height: 30,
//       ),
//       const SizedBox(width: 5),
//       const Text(
//         '딸기영어',
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ],
//   ),
// );
