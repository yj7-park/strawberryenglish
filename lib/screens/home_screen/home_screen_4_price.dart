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
            Column(
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
        child: Builder(builder: (context) {
          var children = [
            Image.asset(
              'assets/images/price1.png',
              width: 700,
            ),
            const SizedBox(width: 50, height: 50),
            Image.asset(
              'assets/images/price2.png',
              width: 700,
            ),
          ];
          return screenWidth < 1600
              ? Column(children: children)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
        }),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 800) / 2).clamp(50, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '광고비에 투자할 비용, 튜터에게 쏟습니다.',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Text(
              '1. 100% 재택 근무와 고정비를 최소화',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              "2. 연말 유급 휴가 지급",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              "3. 타 업체 대비 1.5배 이상의 임금과 인센티브 제공",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 40),
            // [체험하기]로 이동 버튼
            // Center(
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.pushNamed(context, '/trial');
            //       if (FirebaseAuth.instance.currentUser == null) {
            //         Navigator.popAndPushNamed(context, '/login');
            //       }
            //     },
            //     child: Stack(
            //       children: [
            //         Column(
            //           children: [
            //             const SizedBox(height: 18),
            //             Container(
            //               height: 7,
            //               width: 200,
            //               decoration: BoxDecoration(
            //                 color: customTheme.colorScheme.secondary
            //                     .withOpacity(0.7),
            //               ),
            //             ),
            //           ],
            //         ),
            //         const Text(
            //           ' ✔ 체험하기 바로가기',
            //           style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ];
  }
}
