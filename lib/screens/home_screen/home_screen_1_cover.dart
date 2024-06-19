import 'package:flutter/material.dart';

class HomeScreen1Cover extends StatelessWidget {
  const HomeScreen1Cover({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // 이미지
        Image.asset(
          'assets/images/home-1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: (screenWidth * 0.5).clamp(0, screenHeight * 0.8), // 적당한 높이 조절
          colorBlendMode: BlendMode.darken,
          color: Colors.black38,
        ),
        // 텍스트
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Better Life for Tutors and Students',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (screenWidth * 0.05).clamp(14, 48),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '좋은 수업은 좋은 튜터로부터',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (screenWidth * 0.03).clamp(14, 24),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "딸기영어가 자신있는 이유 '3분'이면 확인 가능합니다.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (screenWidth * 0.03).clamp(14, 24),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
