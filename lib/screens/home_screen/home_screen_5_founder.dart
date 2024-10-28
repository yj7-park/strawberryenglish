import 'package:flutter/material.dart';
import 'package:universal_html/js.dart' as js;
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen5Founder extends StatelessWidget {
  final String videoId = 'cLMG5O--FGg';
  final String title;

  const HomeScreen5Founder({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic widgets = _buildLayout(context, screenWidth);
    return Theme(
      data: customTheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/founder_book.png',
              width: screenWidth >= 1600
                  ? screenWidth / 3
                  : (screenWidth - 100).clamp(100, 800),
            ),
            const SizedBox(height: 16),
            // [튜터소개]로 이동 버튼
            Center(
              child: InkWell(
                onTap: () {
                  js.context
                      .callMethod('open', ['https://kmong.com/gig/486583']);
                },
                child: Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 18),
                        Container(
                          height: 7,
                          width: 180,
                          decoration: BoxDecoration(
                            color: customTheme.colorScheme.secondary
                                .withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      ' ✔ 전자책 구매하기',
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
