import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class HomeScreen4Price extends StatelessWidget {
  const HomeScreen4Price({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic widgets = _buildLayout(context, screenWidth);
    return Theme(
      data: customTheme,
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Column(
          children: [
            screenWidth >= 1600
                ? Row(
                    children: widgets,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(height: 50),
                      ...List.from(widgets.reversed),
                      const SizedBox(height: 50),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLayout(context, double screenWidth) {
    return [
      Padding(
        padding: const EdgeInsets.all(50),
        child: Image.asset(
          'assets/images/price2.png',
          width: screenWidth >= 1600 ? screenWidth / 3 : screenWidth,
          // height: 30,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '가격이 비쌀 수 밖에 없었던 이유는',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            Text(
              '과도한 고정비와 마케팅비였습니다.',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              '1. 100% 재택 근무와 고정비를 최소화',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "2. 불필요한 마케팅비용을 극단적으로 줄이고 본질에 집중한 바이럴",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "3. 박리다매를 지향하는 창업자의 마인드",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 40),
            // [체험하기]로 이동 버튼
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/feedbacks');
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          height: 7,
                          width: 200,
                          decoration: BoxDecoration(
                            color: customTheme.colorScheme.secondary
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      ' ✔ 체험하기 바로가기',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
