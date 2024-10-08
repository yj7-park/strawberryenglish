// import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen1Cover extends StatefulWidget {
  const HomeScreen1Cover({
    super.key,
  });

  @override
  State<HomeScreen1Cover> createState() => _HomeScreen1CoverState();
}

class _HomeScreen1CoverState extends State<HomeScreen1Cover> {
  // late VideoPlayerController _controller;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = VideoPlayerController.asset(
  //       // 'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
  //       'assets/images/bg.mp4')
  //     ..initialize().then((_) {
  //       _controller.play();
  //       _controller.setLooping(true);
  //       // Ensure the first frame is shown after the video is initialized
  //       setState(() {});
  //     });
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // 이미지
        Image.asset(
          // 'assets/images/home-1.jpg',
          'assets/images/bg2.gif',
          fit: BoxFit.cover,
          // fit: BoxFit.fitWidth,
          width: double.infinity,
          height: (screenWidth * 0.5).clamp(0, screenHeight * 0.6), // 적당한 높이 조절
          colorBlendMode: BlendMode.darken,
          color: Colors.black38,
        ),
        // SizedBox.expand(
        //   child: FittedBox(
        //     fit: BoxFit.cover,
        //     child:
        // SizedBox(
        //   // width: _controller.value.size.width,
        //   // height: _controller.value.size.height,
        //   width: 500,
        //   height: 500,
        //   child: VideoPlayer(_controller),
        // ),
        //   ),
        // ),
        // 텍스트
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Better Life for Tutors and Students',
                        style: TextStyle(
                          color: Colors.white,
                          // color: customTheme.colorScheme.secondary,
                          fontSize: (screenWidth * 0.04).clamp(20, 60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: (screenWidth * 0.04).clamp(14, 32)),
                      Text(
                        "좋은 수업은",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenWidth * 0.025).clamp(14, 30),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: (screenWidth * 0.025).clamp(5, 10)),
                      Text(
                        "좋은 튜터로부터",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (screenWidth * 0.025).clamp(14, 30),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: (screenWidth * 0.04).clamp(14, 32)),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       "'3분'",
                  //       style: TextStyle(
                  //         color: customTheme.colorScheme.secondary,
                  //         fontSize: (screenWidth * 0.025).clamp(14, 30) + 3,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //     Text(
                  //       " 이면 확인 가능합니다.",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: (screenWidth * 0.025).clamp(14, 30),
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: (screenWidth * 0.3).clamp(100, 200),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          double.infinity,
                          (screenWidth * 0.06).clamp(30, 60),
                        ), // 버튼 사이즈 조정
                      ),
                      onPressed: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.pushNamed(context, '/login').then((_) {
                            Navigator.pushNamed(context, '/trial');
                          });
                        } else {
                          Navigator.pushNamed(context, '/trial');
                        }
                      },
                      child: Text(
                        '체험하기',
                        style: TextStyle(
                            fontSize: (screenWidth * 0.02).clamp(12, 18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
