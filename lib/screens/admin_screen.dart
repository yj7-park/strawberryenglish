// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:strawberryenglish/providers/tutor_provider.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:strawberryenglish/utils/my_dialogs.dart';
import 'package:strawberryenglish/widgets/my_app_bar.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: customTheme, // customTheme을 적용
        child: Scaffold(
          appBar: AppBar(
            title: const MyMenuAppBar(),
            // leading: ,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: () async {
                  // 로그아웃 전에 확인 메시지 표시
                  bool confirmLogout = await LogoutDialog.show(context);
                  if (confirmLogout) {
                    // 사용자가 확인하면 로그아웃 처리
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/');
                  }
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: const Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Student List',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: LessonList(),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // userProvider의 addAllUsers() 호출
              await Provider.of<StudentProvider>(context).addAllStudents();
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}

class LessonList extends StatelessWidget {
  const LessonList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Student>>(
      future: Provider.of<StudentProvider>(context).getAllStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // CircularProgressIndicator를 화면 중앙에 표시
          return const Center(
            child: SizedBox(
              width: 40, // 원하는 크기로 조절
              height: 40, // 원하는 크기로 조절
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No users available.');
        }

        var users = snapshot.data!;

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return ListTile(
              title: Text('${user.id} ${user.name} (${user.email})'),
              subtitle:
                  Text(user.log, style: const TextStyle(color: Colors.red)),
            );
          },
        );
      },
    );
  }
}

class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  AddLessonScreenState createState() => AddLessonScreenState();
}

class AddLessonScreenState extends State<AddLessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController programNameController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController tutorController = TextEditingController();
  final TextEditingController lessonTypeController = TextEditingController();
  final TextEditingController lessonTimeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _selectedDaysOfWeek = [];

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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Add Lesson'),
  //     ),
  //     body: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           TextField(
  //             controller: titleController,
  //             decoration: const InputDecoration(labelText: 'Title'),
  //           ),
  //           TextField(
  //             controller: descriptionController,
  //             decoration: const InputDecoration(labelText: 'Description'),
  //           ),
  //           TextField(
  //             controller: programNameController,
  //             decoration: const InputDecoration(labelText: 'Program Name'),
  //           ),
  //           TextField(
  //             controller: topicController,
  //             decoration: const InputDecoration(labelText: 'Topic'),
  //           ),
  //           TextField(
  //             controller: tutorController,
  //             decoration: const InputDecoration(labelText: 'Tutor'),
  //           ),
  //           // Day of Week 선택
  //           const Padding(
  //             padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
  //             child: Text(
  //               'Day(s) of Week',
  //               style: TextStyle(fontSize: 16),
  //             ),
  //           ),
  //           Wrap(
  //             children: <Widget>[
  //               for (String day in [
  //                 'Monday',
  //                 'Tuesday',
  //                 'Wednesday',
  //                 'Thursday',
  //                 'Friday',
  //                 'Saturday',
  //                 'Sunday',
  //               ])
  //                 Row(
  //                   children: [
  //                     Checkbox(
  //                       value: _selectedDaysOfWeek.contains(day),
  //                       onChanged: (bool? value) {
  //                         setState(() {
  //                           if (value != null) {
  //                             if (value) {
  //                               _selectedDaysOfWeek.add(day);
  //                             } else {
  //                               _selectedDaysOfWeek.remove(day);
  //                             }
  //                           }
  //                         });
  //                       },
  //                     ),
  //                     Text(day),
  //                   ],
  //                 ),
  //             ],
  //           ),
  //           TextField(
  //             controller: lessonTypeController,
  //             decoration: const InputDecoration(labelText: 'Lesson Type'),
  //           ),
  //           TextField(
  //             controller: lessonTimeController,
  //             decoration: const InputDecoration(labelText: 'Lesson Time'),
  //           ),
  //           const SizedBox(height: 16),
  //           ElevatedButton(
  //             onPressed: () async {
  //               try {
  //                 // Lesson 추가
  //                 await _firestore.collection('lessons').add({
  //                   'title': titleController.text,
  //                   'description': descriptionController.text,
  //                   'programName': programNameController.text,
  //                   'topic': topicController.text,
  //                   'tutor': tutorController.text,
  //                   'dayOfWeek': _selectedDaysOfWeek,
  //                   'lessonType': lessonTypeController.text,
  //                   'lessonTime': lessonTimeController.text,
  //                 });

  //                 if (kDebugMode) {
  //                   print('Lesson added successfully!');
  //                 } // 추가된 메시지를 확인하기 위한 로그

  //                 // 앞 화면으로 돌아가기
  //                 Navigator.pop(context);
  //               } catch (e) {
  //                 if (kDebugMode) {
  //                   print('Error adding lesson: $e');
  //                 } // 오류 메시지를 확인하기 위한 로그
  //               }
  //             },
  //             child: const Text('Add Lesson'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class EditLessonScreen extends StatefulWidget {
  final String lessonId;

  const EditLessonScreen({super.key, required this.lessonId});

  @override
  EditLessonScreenState createState() => EditLessonScreenState();
}

class EditLessonScreenState extends State<EditLessonScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController programNameController = TextEditingController();
  final TextEditingController topicController = TextEditingController();
  final TextEditingController tutorController = TextEditingController();
  final TextEditingController lessonTypeController = TextEditingController();
  final TextEditingController lessonTimeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> _selectedDaysOfWeek = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Lesson'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('lessons').doc(widget.lessonId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          var lesson = snapshot.data!.data() as Map<String, dynamic>;

          titleController.text = lesson['title'];
          descriptionController.text = lesson['description'];
          programNameController.text = lesson['programName'];
          topicController.text = lesson['topic'];
          tutorController.text = lesson['tutor'];
          _selectedDaysOfWeek = List<String>.from(lesson['dayOfWeek']);
          lessonTypeController.text = lesson['lessonType'];
          lessonTimeController.text = lesson['lessonTime'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: programNameController,
                  decoration: const InputDecoration(labelText: 'Program Name'),
                ),
                TextField(
                  controller: topicController,
                  decoration: const InputDecoration(labelText: 'Topic'),
                ),
                TextField(
                  controller: tutorController,
                  decoration: const InputDecoration(labelText: 'Tutor'),
                ),
                // Day of Week 선택
                const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Day(s) of Week',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Wrap(
                  children: <Widget>[
                    for (String day in [
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday',
                      'Sunday',
                    ])
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedDaysOfWeek.contains(day),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null) {
                                  if (value) {
                                    _selectedDaysOfWeek.add(day);
                                  } else {
                                    _selectedDaysOfWeek.remove(day);
                                  }
                                }
                              });
                            },
                          ),
                          Text(day),
                        ],
                      ),
                  ],
                ),
                TextField(
                  controller: lessonTypeController,
                  decoration: const InputDecoration(labelText: 'Lesson Type'),
                ),
                TextField(
                  controller: lessonTimeController,
                  decoration: const InputDecoration(labelText: 'Lesson Time'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Lesson 수정
                      await _firestore
                          .collection('lessons')
                          .doc(widget.lessonId)
                          .update({
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'programName': programNameController.text,
                        'topic': topicController.text,
                        'tutor': tutorController.text,
                        'dayOfWeek': _selectedDaysOfWeek,
                        'lessonType': lessonTypeController.text,
                        'lessonTime': lessonTimeController.text,
                      });

                      // 앞 화면으로 돌아가기
                      Navigator.pop(context);
                    } catch (e) {
                      if (kDebugMode) {
                        print('Error updating lesson: $e');
                      }
                    }
                  },
                  child: const Text('Update Lesson'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
