// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/screens/admin_students_screen.dart';
import 'package:strawberryenglish/screens/announcement_screen.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';
import 'package:strawberryenglish/screens/faq_screen.dart';
import 'package:strawberryenglish/screens/lectures_screen.dart';
import 'package:strawberryenglish/screens/feedback_screen.dart';
import 'package:strawberryenglish/screens/topics_screen.dart';
import 'package:strawberryenglish/screens/tuitionfee_screen.dart';
import 'package:strawberryenglish/screens/introduction_screen.dart';
import 'package:strawberryenglish/screens/tutors_screen.dart';
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
      measurementId: "G-4594T6HVRB",
      databaseURL: 'https://strawberry-english.firebasedatabase.app',
      // databaseURL: 'https://strawberry-english-default-rtdb.firebaseio.com/',
    ),
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
        debugShowCheckedModeBanner: false,
        title: 'Strawberry English',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),

          // 딸기영어
          // 1. 회사소개
          '/introduction': (context) => const IntroductionScreen(),
          // 2. 공지사항
          '/announcement': (context) => const AnnouncementScreen(),

          // 수업안내
          // 1. 수강안내
          '/lectures': (context) => const LecturesScreen(),
          // 2. 수업토픽
          '/topics': (context) => const TopicsScreen(),
          // 3. 튜터소개
          '/tutors': (context) => const TutorsScreen(),
          // 4. 수강료
          '/tuitionfee': (context) => const TuitionfeeScreen(),
          // 5. FAQ
          '/faq': (context) => const FaqScreen(),

          // 딸기후기
          '/feedbacks': (context) => const FeedbackScreen(),

          // 체험하기
          '/trial': (context) => TrialScreen(),
          // 수강신청
          '/enrollment': (context) => EnrollmentScreen(),

          // 로그인
          '/login': (context) => const LoginScreen(),
          // 회원가입
          '/signup': (context) => SignupScreen(),

          // 마이페이지
          '/student_calendar': (context) => const StudentCalendarScreen(),
          // '/tutor_calendar': (context) => const TutorCalendarScreen(),
          // '/admin': (context) => const AdminScreen(),
          '/admin_students': (context) => const AdminStudentsScreen(),
          // Add more routes if needed
        },
      ),
    );
  }
}
