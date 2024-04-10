// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/tutor_provider.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/themes/theme.dart';
import 'package:strawberryenglish/utils/confirmation_dialog.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';
import 'package:provider/provider.dart';

class TutorCalendarScreen extends StatelessWidget {
  const TutorCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: customTheme, // customTheme을 적용
      child: Scaffold(
        appBar: AppBar(
          title: myAppBarTitle,
          // leading: ,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                // 로그아웃 전에 확인 메시지 표시
                bool confirmLogout = await ConfirmationDialog.show(context);
                if (confirmLogout) {
                  // 사용자가 확인하면 로그아웃 처리
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                }
              },
              icon: const Icon(Icons.exit_to_app),
            ),
          ],
        ),
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
