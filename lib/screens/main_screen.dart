import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 여기에 상태 관리 로직이나 다른 필요한 데이터를 불러오는 로직을 추가하세요.

    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(appBar: MyMenuAppBar(), body: const Text('hello')),
    );
  }
}
