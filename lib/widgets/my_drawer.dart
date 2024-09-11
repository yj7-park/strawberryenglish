import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

// ignore_for_file: library_private_types_in_public_api

import 'package:strawberryenglish/widgets/my_app_bar.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late StudentProvider studentProvider;

  @override
  Widget build(BuildContext context) {
    studentProvider = Provider.of<StudentProvider>(context);
    return FutureBuilder<(Student?, List<Student>)>(
      future: studentProvider.getStudentAndList(), // 새로운 Future 생성
      builder: (context, snapshot) {
        var student = snapshot.data?.$1;
        var studentList = snapshot.data?.$2.where(
            (e) => e.getStudentLectureState() != StudentState.lectureFinished);
        bool isLoggedIn = student != null;
        bool isAdmin =
            student != null && student.data['email'] == 'admin@admin.com';
        return PointerInterceptor(
          child: Drawer(
            width: 250,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // color: customTheme.colorScheme.secondary,
                        height: 120,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/small_logo.png',
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                '딸기영어',
                                style: TextStyle(
                                  fontSize: 33,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        color: customTheme.colorScheme.secondary,
                        height: 65,
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (isLoggedIn) ...[
                              !isAdmin
                                  ? DropdownMenu<Student>(
                                      onSelected: (value) {
                                        studentProvider
                                            .setStudent(value!.data['email']);
                                      },
                                      width: 250,
                                      textStyle: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      initialSelection: studentList!.firstWhere(
                                          (e) =>
                                              e.data['email'] ==
                                              student.data['email']),
                                      requestFocusOnTap: false,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        constraints: BoxConstraints.tight(
                                          const Size.fromHeight(35),
                                        ),
                                      ),
                                      dropdownMenuEntries: studentList.map((e) {
                                        return DropdownMenuEntry<Student>(
                                          style: MenuItemButton.styleFrom(
                                            minimumSize: const Size(250, 35),
                                            // padding: EdgeInsets.symmetric(
                                            //     horizontal: 10, vertical: 0,),
                                          ),
                                          value: e,
                                          label: userTitleString(e),
                                        );
                                      }).toList(),
                                    )
                                  : const Text(
                                      '🛡관리자모드🛡',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                              const SizedBox(width: 20),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                signinButton(context, isLoggedIn),
                                const SizedBox(width: 10),
                                loginButton(
                                    context, isLoggedIn, studentProvider),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            myDrawerTile(context, '딸기영어', '/introduction',
                                highlight: true),
                            myDrawerTile(context, '뭐가달라?', '/introduction'),
                            myDrawerTile(context, '공지사항', '/announcement'),
                            const SizedBox(height: 20),
                            myDrawerTile(context, '수업안내', '/lectures',
                                highlight: true),
                            myDrawerTile(context, '수강안내', '/lectures'),
                            myDrawerTile(context, '수업토픽', '/topics'),
                            myDrawerTile(context, '튜터소개', '/tutors'),
                            myDrawerTile(context, '수강료', '/tuitionfee'),
                            myDrawerTile(context, 'FAQ', '/faq'),
                            const SizedBox(height: 20),
                            myDrawerTile(context, '딸기후기', '/feedbacks',
                                highlight: true),
                            if (isAdmin) ...[
                              const SizedBox(height: 20),
                              myDrawerTile(
                                  context, '🛡관리자메뉴', '/admin_students',
                                  highlight: true),
                              myDrawerTile(
                                  context, '🛡학생정보', '/admin_students'),
                              myDrawerTile(
                                  context, '🛡후기관리', '/admin_feedbacks'),
                            ],
                            const SizedBox(height: 75),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isAdmin)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    width: 250,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: customTheme.colorScheme.secondary,
                              width: 2,
                            ),
                          ),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            trialButton(context, isLoggedIn),
                            const SizedBox(width: 10),
                            enrollButton(context, isLoggedIn),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget myDrawerTile(context, text, url, {highlight = false}) {
  return ListTile(
    dense: true,
    title: Text(
      text,
      textAlign: TextAlign.center,
      style: highlight
          ? const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)
          : const TextStyle(fontSize: 15),
    ),
    onTap: () {
      Navigator.pushNamed(context, url).then((_) => context.setState(() {}));
    },
  );
}
