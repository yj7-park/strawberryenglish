import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/theme.dart';

class MyMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyMenuAppBar({super.key});

  final MenuController controller1 = MenuController();
  final MenuController controller2 = MenuController();
  final MenuController controller3 = MenuController();
  final MenuController controller4 = MenuController();
  final MenuController controller5 = MenuController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: customTheme,
        child: AppBar(
          backgroundColor: Colors.white,
          title: myAppBarTitle,
          // leading: ,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            SubmenuButton(
              controller: controller1,
              focusNode: focusNode1,
              onClose: () {
                focusNode1.unfocus();
              },
              alignmentOffset: const Offset(0, -32.0),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller1.close();
                      focusNode1.unfocus();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode1,
                        onPressed: () {
                          controller1.close();
                        },
                        child: const Text('딸기영어'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode1,
                        onPressed: () {
                          Navigator.pushNamed(context, '/introduction');
                        },
                        child: const Text('회사소개'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode1,
                        onPressed: () {
                          Navigator.pushNamed(context, '/announcement');
                        },
                        child: const Text('공지사항'),
                      )
                    ])),
              ],
              child: const Text('딸기영어'),
            ),
            SubmenuButton(
              focusNode: focusNode2,
              controller: controller2,
              onClose: () {
                focusNode2.unfocus();
              },
              alignmentOffset: const Offset(0, -32.0),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller2.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode2,
                        onPressed: () {
                          controller2.close();
                        },
                        child: const Text('수업안내'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        onPressed: () {
                          Navigator.pushNamed(context, '/lectures');
                        },
                        child: const Text('수강안내'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        onPressed: () {
                          Navigator.pushNamed(context, '/topics');
                        },
                        child: const Text('수업토픽'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        onPressed: () {
                          Navigator.pushNamed(context, '/tutors');
                        },
                        child: const Text('튜터소개'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        onPressed: () {
                          Navigator.pushNamed(context, '/tuitionfee');
                        },
                        child: const Text('수강료'),
                      ),
                    ]))
              ],
              child: const Text('수업안내'),
            ),
            SubmenuButton(
              focusNode: focusNode3,
              controller: controller3,
              onClose: () {
                focusNode3.unfocus();
              },
              alignmentOffset: const Offset(0, -32.0),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller3.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode3,
                        onPressed: () {
                          Navigator.pushNamed(context, '/reviews');
                        },
                        onHover: (onHover) {
                          if (!onHover) {
                            focusNode3.unfocus();
                          }
                        },
                        child: const Text('딸기후기'),
                      ),
                    ]))
              ],
              child: const Text('딸기후기'),
            ),
            SubmenuButton(
              focusNode: focusNode4,
              controller: controller4,
              onClose: () {
                focusNode4.unfocus();
              },
              alignmentOffset: const Offset(0, -32.0),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller4.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode4,
                        onPressed: () {
                          Navigator.pushNamed(context, '/trial');
                        },
                        onHover: (onHover) {
                          if (!onHover) {
                            focusNode4.unfocus();
                          }
                        },
                        child: const Text('체험하기'),
                      ),
                    ]))
              ],
              child: const Text('체험하기'),
            ),
            SubmenuButton(
              focusNode: focusNode5,
              controller: controller5,
              onClose: () {
                focusNode2.unfocus();
              },
              alignmentOffset: const Offset(0, -32.0),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller5.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode5,
                        onPressed: () {
                          Navigator.pushNamed(context, '/enrollment');
                        },
                        onHover: (onHover) {
                          if (!onHover) {
                            focusNode5.unfocus();
                          }
                        },
                        child: const Text('수강신청'),
                      ),
                    ]))
              ],
              child: const Text('수강신청'),
            )
          ],
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Row myAppBarTitle = Row(
  children: [
    Column(
      children: [
        Image.asset(
          'assets/images/small_logo.png',
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 5),
      ],
    ),
    const SizedBox(width: 5),
    const Text(
      '딸기영어',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
);
