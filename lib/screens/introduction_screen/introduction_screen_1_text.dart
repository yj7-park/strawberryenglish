import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class IntroductionScreen1Text extends StatelessWidget {
  final String videoId = 'gVtH8X8peZk'; // TODO: youtube 영상 ID 추가

  const IntroductionScreen1Text({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic widgets = _buildLayout(screenWidth);
    return Theme(
      data: customTheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 50),
          ...widgets,
          const SizedBox(height: 50)
        ],
      ),
    );
  }

  List<Widget> _buildLayout(double screenWidth) {
    return [
      Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '딸기영어의 시작',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            const Text(
              """
영어 공부에 진심이었던 시골 축구선수 출신으로 화상영어 사업을 시작한 이유는 단순했습니다.
기존 필리핀 전화 영어 서비스를 이용하며 만족스럽지 않았습니다.

21살까지 비행기 한 번 타보지 못한 무식한 축구선수 출신에서 영어를 배운 후 인생이 바뀌었습니다.
바닥에서부터 혼자 공부하며 많은 시행착오를 겪었고 결국 영어는 외국인과 소통을 해야 한다는 것을 깨달았습니다.

26살 군대에서 첫 필리핀 전화영어를 시작해 봅니다.
매번 바뀌는 선생님으로 깊은 대화가 어려웠고, 선생님마다 발음 차이 지도력 차이에 실망하게 됩니다.
무엇보다도 군대 할인을 받고도 하루 20분 한 달 18만 원이 넘는 부담스러운 금액.

실력 있는 튜터 분과 ‘더’ 오래 그리고 ‘더’ 저렴하게 수업하고 싶은 저의 욕심으로 시작되었습니다.

많은 시행착오를 겪고 있지만 딸기영어와 함께 하는 많은 학생분들을 통해 소개되고 성장하고 있습니다.
앞으로도 좋은 서비스를 만들어 갈 수 있도록 노력하겠습니다.""",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    ];
  }
}
