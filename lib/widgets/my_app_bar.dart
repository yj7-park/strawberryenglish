import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/theme.dart';

class MyMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyMenuAppBar({super.key});

  final MenuController controller1 = MenuController();
  final MenuController controller2 = MenuController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: customTheme,
        child: AppBar(
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
              alignmentOffset: const Offset(0, 7.0),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(100))),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller1.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode1,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/introduction');
                        },
                        child: const MenuAcceleratorLabel('회사소개'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode1,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/announcement');
                        },
                        child: const MenuAcceleratorLabel('공지사항'),
                      )
                    ])),
              ],
              child: const MenuAcceleratorLabel('딸기영어'),
            ),
            SubmenuButton(
              focusNode: focusNode2,
              controller: controller2,
              onClose: () {
                focusNode2.unfocus();
              },
              alignmentOffset: const Offset(0, 7.0),
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(100))),
              menuChildren: <Widget>[
                MouseRegion(
                    onExit: (_) {
                      controller2.close();
                    },
                    child: Column(children: [
                      MenuItemButton(
                        focusNode: focusNode2,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/lectures');
                        },
                        child: const MenuAcceleratorLabel('수강안내'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/topics');
                        },
                        child: const MenuAcceleratorLabel('수업토픽'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/tutors');
                        },
                        child: const MenuAcceleratorLabel('튜터소개'),
                      ),
                      MenuItemButton(
                        focusNode: focusNode2,
                        style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all(
                                const Size.fromWidth(100))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/tuitionfee');
                        },
                        child: const MenuAcceleratorLabel('수강료'),
                      ),
                    ]))
              ],
              child: const MenuAcceleratorLabel('수업안내'),
            ),
            MenuItemButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(100))),
              onPressed: () {
                Navigator.pushNamed(context, '/reviews');
              },
              child: const MenuAcceleratorLabel('딸기후기'),
            ),
            MenuItemButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(100))),
              onPressed: () {
                Navigator.pushNamed(context, '/trial');
              },
              child: const MenuAcceleratorLabel('체험하기'),
            ),
            MenuItemButton(
              style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all(const Size.fromWidth(100))),
              onPressed: () {
                Navigator.pushNamed(context, '/enrollment');
              },
              child: const MenuAcceleratorLabel('수강신청'),
            ),
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
          'assets/images/small_logo.jpg',
          width: 32,
          height: 32,
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
