import 'package:flutter/material.dart';

// Primary Color (Gold)
const Color primaryColor = Color(0xff8a7001);

final ThemeData customTheme = ThemeData(
  fontFamily: 'NotoSansKR',
  // colorScheme: ColorScheme.fromSwatch(
  //   primarySwatch: Colors.grey,
  // ),
  colorScheme: const ColorScheme(
    primary: Color(0xFF424242), // 직접 지정한 주 색상
    // primaryVariant: Color(0xFF5a5a5a), // primaryColor의 변형 색상
    secondary: Color(0xfffcc021), // 직접 지정한 보조 색상
    // secondaryVariant: Color(0xFFfbd85a), // secondaryColor의 변형 색상
    surface: Colors.white70,
    error: Colors.red,
    onPrimary: Colors.white70,
    onSecondary: Color(0xFF424242),
    onSurface: Color(0xFF424242),
    onError: Colors.white70,
    brightness: Brightness.light,
  ),
  // scaffoldBackgroundColor: Colors.white70,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xfffcc021), // 버튼 색상 지정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // 버튼 모서리 둥글게 조정
      ),
    ),
  ),
  menuButtonTheme: MenuButtonThemeData(
    style: ButtonStyle(
      // backgroundColor: MaterialStateProperty.all(Colors.white),
      shadowColor: WidgetStateProperty.all(Colors.white),
      overlayColor: WidgetStateProperty.all(Colors.white),
      surfaceTintColor: WidgetStateProperty.all(Colors.white),
      fixedSize: WidgetStateProperty.all(const Size.fromWidth(120)),
    ),
  ),
);

OutlineInputBorder myOutlineInputBorder(controller) {
  return OutlineInputBorder(
    borderSide: BorderSide(
        color: controller.text.isEmpty ? Colors.redAccent : Colors.black),
  );
}

// const Color primaryColor = Color(0xFFF5F5F5);

// // Secondary Color (White)
// // const Color secondaryColor = Color(0xFFF5F5F5); // 연한 회색
// const Color secondaryColor = Color(0xff8a7001); // 연한 회색

// // Accent Color (Gold)
// const Color accentColor = Color(0xfffcc021);

// // Background Color (Light Gray or Beige)
// const Color backgroundColor = Color(0xFFF5F5F5); // 연한 회색
// // const Color backgroundColor = Color(0xfffcc021); // 연한 회색