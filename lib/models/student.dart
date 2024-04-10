class Student {
  late String uid;
  late int id;
  late String name;
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
  late int cancelCountLeft;
  late int cancelCountTotal;
  List<String>? holdRequestDates;
  List<String>? holdDates;
  late int holdCountLeft;
  late int holdCountTotal;
  late String lessonDay;
  late String lessonTime;
  String? philippinesTime;
  late String lessonStartDate;
  String? paymentAmount;
  late String lessonEndDate;
  late String modifiedLessonEndDate;
  // String? extensionRequestMessage;
  // String referralSource;
  // String level;
  // String features;
  // String feedback;
  // String reenrollment;
  String log = '';

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
    ];
  }
}
