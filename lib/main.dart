// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'providers/tutor_provider.dart';
import 'providers/student_provider.dart';
import 'screens/admin_screen.dart';
import 'screens/signup_screen.dart';
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
          '/introduction': (context) => const HomeScreen(),
          '/announcement': (context) => const HomeScreen(),
          '/lectures': (context) => const HomeScreen(),
          '/topics': (context) => const HomeScreen(),
          '/tutors': (context) => const HomeScreen(),
          '/tuitionfee': (context) => const HomeScreen(),
          '/reviews': (context) => const HomeScreen(),
          '/trial': (context) => const HomeScreen(),
          '/enrollment': (context) => const HomeScreen(),

          '/signup': (context) => const SignUpScreen(),

          '/login': (context) => const LoginScreen(),
          '/student_calendar': (context) => const StudentCalendarScreen(),
          '/tutor_calendar': (context) => const TutorCalendarScreen(),
          '/admin': (context) => const AdminScreen(),
          // Add more routes if needed
        },
      ),
    );
  }
}
