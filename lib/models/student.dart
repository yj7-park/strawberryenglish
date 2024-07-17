class Student {
  Map<String, dynamic> data;
  Map<String, Lecture>? lectures;

  Student({
    required this.data,
    this.lectures,
  }) {
    // lectures!['lecture2'] = lectures!['lecture1']!;
  }

  Student.transform({
    required this.data,
    lectureName,
  }) {
    // Student.fromFirebase(Documentdata<Map<String, dynamic>> data) {

    Map<String, dynamic> newData = {};
    newData['program'] = data['program'];
    newData['tutor'] = data['tutor'];
    newData['skypeId'] = data['skypeId'];
    newData['topic'] = data['topic'];
    newData['cancelRequestDates'] =
        (data['cancelRequestDates'] as List).cast<String>();
    newData['cancelDates'] = (data['cancelDates'] as List).cast<String>();
    newData['tutorCancelDates'] =
        (data['tutorCancelDates'] as List).cast<String>();
    newData['cancelCountLeft'] = data['cancelCountLeft'];
    newData['cancelCountTotal'] = data['cancelCountTotal'];
    newData['holdRequestDates'] =
        (data['holdRequestDates'] as List).cast<String>();
    newData['holdDates'] = (data['holdDates'] as List).cast<String>();
    newData['holdCountLeft'] = data['holdCountLeft'];
    newData['holdCountTotal'] = data['holdCountTotal'];
    newData['lessonDay'] = data['lessonDay'];
    newData['lessonTime'] = data['lessonTime'];
    newData['lessonStartDate'] = data['lessonStartDate'];
    newData['lessonEndDate'] = data['lessonEndDate'];
    newData['modifiedLessonEndDate'] = data['modifiedLessonEndDate'];

    data.remove('program');
    data.remove('tutor');
    data.remove('skypeId');
    data.remove('topic');
    data.remove('cancelRequestDates');
    data.remove('cancelDates');
    data.remove('tutorCancelDates');
    data.remove('cancelCountLeft');
    data.remove('cancelCountTotal');
    data.remove('holdRequestDates');
    data.remove('holdDates');
    data.remove('holdCountLeft');
    data.remove('holdCountTotal');
    data.remove('lessonDay');
    data.remove('lessonTime');
    data.remove('lessonStartDate');
    data.remove('lessonEndDate');
    data.remove('modifiedLessonEndDate');

    lectures = {};
    lectures![lectureName] = Lecture(data: newData);
  }
}

class Lecture {
  Map<String, dynamic> data;

  Lecture({
    required this.data,
  });
}
