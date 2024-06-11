import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/tutors_screen/tutors_screen_1_listview.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/company_info.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:strawberryenglish/widgets/my_header.dart';

class TutorsScreen extends StatelessWidget {
  const TutorsScreen({super.key});

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
              children: [
                // 제목
                const MyHeader('튜터소개'),
                // 커버 페이지
                TutorsScreen1Listview(),
                // 회사정보
                const CompanyInfo(),
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
