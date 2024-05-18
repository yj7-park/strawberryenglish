// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class StudentCalendarScreen extends StatelessWidget {
  const StudentCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        appBar: const MyMenuAppBar(),
        body: FutureBuilder<Student?>(
          future: Provider.of<StudentProvider>(context)
              .getStudent(), // 새로운 Future 생성
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              // 로딩중일 때 표시할 화면
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // 에러가 발생했을 때 표시할 화면
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              // 데이터가 로드되었을 때 표시할 화면
              return CalendarBody(user: snapshot.data!);
            } else {
              // 데이터가 없을 때 표시할 화면
              return const Center(
                  // child: Text('No data available'),
                  );
            }
          },
        ),
      ),
    );
  }
}
