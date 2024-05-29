import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/sheet_api_provider.dart';

class StudentProvider extends ChangeNotifier {
  Student? _student;
  User? currentUser;
  SheetApiProvider sheetApiProvider = SheetApiProvider();
  Map<String, String> errorLogs = <String, String>{};

  Student? get student => _student;

  StudentProvider() {
    _initStudent();
  }

  Future<void> _initStudent() async {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await sheetApiProvider.init();
      if (currentUser!.email != 'admin@admin.com') {
        _student = await getStudent();
      }
      notifyListeners();
    }
  }

  Future<Student?> getStudent() async {
    if (_student != null) return _student;

    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Google Sheets에서 사용자 데이터 가져오기
        // return await getStudentFromGoogleSheets(currentUser!.email ?? '');
        return await getStudentFromFirestore(currentUser!.email!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Student Data: $e');
      }
    }
    return null;
  }

  Future<String> loginStudent(String username, String password) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
      }
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser!.email == 'admin@admin.com') {
        _student = null;
      } else {
        // Google Sheets에서 사용자 데이터 가져오기
        // _student = await getStudentFromGoogleSheets(username);
        _student = await getStudentFromFirestore(username);
        notifyListeners();
      }
      return "";
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      return e.toString();
    }
  }

  Future<Student> getStudentFromGoogleSheets(String email) async {
    try {
      var values = await sheetApiProvider.getStudentSheet();
      // print(response.values);
      for (var row in values) {
        if (row.length > 22 && row[6].toString() == email) {
          return Student.fromRow(row);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Google Sheets에서 Student 가져오는 중 오류 발생: $e');
      }
    }
    throw Exception('Student를 찾을 수 없습니다.');
  }

  Future<Student> getStudentFromFirestore(String email) async {
    try {
      var values =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      // print(response.values);
      return Student.fromFirebase(values);
    } catch (e) {
      if (kDebugMode) {
        print('Firestore에서 Student 가져오는 중 오류 발생: $e');
      }
    }
    throw Exception('Student를 찾을 수 없습니다.');
  }

  Future<void> updateStudent(Student updatedStudent) async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Google Sheets에서 기존 사용자 데이터 가져오기
        var values = await sheetApiProvider.getStudentSheet();
        for (var i = 0; i < values.length; i++) {
          var row = values[i];
          if (row.length > 22 && row[6].toString() == updatedStudent.email) {
            values[i] = updatedStudent.toRow();

            // 업데이트된 데이터를 다시 Google Sheets에 기록합니다.
            sheetApiProvider.updateStudentSheet(values[i], i);

            // 사용자가 찾아졌고 업데이트되었으므로 루프를 종료합니다.
            notifyListeners();
            break;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Student 데이터 업데이트 중 오류 발생: $e');
      }
    }
  }

  Future<void> updateStudentToFirestore(Student updatedStudent) async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Google Sheets에서 기존 사용자 데이터 가져오기
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.email)
            .set({
          "uid": updatedStudent.uid,
          "id": updatedStudent.id,
          "name": updatedStudent.name,
          "gender": updatedStudent.gender,
          "birthDate": updatedStudent.birthDate,
          "phoneNumber": updatedStudent.phoneNumber,
          "email": updatedStudent.email,
          "country": updatedStudent.country,
          "program": updatedStudent.program,
          "studyPurpose": updatedStudent.studyPurpose,
          "tutor": updatedStudent.tutor,
          "skypeId": updatedStudent.skypeId,
          "topic": updatedStudent.topic,
          "cancelRequestDates": updatedStudent.cancelRequestDates,
          "cancelDates": updatedStudent.cancelDates,
          "tutorCancelDates": updatedStudent.tutorCancelDates,
          "cancelCountLeft": updatedStudent.cancelCountLeft,
          "cancelCountTotal": updatedStudent.cancelCountTotal,
          "holdRequestDates": updatedStudent.holdRequestDates,
          "holdDates": updatedStudent.holdDates,
          "holdCountLeft": updatedStudent.holdCountLeft,
          "holdCountTotal": updatedStudent.holdCountTotal,
          "lessonDay": updatedStudent.lessonDay,
          "lessonTime": updatedStudent.lessonTime,
          "philippinesTime": updatedStudent.philippinesTime,
          "lessonStartDate": updatedStudent.lessonStartDate,
          "paymentAmount": updatedStudent.paymentAmount,
          "lessonEndDate": updatedStudent.lessonEndDate,
          "modifiedLessonEndDate": updatedStudent.modifiedLessonEndDate,
          "extensionRequestMessage": updatedStudent.extensionRequestMessage,
          "referralSource": updatedStudent.referralSource,
        });
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Student 데이터 업데이트 중 오류 발생: $e');
      }
    }
  }

  Future<List<Student>> getAllStudents() async {
    try {
      // Google Sheets에서 전체 사용자 데이터 가져오기
      var values = await sheetApiProvider.getStudentSheet();
      List<Student> students = [];
      for (var row in values) {
        if (row.length > 22) {
          var student = Student.fromRow(row);
          if (student.uid!.isEmpty) {
            student.log = 'Has no account.';
          }
          if (errorLogs.keys.contains(student.uid)) {
            student.log = errorLogs[student.uid]!;
          }
          students.add(student);
          // try {
          //   UserCredential userCredential =
          //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
          //     email: user.email,
          //     password: 'password',
          //   );
          // } catch (e) {
          //   print('${user.email} exists.');
          // }
        }
      }

      // add logs for error students
      notifyListeners();
      return students;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting all students: $e');
      }
    }

    return [];
  }

  Future<List<Student>> addAllStudents() async {
    try {
      // Google Sheets에서 전체 사용자 데이터 가져오기
      var response = await sheetApiProvider.sheetsApi.spreadsheets.values.get(
        '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
        '최신 고객 목록!A6:AO505',
      );

      var values = response.values!;
      List<Student> students = [];

      for (var row in values) {
        if (row.length > 22) {
          var student = Student.fromRow(row);
          try {
            if (student.uid!.isNotEmpty) continue;
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: student.email,
              password: 'password',
            );
            student.uid = userCredential.user!.uid;
            updateStudent(student);
          } catch (e) {
            errorLogs[student.uid!] = e.toString();
            student.log = e.toString();
          }
          if (kDebugMode) {
            print(
                '${student.email} ${student.log.isNotEmpty ? student.log : 'created successfully.'} ');
          }
          students.add(student);
        }
      }
      return students;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding all students: $e');
      }
    }

    return [];
  }

  Future<List<Student>> checkAllStudents() async {
    try {
      // Google Sheets에서 전체 사용자 데이터 가져오기
      var response = await sheetApiProvider.sheetsApi.spreadsheets.values.get(
        '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
        '최신 고객 목록!A6:AO505',
      );

      var values = response.values!;
      List<Student> students = [];

      for (var row in values) {
        if (row.length > 22) {
          var student = Student.fromRow(row);
          try {
            await FirebaseAuth.instance
                .fetchSignInMethodsForEmail(student.email);
          } catch (e) {
            if (kDebugMode) {
              student.log = e.toString();
            }
          }
          if (kDebugMode) {
            print('${student.email} ${student.log}');
          }
          students.add(student);
        }
      }
      return students;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking all students: $e');
      }
    }

    return [];
  }
}
