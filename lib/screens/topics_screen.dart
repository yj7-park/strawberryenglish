import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/topics_screen/topics_screen_1_announcement.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

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
                  const EdgeInsets.only(top: 56), // Make space for the AppBar
              children: const [
                // 커버 페이지
                TopicsScreen1Announcement(),
                // 회사정보
                CompanyInfo(),
              ],
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
