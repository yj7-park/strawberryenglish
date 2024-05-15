import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen3Tutor extends StatelessWidget {
  final String videoId = 'gVtH8X8peZk'; // TODO: youtube 영상 ID 추가

  const HomeScreen3Tutor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic widgets = _buildLayout(screenWidth);
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
                    ]),
          // TODO: [튜터소개]로 이동 버튼 추가
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

  List<Widget> _buildLayout(double screenWidth) {
    return [
      Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '딸기영어가 자신있는 이유',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Text(
              '1. 타사 대비 1.5배 높은 임금과 수업 여건 보장으로 튜터 만족감 업',
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "2. 높은 경쟁 속에서 까다로운 3차 면접을 통해 최고의 튜터 채용",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Text(
              "3. 과도한 페널티를 없애고 튜터들의 자발적인 책임감 요구로 능동적 지도 환경",
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.025).clamp(14, 24),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(50),
        child: SizedBox(
          width: screenWidth >= 1600 ? screenWidth / 3 : screenWidth,
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
