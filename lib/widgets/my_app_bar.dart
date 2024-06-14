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
    double widgetPadding = ((screenWidth - 1000) / 2).clamp(20, double.nan);
    bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
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
            Container(
              height: 35,
              color: customTheme.colorScheme.secondary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    isLoggedIn
                        ? '${FirebaseAuth.instance.currentUser!.email} 님'
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
                      backgroundColor: Colors.white70,
                      foregroundColor: customTheme.colorScheme.secondary,
                      shadowColor: Colors.white70,
                    ),
                    onPressed: () {
                      isLoggedIn
                          ? Navigator.pushNamed(context, '/student_calendar')
                              .then((_) => setState(() {}))
                          : Navigator.pushNamed(context, '/signup')
                              .then((_) => setState(() {}));
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
                              Navigator.pushNamed(context, '/')
                                  .then((_) => setState(() {}));
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
                padding: const EdgeInsets.only(top: 8),
                child: OverflowBox(
                  maxHeight: double.infinity,
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: widgetPadding),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/')
                              .then((_) => setState(() {}));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
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
                                MenuItemButton(
                                  child: const Text(
                                    '딸기영어',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                            context, '/introduction')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '뭐가달라?',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                            context, '/introduction')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '공지사항',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                            context, '/announcement')
                                        .then((_) => setState(() {}));
                                  },
                                )
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
                                MenuItemButton(
                                  child: const Text(
                                    '수업안내',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/lectures')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '수강안내',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/lectures')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '수업토픽',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/topics')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '튜터소개',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/tutors')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    '수강료',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/tuitionfee')
                                        .then((_) => setState(() {}));
                                  },
                                ),
                                MenuItemButton(
                                  child: const Text(
                                    'FAQ',
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/faq')
                                        .then((_) => setState(() {}));
                                  },
                                ),
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
                            child: MenuItemButton(
                              child: const Text(
                                '딸기후기',
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/feedbacks')
                                    .then((_) => setState(() {}));
                              },
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(height: 4),
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
                                    color: customTheme.colorScheme.secondary,
                                    width: 2,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/trial')
                                      .then((_) => setState(() {}));
                                  if (FirebaseAuth.instance.currentUser ==
                                      null) {
                                    Navigator.pushNamed(context, '/login')
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
                                  Navigator.pushNamed(context, '/enrollment')
                                      .then((_) => setState(() {}));
                                  if (FirebaseAuth.instance.currentUser ==
                                      null) {
                                    Navigator.pushNamed(context, '/login')
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
                        ],
                      ),
                      SizedBox(width: widgetPadding),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 2,
              color: customTheme.colorScheme.secondary,
            )
          ],
        ),
      ],
    );
  }
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
