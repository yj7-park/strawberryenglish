// import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:strawberryenglish/models/student.dart';
// import 'package:strawberryenglish/models/tutor.dart';
// import 'package:strawberryenglish/providers/sheet_api_provider.dart';

// class TutorProvider extends ChangeNotifier {
//   Tutor? _tutor;
//   User? currentUser;
//   SheetApiProvider sheetApiProvider = SheetApiProvider();
//   Map<String, String> errorLogs = <String, String>{};
//   List<Student>? _students; // Added list to store students

//   Tutor? get tutor => _tutor;
//   List<Student>? get students => _students;

//   TutorProvider() {
//     _initTutor();
//   }

//   Future<void> _initTutor() async {
//     await sheetApiProvider.init();
//     currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       if (currentUser!.email != 'admin@admin.com') {
//         _tutor = await getTutor();
//         // _students = await getAllStudents();
//       }
//       notifyListeners();
//     }
//   }

//   Future<Tutor?> getTutor() async {
//     try {
//       currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         // Google Sheets에서 사용자 데이터 가져오기
//         return await getTutorFromGoogleSheets(currentUser!.email ?? '');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error getting User Data: $e');
//       }
//     }
//     return null;
//   }

//   Future<String> loginTutor(String username, String password) async {
//     try {
//       UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: username,
//         password: password,
//       );
//       currentUser = FirebaseAuth.instance.currentUser;
//       if (userCredential.user!.email == 'admin@admin.com') {
//         _tutor = null;
//       } else {
//         // Google Sheets에서 사용자 데이터 가져오기
//         _tutor = await getTutorFromGoogleSheets(username);
//         notifyListeners();
//       }
//       return "";
//     } catch (e) {
//       if (kDebugMode) {
//         print('Error logging in: $e');
//       }
//       return e.toString();
//     }
//   }

//   Future<Tutor> getTutorFromGoogleSheets(String email) async {
//     try {
//       var values = await sheetApiProvider.getTutorSheet();
//       // print(response.values);
//       for (var row in values) {
//         if (row.length > 6 && row[6].toString() == email) {
//           return Tutor.fromRow(row);
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Google Sheets에서 Tutor 가져오는 중 오류 발생: $e');
//       }
//     }
//     throw Exception('Tutor를 찾을 수 없습니다.');
//   }

//   Future<void> updateTutor(Tutor updatedTutor) async {
//     try {
//       currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         // Google Sheets에서 기존 사용자 데이터 가져오기
//         var values = await sheetApiProvider.getTutorSheet();
//         for (var i = 0; i < values.length; i++) {
//           var row = values[i];
//           if (row.length > 22 && row[6].toString() == updatedTutor.email) {
//             values[i] = updatedTutor.toRow();

//             // 업데이트된 데이터를 다시 Google Sheets에 기록합니다.
//             sheetApiProvider.updateTutorSheet(values[i], i);

//             // 사용자가 찾아졌고 업데이트되었으므로 루프를 종료합니다.
//             notifyListeners();
//             break;
//           }
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('Tutor 데이터 업데이트 중 오류 발생: $e');
//       }
//     }
//   }

//   Future<Student?> getStudent(String email) async {
//     for (var student in _students!) {
//       if (student.data['data']['email'] == email) {
//         return student;
//       }
//     }
//     return null;
//   }

//   // Future<List<Student>> getAllStudents() async {
//   //   try {
//   //     // Google Sheets에서 전체 사용자 데이터 가져오기
//   //     var values = await sheetApiProvider.getStudentSheet();
//   //     List<Student> students = [];

//   //     for (var row in values) {
//   //       if (row.length > 22) {
//   //         var student = Student.fromRow(row);
//   //         if (student.uid!.isEmpty) {
//   //           student.log = 'Has no account.';
//   //         }
//   //         if (errorLogs.keys.contains(student.uid)) {
//   //           student.log = errorLogs[student.uid]!;
//   //         }
//   //         if (student.tutor != _tutor!.name) {
//   //           continue;
//   //         }
//   //         students.add(student);
//   //         // try {
//   //         //   UserCredential userCredential =
//   //         //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//   //         //     email: user.email,
//   //         //     password: 'password',
//   //         //   );
//   //         // } catch (e) {
//   //         //   print('${user.email} exists.');
//   //         // }
//   //       }
//   //     }

//   //     // add logs for error users
//   //     return students;
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print('Error getting all users: $e');
//   //     }
//   //   }

//   //   return [];
//   // }

//   // Future<void> updateStudent(Student updatedStudent) async {
//   //   try {
//   //     currentUser = FirebaseAuth.instance.currentUser;
//   //     if (currentUser != null) {
//   //       // Google Sheets에서 기존 사용자 데이터 가져오기
//   //       var values = await sheetApiProvider.getStudentSheet();
//   //       for (var i = 0; i < values.length; i++) {
//   //         var row = values[i];
//   //         if (row.length > 22 && row[6].toString() == updatedStudent.email) {
//   //           values[i] = updatedStudent.toRow();

//   //           // 업데이트된 데이터를 다시 Google Sheets에 기록합니다.
//   //           sheetApiProvider.updateStudentSheet(values[i], i);

//   //           // 사용자가 찾아졌고 업데이트되었으므로 루프를 종료합니다.
//   //           notifyListeners();
//   //           break;
//   //         }
//   //       }
//   //     }
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print('사용자 데이터 업데이트 중 오류 발생: $e');
//   //     }
//   //   }
//   // }

//   // Future<List<Student>?> updateAllStudents() async {
//   //   try {
//   //     for (var student in _students!) {
//   //       try {
//   //         if (student.uid!.isNotEmpty) continue;
//   //         UserCredential userCredential =
//   //             await FirebaseAuth.instance.createUserWithEmailAndPassword(
//   //           email: student.email,
//   //           password: 'password',
//   //         );
//   //         student.uid = userCredential.user!.uid;
//   //         updateStudent(student);
//   //       } catch (e) {
//   //         errorLogs[student.uid!] = e.toString();
//   //         student.log = e.toString();
//   //       }
//   //       if (kDebugMode) {
//   //         print(
//   //             '${student.email} ${student.log.isNotEmpty ? student.log : 'created successfully.'} ');
//   //       }
//   //     }
//   //     return _students;
//   //   } catch (e) {
//   //     if (kDebugMode) {
//   //       print('Error update all students: $e');
//   //     }
//   //   }

//   //   return _students;
//   // }
// }
