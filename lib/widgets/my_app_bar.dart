import 'package:flutter/material.dart';

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

class MyMenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyMenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: myAppBarTitle,
      // leading: ,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        SizedBox(
          // SizedBox를 사용하여 너비를 100으로 지정
          width: 100,
          child: SubmenuButton(
            alignmentOffset: const Offset(0, 7.0),
            focusNode: primaryFocus,
            menuChildren: <Widget>[
              SizedBox(
                  // SizedBox를 사용하여 너비를 100으로 지정
                  width: 100,
                  child: MenuItemButton(
                    onPressed: () {
                      // 딸기 하우스 메뉴의 "회사소개" 아이템이 클릭되었을 때의 동작
                      // 여기에 클릭 시 수행할 작업을 추가하세요.
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const MenuAcceleratorLabel('회사소개'),
                  )),
              MenuItemButton(
                onPressed: () {
                  // 딸기 하우스 메뉴의 "공지사항" 아이템이 클릭되었을 때의 동작
                  // 여기에 클릭 시 수행할 작업을 추가하세요.
                },
                child: const MenuAcceleratorLabel('공지사항'),
              ),
              MenuItemButton(
                onPressed: () {
                  // 딸기 하우스 메뉴의 "후원아이" 아이템이 클릭되었을 때의 동작
                  // 여기에 클릭 시 수행할 작업을 추가하세요.
                },
                child: const MenuAcceleratorLabel('후원아이'),
              ),
            ],
            child: const MenuAcceleratorLabel('딸기 하우스'),
          ),
        ),
        SizedBox(
          // SizedBox를 사용하여 너비를 100으로 지정
          width: 100,
          child: SubmenuButton(
            alignmentOffset: const Offset(0, 7.0),
            menuChildren: <Widget>[
              MenuItemButton(
                onPressed: () {
                  // 수업 안내 메뉴의 "신청과정" 아이템이 클릭되었을 때의 동작
                  // 여기에 클릭 시 수행할 작업을 추가하세요.
                },
                child: const MenuAcceleratorLabel('신청과정'),
              ),
              // 나머지 수업 안내 메뉴 아이템들도 유사하게 추가
            ],
            child: const MenuAcceleratorLabel('수업 안내'),
          ),
        ),
        SizedBox(
          // SizedBox를 사용하여 너비를 100으로 지정
          width: 100,
          child: MenuItemButton(
            onPressed: () {
              // 딸기 후기 메뉴의 클릭 동작
              // 여기에 클릭 시 수행할 작업을 추가하세요.
            },
            child: const MenuAcceleratorLabel('딸기 후기'),
          ),
        ),
        SizedBox(
          // SizedBox를 사용하여 너비를 100으로 지정
          width: 100,
          child: MenuItemButton(
            onPressed: () {
              // 무료 트라이얼 신청 메뉴의 클릭 동작
              // 여기에 클릭 시 수행할 작업을 추가하세요.
            },
            child: const MenuAcceleratorLabel('무료\n트라이얼 신청'),
          ),
        ),
        SizedBox(
          // SizedBox를 사용하여 너비를 100으로 지정
          width: 100,
          child: MenuItemButton(
            onPressed: () {
              // 수강 신청 메뉴의 클릭 동작
              // 여기에 클릭 시 수행할 작업을 추가하세요.
            },
            child: const MenuAcceleratorLabel('수강 신청'),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
