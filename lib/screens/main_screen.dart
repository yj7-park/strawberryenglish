import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 여기에 상태 관리 로직이나 다른 필요한 데이터를 불러오는 로직을 추가하세요.

    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        appBar: const MyMenuAppBar(),
        body: MenuBar(
          children: [
            SizedBox(
              // SizedBox를 사용하여 너비를 100으로 지정
              width: 100,
              child: SubmenuButton(
                alignmentOffset: const Offset(0, 7.0),
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
            // MainScreenHeader(), // 상단에 표시될 헤더 위젯
            // UserInformation(), // 사용자 정보를 표시할 위젯
            // CustomCalendar(), // 사용자 정의 캘린더 위젯
            // 추가하고 싶은 다른 위젯들을 여기에 배치하세요.
          ],
        ),
      ),
    );
  }
}
