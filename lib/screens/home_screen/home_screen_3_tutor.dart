import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen3Tutor extends StatelessWidget {
  final String videoId = 'HvrbThpzpyM';

  const HomeScreen3Tutor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic widgets = _buildLayout(context, screenWidth);
    return Theme(
      data: customTheme,
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
                    ...widgets,
                    const SizedBox(height: 50)
                  ],
                ),
        ],
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   dynamic widgets = _buildLayout(screenWidth);
  //   return Theme(
  //     data: customTheme,
  //     child: Scaffold(
  //       body: GridView.count(
  //         crossAxisCount: 1,
  //         childAspectRatio: (1 == 1) ? 1 / 1.2 : 3 / 2, // 가로세로 비율 조정
  //         mainAxisSpacing: 10, // 세로 간격
  //         crossAxisSpacing: 10, // 가로 간격
  //         padding: const EdgeInsets.all(50),
  //         children: widgets,
  //       ),
  //     ),
  //   );
  // }

  List<Widget> _buildLayout(context, double screenWidth) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth >= 1600
              ? 50
              : ((screenWidth - 800) / 2).clamp(50, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '왜, 딸기영어여야만 하는가?',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Text(
              '1. 착한 가격 — 유명 업체 대비 4만원 이상 저렴한 수업료',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              "2. 검증된 튜터 — 3차 스크리닝에 걸쳐 선별한 상위 5% 튜터 팀 구성",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8),
            Text(
              "3. 데일리 피드백 — 수업 종료 5분 전, 당일 수업에 대한 즉각적인 피드백 제공",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 40),
            // [튜터소개]로 이동 버튼
            Center(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/tutors');
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
                      ' ✔ 튜터소개 바로가기',
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
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth >= 1600
              ? 50
              : ((screenWidth - 800) / 2).clamp(50, double.nan),
          vertical: 50.0,
        ),
        child: SizedBox(
          width: screenWidth >= 1600
              ? screenWidth / 3
              : (screenWidth - 100).clamp(100, 800),
          // width: screenWidth >= 1600 ? screenWidth / 3 : screenWidth,
          child: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: YoutubePlayerController.fromVideoId(
              videoId: videoId,
              autoPlay: false,
              params: const YoutubePlayerParams(showFullscreenButton: true),
            ),
          ),
        ),

        // child: YoutubePlayerBuilder(
        //   player: YoutubePlayer(
        //     width: screenWidth >= 1600 ? screenWidth / 3 : screenWidth,
        //     controller: YoutubePlayerController(
        //       initialVideoId: videoId,
        //       flags: const YoutubePlayerFlags(
        //         autoPlay: false,
        //         mute: false,
        //       ),
        //     ),
        //   ),
        //   builder: (context, player) => Center(
        //     child: player,
        //   ),
        // ),
      )
    ];
  }
}
