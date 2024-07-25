import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class HomeScreen5Founder extends StatelessWidget {
  final String videoId = 'cLMG5O--FGg';
  final String title;

  const HomeScreen5Founder({super.key, this.title = ''});

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
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  List<Widget> _buildLayout(double screenWidth) {
    return [
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                // color: Colors.white,
                fontSize: (screenWidth * 0.04).clamp(14, 32),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 800) / 2).clamp(50, double.nan),
          vertical: 50.0,
        ),
        child: SizedBox(
          width: (screenWidth - 100).clamp(100, 800),
          child: YoutubePlayer(
            aspectRatio: 16 / 9,
            controller: YoutubePlayerController.fromVideoId(
              videoId: videoId,
              autoPlay: false,
              params: const YoutubePlayerParams(showFullscreenButton: true),
            ),
          ),
          // child: YoutubePlayerScaffold(
          //   controller: YoutubePlayerController.fromVideoId(
          //     videoId: videoId,
          //     autoPlay: false,
          //     params: const YoutubePlayerParams(
          //       mute: false,
          //       showControls: true,
          //       showFullscreenButton: true,
          //     ),
          //   ),
          //   aspectRatio: 16 / 9,
          //   builder: (context, player) {
          //     return Column(
          //       children: [
          //         player,
          //       ],
          //     );
          //   },
          // ),
        ),
      ),
    ];
  }
}
