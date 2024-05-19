// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/screens/lectures_screen.dart';
import 'providers/tutor_provider.dart';
import 'providers/student_provider.dart';
import 'screens/admin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/trial_screen.dart';
import 'screens/tutor_calendar_screen.dart';
import 'screens/login_screen.dart';
import 'screens/student_calendar_screen.dart';
import 'screens/home_screen.dart';
// import 'providers/lesson_provider.dart.tmp';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:youtube_player_iframe_web/src/web_youtube_player_iframe_platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebViewPlatform.instance = WebYoutubePlayerIframePlatform();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCwDuKlVvWKqZ1gQjsMmew31kykpkInKyk",
        authDomain: "strawberry-english.firebaseapp.com",
        projectId: "strawberry-english",
        storageBucket: "strawberry-english.appspot.com",
        messagingSenderId: "140525000017",
        appId: "1:140525000017:web:0204c72f13f3463f5b2f70",
        measurementId: "G-4594T6HVRB"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentProvider()),
        ChangeNotifierProvider(create: (context) => TutorProvider()),
        // ChangeNotifierProvider(create: (context) => LessonProvider()),
        // Add more providers if needed
      ],
      child: MaterialApp(
        title: 'Strawberry English',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),

          // 딸기영어
          // 1. 회사소개
          '/introduction': (context) => const HomeScreen(),
          // 2. 공지사항
          '/announcement': (context) => const HomeScreen(),

          // 수업안내
          // 1. 수강안내
          '/lectures': (context) => const LecturesScreen(),
          // 2. 수업토픽
          '/topics': (context) => const HomeScreen(),
          // 3. 튜터소개
          '/tutors': (context) => const HomeScreen(),
          // 4. 수강료
          '/tuitionfee': (context) => const HomeScreen(),
          // 5. FAQ
          '/faq': (context) => const HomeScreen(),

          // 딸기후기
          '/reviews': (context) => const HomeScreen(),

          // 체험하기
          '/trial': (context) => const TrialScreen(),
          // 수강신청
          '/enrollment': (context) => const HomeScreen(),

          // 로그인
          '/login': (context) => const LoginScreen(),
          // 회원가입
          '/signup': (context) => const SignUpScreen(),

          // 마이페이지
          '/student_calendar': (context) => const StudentCalendarScreen(),
          '/tutor_calendar': (context) => const TutorCalendarScreen(),
          '/admin': (context) => const AdminScreen(),
          // Add more routes if needed
        },
      ),
    );
  }
}
