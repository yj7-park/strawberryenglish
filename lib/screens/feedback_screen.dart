import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/feedback_screen/feedback_screen_1_listview.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

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
                // 제목
                MyHeader('딸기후기'),
                // 커버 페이지
                FeedbackScreen1Listview(),
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
