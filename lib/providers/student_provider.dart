import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:strawberryenglish/models/student.dart';
// import 'package:strawberryenglish/providers/sheet_api_provider.dart';

class StudentProvider extends ChangeNotifier {
  Student? _student;
  List<Student> _studentList = [];

  User? currentUser;
  // SheetApiProvider sheetApiProvider = SheetApiProvider();
  Map<String, String> errorLogs = <String, String>{};

  Student? get student => _student;
  List<Student>? get studentList => _studentList;

  StudentProvider() {
    _initStudent();
  }

  Future<void> _initStudent() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if ((currentUser != null) && (currentUser!.email != null)) {
      // await sheetApiProvider.init().then((_) {});
      if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
        _student = await getStudent();
        _studentList = await getStudentList(currentUser!.email!);
        notifyListeners();
      }
    }
    // print('initializing');
    // getAndSetAllStudents();
  }

  Future<void> setStudent(String email) async {
    try {
      if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
        _student = Student(data: {'admin': true, 'email': currentUser!.email});
      } else {
        // Google Sheets에서 사용자 데이터 가져오기
        // return await getStudentFromGoogleSheets(currentUser!.email ?? '');
        _student = await getStudentFromFirestore(email);
        _studentList = await getStudentListFromFirestore(currentUser!.email!);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Student Data: $e');
      }
    }
  }

  Future<(Student?, List<Student>)> getStudentAndList() async {
    return (await getStudent(), await getStudentList(_student!.data['email']));
  }

  Future<Student?> getStudent({String? email, bool force = false}) async {
    if (currentUser == null) return null;
    // if (_student != null) return _student;

    email ??= student != null ? student!.data['email'] : currentUser!.email;
    // 계정 별 복수개 수업 DB 기능
    // if (index != null) {
    //   email = '$email#$index';
    // }
    if ((force == false) &&
        (_student != null) &&
        (_student!.data['email'].contains(email))) {
      return _student;
    }

    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
          _student =
              Student(data: {'admin': true, 'email': currentUser!.email});
        } else {
          // Google Sheets에서 사용자 데이터 가져오기
          // return await getStudentFromGoogleSheets(currentUser!.email ?? '');
          _student = await getStudentFromFirestore(email!);
        }
        return _student;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Student Data: $e');
      }
    }
    return null;
  }

  Stream<Student?> getStudentStream(
      {String? email, bool force = false}) async* {
    if (currentUser == null) yield* Stream<Student?>.value(null);
    // if (_student != null) return _student;

    email ??= student != null ? student!.data['email'] : currentUser!.email;
    // 계정 별 복수개 수업 DB 기능
    // if (index != null) {
    //   email = '$email#$index';
    // }
    if ((force == false) &&
        (_student != null) &&
        (_student!.data['email'].contains(email))) {
      yield _student;
    }

    try {
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
          _student =
              Student(data: {'admin': true, 'email': currentUser!.email});
        } else {
          // Google Sheets에서 사용자 데이터 가져오기
          // return await getStudentFromGoogleSheets(currentUser!.email ?? '');
          _student = await getStudentFromFirestore(email!);
        }
        yield _student;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Student Data: $e');
      }
    }
    yield null;
  }

  Future<List<Student>> getStudentList(String email) async {
    if (currentUser == null) return [];

    // 계정 별 복수개 수업 DB 기능
    if (_studentList.isNotEmpty) {
      return _studentList;
    }

    try {
      // Google Sheets에서 사용자 데이터 가져오기
      if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
        _studentList = [];
      } else {
        _studentList = await getStudentListFromFirestore(email);
      }
      return _studentList;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Student Data: $e');
      }
    }
    return [];
  }

  Future<String> loginStudent(String username, String password) async {
    try {
      if ((FirebaseAuth.instance.currentUser == null) ||
          (FirebaseAuth.instance.currentUser!.email != username)) {
        UserCredential _ =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
      }
      currentUser = FirebaseAuth.instance.currentUser;
      if ((currentUser!.email ?? '').endsWith('@sb.english.com')) {
        _student = Student(data: {'admin': true, 'email': currentUser!.email});
      } else {
        // Google Sheets에서 사용자 데이터 가져오기
        // _student = await getStudentFromGoogleSheets(username);
        _student = await getStudentFromFirestore(username);
        _studentList = await getStudentList(currentUser!.email!);
      }
      notifyListeners();
      return "";
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      return e.toString();
    }
  }

  Future<void> logoutStudent() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.signOut();
    }
    _student = null;
    _studentList = [];
    notifyListeners();
  }

  // Future<Student> getStudentFromGoogleSheets(String email) async {
  //   try {
  //     var values = await sheetApiProvider.getStudentSheet();
  //     // print(response.values);
  //     for (var row in values) {
  //       if (row.length > 22 && row[6].toString() == email) {
  //         return Student.fromRow(row);
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Google Sheets에서 Student 가져오는 중 오류 발생: $e');
  //     }
  //   }
  //   throw Exception('Student를 찾을 수 없습니다.');
  // }

  Future<Student> getStudentFromFirestore(String email) async {
    try {
      var values =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      // print(response.values);
      return Student(data: values.data()!);
    } catch (e) {
      if (kDebugMode) {
        print('$email : Firestore에서 Student 가져오는 중 오류 발생: $e');
      }
    }
    throw Exception('Student를 찾을 수 없습니다.');
  }

  Future<List<Student>> getStudentListFromFirestore(String email) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('users').get();
      List<Student> result = snapshot.docs
          .where((e) => e.id.startsWith(email))
          .map((e) => Student(data: e.data()))
          .toList();

      // print(response.values);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Firestore에서 StudentList 가져오는 중 오류 발생: $e');
      }
    }
    throw Exception('Student를 찾을 수 없습니다.');
  }

  // Future<void> updateStudent(Student updatedStudent) async {
  //   try {
  //     currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser != null) {
  //       // Google Sheets에서 기존 사용자 데이터 가져오기
  //       var values = await sheetApiProvider.getStudentSheet();
  //       for (var i = 0; i < values.length; i++) {
  //         var row = values[i];
  //         if (row.length > 22 && row[6].toString() == updatedStudent.email) {
  //           values[i] = updatedStudent.toRow();

  //           // 업데이트된 데이터를 다시 Google Sheets에 기록합니다.
  //           sheetApiProvider.updateStudentSheet(values[i], i);

  //           // 사용자가 찾아졌고 업데이트되었으므로 루프를 종료합니다.
  //           notifyListeners();
  //           break;
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Student 데이터 업데이트 중 오류 발생: $e');
  //     }
  //   }
  // }

  // Future<void> updateStudentToFirestore(Student updatedStudent) async {
  //   try {
  //     currentUser = FirebaseAuth.instance.currentUser;
  //     if (currentUser != null) {
  //       // Google Sheets에서 기존 사용자 데이터 가져오기
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(currentUser!.email)
  //           .set({
  //         "uid": updatedStudent.uid,
  //         "id": updatedStudent.id,
  //         "name": updatedStudent.name,
  //         "gender": updatedStudent.gender,
  //         "birthDate": updatedStudent.birthDate,
  //         "phoneNumber": updatedStudent.phoneNumber,
  //         "email": updatedStudent.email,
  //         "country": updatedStudent.country,
  //         "program": updatedStudent.program,
  //         "studyPurpose": updatedStudent.studyPurpose,
  //         "tutor": updatedStudent.tutor,
  //         "skypeId": updatedStudent.skypeId,
  //         "topic": updatedStudent.topic,
  //         "cancelRequestDates": updatedStudent.cancelRequestDates,
  //         "cancelDates": updatedStudent.cancelDates,
  //         "tutorCancelDates": updatedStudent.tutorCancelDates,
  //         "cancelCountLeft": updatedStudent.cancelCountLeft,
  //         "cancelCountTotal": updatedStudent.cancelCountTotal,
  //         "holdRequestDates": updatedStudent.holdRequestDates,
  //         "holdDates": updatedStudent.holdDates,
  //         "holdCountLeft": updatedStudent.holdCountLeft,
  //         "holdCountTotal": updatedStudent.holdCountTotal,
  //         "lessonDay": updatedStudent.lessonDay,
  //         "lessonTime": updatedStudent.lessonTime,
  //         "philippinesTime": updatedStudent.philippinesTime,
  //         "lessonStartDate": updatedStudent.lessonStartDate,
  //         "paymentAmount": updatedStudent.paymentAmount,
  //         "lessonEndDate": updatedStudent.lessonEndDate,
  //         "modifiedLessonEndDate": updatedStudent.modifiedLessonEndDate,
  //         "extensionRequestMessage": updatedStudent.extensionRequestMessage,
  //         "referralSource": updatedStudent.referralSource,
  //         "points": updatedStudent.points,
  //       });
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Student 데이터 업데이트 중 오류 발생: $e');
  //     }
  //   }
  // }

  Future<void> updateStudentToFirestoreWithMap(Student updatedStudent) async {
    try {
      // currentUser = FirebaseAuth.instance.currentUser;
      // if (currentUser != null) {
      // Google Sheets에서 기존 사용자 데이터 가져오기
      FirebaseFirestore.instance
          .collection('users')
          // .doc(currentUser!.email)
          .doc(updatedStudent.data['email'])
          .set(updatedStudent.data);
      notifyListeners();
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Student 데이터 업데이트 중 오류 발생: $e');
      }
    }
  }

  Future<void> updateStudentListField(String field, dynamic value) async {
    for (var student in _studentList) {
      student.data[field] = value;
      updateStudentToFirestoreWithMap(student);
    }
  }

  // Future<List<Student>> getAndSetAllStudents() async {
  //   try {
  //     // Google Sheets에서 전체 사용자 데이터 가져오기
  //     var values = await sheetApiProvider.getStudentSheet();
  //     List<Student> students = [];
  //     for (var row in values) {
  //       if (row.length > 22) {
  //         try {
  //           var student = Student.fromRow(row);
  //           // try {
  //           //   getStudentFromFirestore(student.data['email']);
  //           //   print('${student.data['email']} exists!!!');
  //           // } catch (e) {
  //           print(student.data);
  //           student.data['points'] = 0;

  //           // student.data['lessonTime'] as List<String>의 각 element에서 ','와 '_x000D_'을 삭제
  //           (student.data['lessonTime'] as List<String>).map(
  //               (String e) => e.replaceAll(',', '').replaceAll('_x000D_', ''));

  //           for (var i = 0; i < student.data['lessonTime'].length; i++) {
  //             student.data['lessonTime'][i] = student.data['lessonTime'][i]
  //                 .replaceAll('_x000D_', '')
  //                 .replaceAll(',', '');
  //           }
  //           print(student.data);
  //           updateStudentToFirestoreWithMap(student);
  //           // }
  //         } catch (e) {
  //           print(row[6]);
  //           print(e);
  //         }
  //         // students.add(student);
  //         // try {
  //         //   UserCredential userCredential =
  //         //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         //     email: user.email,
  //         //     password: 'password',
  //         //   );
  //         // } catch (e) {
  //         //   print('${user.email} exists.');
  //         // }
  //       }
  //     }

  //     // add logs for error students
  //     // notifyListeners();
  //     return students;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error getting all students: $e');
  //     }
  //   }

  //   return [];
  // }

  // Future<List<Student>> addAllStudents() async {
  //   try {
  //     // Google Sheets에서 전체 사용자 데이터 가져오기
  //     var response = await sheetApiProvider.sheetsApi.spreadsheets.values.get(
  //       '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
  //       '최신 고객 목록!A6:AO505',
  //     );

  //     var values = response.values!;
  //     List<Student> students = [];

  //     for (var row in values) {
  //       if (row.length > 22) {
  //         var student = Student.fromRow(row);
  //         try {
  //           if (student.uid!.isNotEmpty) continue;
  //           UserCredential userCredential =
  //               await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //             email: student.email,
  //             password: 'password',
  //           );
  //           student.uid = userCredential.user!.uid;
  //           updateStudent(student);
  //         } catch (e) {
  //           errorLogs[student.uid!] = e.toString();
  //           student.log = e.toString();
  //         }
  //         if (kDebugMode) {
  //           print(
  //               '${student.email} ${student.log.isNotEmpty ? student.log : 'created successfully.'} ');
  //         }
  //         students.add(student);
  //       }
  //     }
  //     return students;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error adding all students: $e');
  //     }
  //   }

  //   return [];
  // }

  // Future<List<Student>> checkAllStudents() async {
  //   try {
  //     // Google Sheets에서 전체 사용자 데이터 가져오기
  //     var response = await sheetApiProvider.sheetsApi.spreadsheets.values.get(
  //       '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
  //       '최신 고객 목록!A6:AO505',
  //     );

  //     var values = response.values!;
  //     List<Student> students = [];

  //     for (var row in values) {
  //       if (row.length > 22) {
  //         var student = Student.fromRow(row);
  //         try {
  //           await FirebaseAuth.instance
  //               .fetchSignInMethodsForEmail(student.email);
  //         } catch (e) {
  //           if (kDebugMode) {
  //             student.log = e.toString();
  //           }
  //         }
  //         if (kDebugMode) {
  //           print('${student.email} ${student.log}');
  //         }
  //         students.add(student);
  //       }
  //     }
  //     return students;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error checking all students: $e');
  //     }
  //   }

  //   return [];
  // }
}
