import 'package:strawberryenglish/widgets/my_drawer.dart';
import 'package:universal_html/js.dart' as js;
import 'package:flutter/material.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_1_cover.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_2_feedback.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_3_tutor.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_4_price.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_5_founder.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              children: [
                // 커버 페이지
                const HomeScreen1Cover(),
                HomeScreen2Feedback(),
                const HomeScreen3Tutor(),
                const HomeScreen4Price(),
                const HomeScreen5Founder(title: '화상영어 창업자가 공개하는 독학 성공법!'),

                // 회사정보
                const CompanyInfo(),
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
