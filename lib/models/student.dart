import 'package:flutter/foundation.dart';

class Student {
  late Map<String, dynamic> data;

  Student({
    required this.data,
  });

  Student.fromRow(List<Object?> row) {
    try {
      int index = 0;
      data = {};
      // data['uid'] = row[index] as String;
      index++;
      // data['id'] = int.tryParse(row[index] as String) ?? 0;
      index++;
      data['name'] = row[index] as String;
      index++;
      data['gender'] = row[index] as String?;
      index++;
      data['birthDate'] = row[index] as String?;
      index++;
      data['phoneNumber'] = row[index] as String?;
      index++;
      data['email'] = row[index] as String;
      index++;
      data['country'] = row[index] as String?;
      index++;
      data['program'] = row[index] as String?;
      index++;
      data['studyPurpose'] = row[index] as String?;
      index++;
      data['tutor'] = row[index] as String?;
      index++;
      data['skypeId'] = row[index] as String?;
      index++;
      data['topic'] = row[index] as String?;
      index++;
      data['cancelRequestDates'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
          : [];
      index++;
      data['cancelDates'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
          : [];
      index++;
      data['tutorCancelDates'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
          : [];
      index++;
      data['cancelCountLeft'] = int.tryParse(row[index] as String) ?? 0;
      index++;
      data['cancelCountTotal'] = int.tryParse(row[index] as String) ?? 0;
      index++;
      data['holdRequestDates'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
          : [];
      index++;
      data['holdDates'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
          : [];
      index++;
      data['holdCountLeft'] = int.tryParse(row[index] as String) ?? 0;
      index++;
      data['holdCountTotal'] = int.tryParse(row[index] as String) ?? 0;
      index++;
      data['lessonDay'] = row[index] as String;
      index++;
      data['lessonTime'] = (row[index] as String?)!.isNotEmpty
          ? (row[index] as String?)?.split('\n').map((e) => e.trim()).toList()
          : [];
      index++;
      // data['philippinesTime'] = row[index] as String?;
      index++;
      data['lessonStartDate'] = row[index] as String;
      index++;
      data['paymentAmount'] = row[index] as String?;
      index++;
      data['lessonEndDate'] = row[index] as String;
      index++;
      data['modifiedLessonEndDate'] = row[index] as String;
      index++;
      data['extensionRequestMessage'] = row[index] as String;
      index++;

      data['referralSource'] = '';
      data['level'] = '';
      data['comments'] = '';
      data['oneWeekNotice'] = '';
      data['coupon'] = '';

      try {
        data['referralSource'] = row[index] as String;
        index++;
        data['level'] = row[index] ?? '';
        index++;
        data['comments'] = row[index] ?? '';
        index++;
        data['oneWeekNotice'] = row[index] ?? '';
        index++;
        data['coupon'] = row[index] ?? '';
        index++;
      } catch (_) {}
    } catch (e) {
      if (kDebugMode) {
        print('Exception: ' + e.toString());
      }
    }
  }

  StudentState getStudentState({DateTime? now}) {
    now ??= DateTime.now();
    if ((data['tutor'] ?? '').isNotEmpty) {
      if (!((DateTime.tryParse(data['modifiedLessonEndDate'] ?? '') ??
              DateTime.tryParse(data['lessonEndDate'] ?? '') ??
              now)
          .isBefore(now))) {
        bool inHold = false;
        for (String range in data['holdDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1])
                .add(const Duration(days: 1))
                .subtract(const Duration(microseconds: 1));
            if (startDate.isBefore(endDate) &&
                (startDate.isBefore(now) && endDate.isAfter(now))) {
              inHold = true;
              break;
            }
          }
        }
        if (inHold) {
          return StudentState.lectureOnHold;
        } else {
          return StudentState.lectureOnGoing;
        }
      } else {
        return StudentState.lectureFinished;
      }
    } else if ((data['lessonEndDate'] ?? '').isNotEmpty &&
        (data['tutor'] ?? '').isEmpty) {
      return StudentState.lectureRequested;
    } else if ((data['trialTutor'] ?? '').isNotEmpty &&
        (DateTime.tryParse('${data['trialDate']} ${data['trialTime']}') !=
            null)) {
      var trialDate = DateTime.parse(data['trialDate']);
      if (trialDate.isBefore(now)) {
        return StudentState.trialFinished;
      } else {
        return StudentState.trialConfirmed;
      }
    } else if ((data['trialDay'] ?? '').isNotEmpty) {
      return StudentState.trialRequested;
    } else {
      return StudentState.registeredOnly;
    }
  }

  StudentState getStudentTrialState({DateTime? now}) {
    now ??= DateTime.now();
    if ((data['trialTutor'] ?? '').isNotEmpty &&
        (DateTime.tryParse(
                '${data['trialDate'] ?? ''} ${data['trialTime'] ?? ''}') !=
            null)) {
      var trialDate = DateTime.parse(data['trialDate']);
      if (trialDate.isBefore(now)) {
        return StudentState.trialFinished;
      } else {
        return StudentState.trialConfirmed;
      }
    } else if ((data['trialDay'] ?? '').isNotEmpty) {
      return StudentState.trialRequested;
    } else {
      return StudentState.registeredOnly;
    }
  }

  StudentState getStudentLectureState({DateTime? now}) {
    now ??= DateTime.now();
    if ((data['tutor'] ?? '').isNotEmpty) {
      if ((DateTime.tryParse(data['modifiedLessonEndDate'] ?? '') ??
              DateTime.tryParse(data['lessonEndDate'] ?? '') ??
              now)
          .isAfter(now)) {
        bool inHold = false;
        for (String range in data['holdDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1])
                .add(const Duration(days: 1))
                .subtract(const Duration(microseconds: 1));
            if (startDate.isBefore(endDate) &&
                (startDate.isBefore(now) && endDate.isAfter(now))) {
              inHold = true;
              break;
            }
          }
        }
        if (inHold) {
          return StudentState.lectureOnHold;
        } else {
          return StudentState.lectureOnGoing;
        }
      } else {
        return StudentState.lectureFinished;
      }
    } else if ((data['lessonEndDate'] ?? '').isNotEmpty &&
        (data['tutor'] ?? '').isEmpty) {
      return StudentState.lectureRequested;
    } else {
      return StudentState.registeredOnly;
    }
  }
}

enum StudentState {
  registeredOnly,
  trialRequested,
  trialConfirmed,
  trialFinished,
  lectureRequested,
  lectureOnGoing,
  lectureOnHold,
  lectureFinished
}
