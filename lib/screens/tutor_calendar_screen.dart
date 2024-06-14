// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/tutor_provider.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class TutorCalendarScreen extends StatelessWidget {
  const TutorCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        appBar: const MyMenuAppBar(),
        body: FutureBuilder<List<Student>>(
          future: Provider.of<TutorProvider>(context)
              .getAllStudents(), // Assuming getStudents is a method that fetches student data.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('학생이 없습니다.'));
            }

            final students = snapshot.data!;

            return DefaultTabController(
              length: students.length,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: TabBar(
                    isScrollable: true,
                    tabs: students
                        .map((student) => Tab(text: student.name))
                        .toList(),
                  ),
                ),
                body: TabBarView(
                  children: students
                      .map((student) => CalendarBody(user: student))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
