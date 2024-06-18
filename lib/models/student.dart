import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String? uid;
  int? id;
  String? name;
  String? gender;
  String? birthDate;
  String? phoneNumber;
  late String email;
  String? country;
  String? program;
  String? studyPurpose;
  String? tutor;
  String? skypeId;
  String? topic;
  List<String>? cancelRequestDates;
  List<String>? cancelDates;
  List<String>? tutorCancelDates;
  int? cancelCountLeft;
  int? cancelCountTotal;
  List<String>? holdRequestDates;
  List<String>? holdDates;
  int? holdCountLeft;
  int? holdCountTotal;
  String? lessonDay;
  String? lessonTime;
  String? philippinesTime;
  String? lessonStartDate;
  String? paymentAmount;
  String? lessonEndDate;
  String? modifiedLessonEndDate;
  String? extensionRequestMessage;
  String? referralSource;
  int? points;
  // String level;
  // String features;
  // String feedback;
  // String reenrollment;
  String log = '';

  Student({
    this.uid,
    this.id,
    this.name,
    this.gender,
    this.birthDate,
    this.phoneNumber,
    required this.email,
    this.country,
    this.program,
    this.studyPurpose,
    this.tutor,
    this.skypeId,
    this.topic,
    this.cancelRequestDates,
    this.cancelDates,
    this.tutorCancelDates,
    this.cancelCountLeft,
    this.cancelCountTotal,
    this.holdRequestDates,
    this.holdDates,
    this.holdCountLeft,
    this.holdCountTotal,
    this.lessonDay,
    this.lessonTime,
    this.philippinesTime,
    this.lessonStartDate,
    this.paymentAmount,
    this.lessonEndDate,
    this.modifiedLessonEndDate,
    this.extensionRequestMessage,
    this.referralSource,
    this.points,
  });

  Student.fromFirebase(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      uid = snapshot['uid'];
    } catch (e) {
      uid = null;
    }
    try {
      id = snapshot['id'];
    } catch (e) {
      id = null;
    }
    try {
      name = snapshot['name'];
    } catch (e) {
      name = null;
    }
    try {
      gender = snapshot['gender'];
    } catch (e) {
      gender = null;
    }
    try {
      birthDate = snapshot['birthDate'];
    } catch (e) {
      birthDate = null;
    }
    try {
      phoneNumber = snapshot['phoneNumber'];
    } catch (e) {
      phoneNumber = null;
    }
    email = snapshot['email'];
    try {
      country = snapshot['country'];
    } catch (e) {
      country = null;
    }
    try {
      program = snapshot['program'];
    } catch (e) {
      program = null;
    }
    try {
      studyPurpose = snapshot['studyPurpose'];
    } catch (e) {
      studyPurpose = null;
    }
    try {
      tutor = snapshot['tutor'];
    } catch (e) {
      tutor = null;
    }
    try {
      skypeId = snapshot['skypeId'];
    } catch (e) {
      skypeId = null;
    }
    try {
      topic = snapshot['topic'];
    } catch (e) {
      topic = null;
    }
    try {
      cancelRequestDates =
          (snapshot['cancelRequestDates'] as List).cast<String>();
    } catch (e) {
      cancelRequestDates = null;
    }
    try {
      cancelDates = (snapshot['cancelDates'] as List).cast<String>();
    } catch (e) {
      cancelDates = null;
    }
    try {
      tutorCancelDates = (snapshot['tutorCancelDates'] as List).cast<String>();
    } catch (e) {
      tutorCancelDates = null;
    }
    try {
      cancelCountLeft = snapshot['cancelCountLeft'];
    } catch (e) {
      cancelCountLeft = null;
    }
    try {
      cancelCountTotal = snapshot['cancelCountTotal'];
    } catch (e) {
      cancelCountTotal = null;
    }
    try {
      holdRequestDates = (snapshot['holdRequestDates'] as List).cast<String>();
    } catch (e) {
      holdRequestDates = null;
    }
    try {
      holdDates = (snapshot['holdDates'] as List).cast<String>();
    } catch (e) {
      holdDates = null;
    }
    try {
      holdCountLeft = snapshot['holdCountLeft'];
    } catch (e) {
      holdCountLeft = null;
    }
    try {
      holdCountTotal = snapshot['holdCountTotal'];
    } catch (e) {
      holdCountTotal = null;
    }
    try {
      lessonDay = snapshot['lessonDay'];
    } catch (e) {
      lessonDay = null;
    }
    try {
      lessonTime = snapshot['lessonTime'];
    } catch (e) {
      lessonTime = null;
    }
    try {
      philippinesTime = snapshot['philippinesTime'];
    } catch (e) {
      philippinesTime = null;
    }
    try {
      lessonStartDate = snapshot['lessonStartDate'];
    } catch (e) {
      lessonStartDate = null;
    }
    try {
      paymentAmount = snapshot['paymentAmount'];
    } catch (e) {
      paymentAmount = null;
    }
    try {
      lessonEndDate = snapshot['lessonEndDate'];
    } catch (e) {
      lessonEndDate = null;
    }
    try {
      modifiedLessonEndDate = snapshot['modifiedLessonEndDate'];
    } catch (e) {
      modifiedLessonEndDate = null;
    }
    try {
      extensionRequestMessage = snapshot['extensionRequestMessage'];
    } catch (e) {
      extensionRequestMessage = null;
    }
    try {
      referralSource = snapshot['referralSource'];
    } catch (e) {
      referralSource = null;
    }
    try {
      points = snapshot['points'];
    } catch (e) {
      points = null;
    }
  }

  Student.fromRow(List<Object?> row) {
    int index = 0;
    uid = row[index] as String;
    index++;
    id = int.tryParse(row[index] as String) ?? 0;
    index++;
    name = row[index] as String;
    index++;
    gender = row[index] as String?;
    index++;
    birthDate = row[index] as String?;
    index++;
    phoneNumber = row[index] as String?;
    index++;
    email = row[index] as String;
    index++;
    country = row[index] as String?;
    index++;
    program = row[index] as String?;
    index++;
    studyPurpose = row[index] as String?;
    index++;
    tutor = row[index] as String?;
    index++;
    skypeId = row[index] as String?;
    index++;
    topic = row[index] as String?;
    index++;
    cancelRequestDates = (row[index] as String?)!.isNotEmpty
        ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
        : [];
    index++;
    cancelDates = (row[index] as String?)!.isNotEmpty
        ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
        : [];
    index++;
    tutorCancelDates = (row[index] as String?)!.isNotEmpty
        ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
        : [];
    index++;
    cancelCountLeft = int.tryParse(row[index] as String) ?? 0;
    index++;
    cancelCountTotal = int.tryParse(row[index] as String) ?? 0;
    index++;
    holdRequestDates = (row[index] as String?)!.isNotEmpty
        ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
        : [];
    index++;
    holdDates = (row[index] as String?)!.isNotEmpty
        ? (row[index] as String?)?.split(',').map((e) => e.trim()).toList()
        : [];
    index++;
    holdCountLeft = int.tryParse(row[index] as String) ?? 0;
    index++;
    holdCountTotal = int.tryParse(row[index] as String) ?? 0;
    index++;
    lessonDay = row[index] as String;
    index++;
    lessonTime = row[index] as String;
    index++;
    philippinesTime = row[index] as String?;
    index++;
    lessonStartDate = row[index] as String;
    index++;
    paymentAmount = row[index] as String?;
    index++;
    lessonEndDate = row[index] as String;
    index++;
    modifiedLessonEndDate = row[index] as String;
    index++;
    extensionRequestMessage = row[index] as String;
    index++;
    referralSource = row[index] as String;
    index++;
  }

  List<Object?> toRow() {
    return [
      uid,
      id,
      name,
      gender,
      birthDate,
      phoneNumber,
      email,
      country,
      program,
      studyPurpose,
      tutor,
      skypeId,
      topic,
      cancelRequestDates!
          .join(','), // Join cancelDate list into a single string
      cancelDates!.join(','), // Join cancelDate list into a single string
      tutorCancelDates!.join(','), // Join cancelDate list into a single string
      cancelCountLeft,
      cancelCountTotal,
      holdRequestDates!.join(','), // Join holdDate list into a single string
      holdDates!.join(','), // Join holdDate list into a single string
      holdCountLeft,
      holdCountTotal,
      lessonDay,
      lessonTime,
      philippinesTime,
      lessonStartDate,
      paymentAmount,
      lessonEndDate,
      modifiedLessonEndDate,
      extensionRequestMessage,
      referralSource,
    ];
  }
}
