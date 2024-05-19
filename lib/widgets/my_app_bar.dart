// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class MyMenuAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyMenuAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _MyMenuAppBarState createState() => _MyMenuAppBarState();
}

class _MyMenuAppBarState extends State<MyMenuAppBar>
    with SingleTickerProviderStateMixin {
  static const _defaultHeight = 56.0;
  static const _expendedHeight = 256.0;
  double _height = _defaultHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
            height: _height > _defaultHeight ? double.infinity : 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color:
                  Colors.black.withOpacity(_height > _defaultHeight ? 0.5 : 0),
              height: double.infinity,
            )),
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
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/introduction');
                              // },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '회사소개',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/introduction');
                              // },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '공지사항',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/announcement');
                              // },
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
                                Navigator.pushNamed(context, '/lectures');
                              },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '수강안내',
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/lectures');
                              },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '수업토픽',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/topics');
                              // },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '튜터소개',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/tutors');
                              // },
                            ),
                            MenuItemButton(
                              child: const Text(
                                '수강료',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/tuitionfee');
                              // },
                            ),
                            MenuItemButton(
                              child: const Text(
                                'FAQ',
                                textAlign: TextAlign.center,
                              ),
                              // onPressed: () {
                              //   Navigator.pushNamed(context, '/faq');
                              // },
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
                          // onPressed: () {
                          //   Navigator.pushNamed(context, '/reviews');
                          // },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      MenuItemButton(
                        child: const Text(
                          '체험하기',
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/trial');
                        },
                      ),
                      MenuItemButton(
                        child: const Text(
                          '수강신청',
                          textAlign: TextAlign.center,
                        ),
                        // onPressed: () {
                        //   Navigator.pushNamed(context, '/enrollment');
                        // },
                      ),
                      MenuItemButton(
                        child: const Text(
                          '회원가입',
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
