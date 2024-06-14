import 'package:universal_html/js.dart' as js;
import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/introduction_screen/introduction_screen_1_text.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/screens/home_screen/home_screen_5_founder.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

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
                const MyHeader('뭐가 달라?'),
                const HomeScreen5Founder(title: ''),
                Container(
                  color: customTheme.colorScheme.secondary.withOpacity(0.1),
                  child: const IntroductionScreen1Text(),
                ),

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
      ),
    );
  }
}
