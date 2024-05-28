import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class AnnouncementScreen1Listview extends StatelessWidget {
  const AnnouncementScreen1Listview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) =>
              Container(height: 1.5, color: Colors.grey[300]),
          itemCount: 9,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0.0,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                // tileColor: Colors.white,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "공지",
                      style: TextStyle(
                        color: customTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "제목 ${index + 1}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "2024.04.0${index + 1}",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: const Text(
                      """
안녕하세요 여러분!

한층 업그레이드된 캐스터디에 여러분을 초대합니다 :)

2주간 캐스 교재 10개의 본문을 예습하면서
30개의 질문에 작문해보는 <예습 스터디>입니다.

미리 수업에서 이야기할 내용들을 준비해봄으로써
스피킹 실력을 키울 수 있는 스터디인데요 ~!

이번 스터디는  4/15(월) ~ 4/26(금)까지
2주간 진행됩니다.""",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
