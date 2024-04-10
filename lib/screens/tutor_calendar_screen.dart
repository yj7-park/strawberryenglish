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
  const TutorCalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use 'watch' to listen to changes in TutorProvider.
    final tutorProvider = context.watch<TutorProvider>();

    return Theme(
      data: customTheme, // Apply the custom theme.
      child: Scaffold(
        appBar: AppBar(
          title: myAppBarTitle,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () async {
                bool confirmLogout = await ConfirmationDialog.show(context);
                if (confirmLogout) {
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('학생이 없습니다.'));
            }

            final students = snapshot.data!;

            return DefaultTabController(
              length: students.length,
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 48, // Match the TabBar's height.
                  elevation: 0, // Remove shadow.
                  bottom: TabBar(
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
