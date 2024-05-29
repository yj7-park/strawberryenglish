import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class ReviewScreen1Listview extends StatelessWidget {
  const ReviewScreen1Listview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int itemCount = 9;
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
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0.0,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                // tileColor: Colors.white,
                leading: Text('${itemCount - index}'),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diago. D.",
                      style: TextStyle(
                        color: customTheme.colorScheme.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 50),
                    Text(
                      "항상 즐거운 Diago 쌤과의 수업",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "윤ㅇ명",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 50),
                    Text(
                      "2024.04.0${itemCount - index}",
                      style: const TextStyle(
                        fontSize: 13,
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
Diago 쌤과 수업한지 벌써 2년쯤 돼가는 것 같은데

어떻게 이렇게 변함없이 밝고 유쾌하신지 수업 때마다 항상 즐거워요!ㅎㅎ

제가 올바르게 말한 문장도 좀더 원어민스러운 고급스러운 표현으로 바꿔주셔서

실력이 느는 기분이에요! 앞으로도 계속 수강하고 싶어요 🙂""",
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
