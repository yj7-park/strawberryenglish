import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/lectures_screen/lectures_screen_1_announcement.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class LecturesScreen extends StatelessWidget {
  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        // appBar: MyMenuAppBar(),
        body: Stack(
          children: [
            ListView(
              padding:
                  const EdgeInsets.only(top: 93), // Make space for the AppBar
              children: const [
                // 제목
                MyHeader('등록규정'),
                // 커버 페이지
                LecturesScreen1Announcement(),
                // 회사정보
                CompanyInfo(),
              ],
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: InkWell(
                onTap: () {
                  js.context
                      .callMethod('open', ['http://pf.kakao.com/_xmXCtxj']);
                },
                child: Image.asset(
                  'assets/images/kakao_talk.png',
                  width: 70,
                ),
              ),
            ),
            const Positioned(
              child: MyMenuAppBar(),
            ),
          ],
        ),
        drawer: const MyDrawer(),
      ),
    );
  }
}
