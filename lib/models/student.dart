class Student {
  Map<String, dynamic> data;

  Student({
    required this.data,
  });

  StudentState getStudentState() {
    if ((data['tutor'] ?? '').isNotEmpty) {
      if ((DateTime.tryParse(data['modifiedLessonEndDate'] ?? '') ??
              DateTime.tryParse(data['lessonEndDate'] ?? '') ??
              DateTime.now())
          .isAfter(DateTime.now())) {
        bool inHold = false;
        for (String range in data['holdDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1])
                .add(const Duration(days: 1))
                .subtract(const Duration(microseconds: 1));

            var now = DateTime.now();
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
    } else if (data.containsKey('lessonEndDate') &&
        (data['tutor'] ?? '').isEmpty) {
      return StudentState.lectureRequested;
    } else if ((data['trialTutor'] ?? '').isNotEmpty &&
        (DateTime.tryParse('${data['trialDate']} ${data['trialTime']}') !=
            null)) {
      var trialDate = DateTime.parse(data['trialDate']);
      if (trialDate.isBefore(DateTime.now())) {
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

  StudentState getStudentTrialState() {
    if ((data['trialTutor'] ?? '').isNotEmpty &&
        (DateTime.tryParse(
                '${data['trialDate'] ?? ''} ${data['trialTime'] ?? ''}') !=
            null)) {
      var trialDate = DateTime.parse(data['trialDate']);
      if (trialDate.isBefore(DateTime.now())) {
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

  StudentState getStudentLectureState() {
    if ((data['tutor'] ?? '').isNotEmpty) {
      if ((DateTime.tryParse(data['modifiedLessonEndDate'] ?? '') ??
              DateTime.tryParse(data['lessonEndDate'] ?? '') ??
              DateTime.now())
          .isAfter(DateTime.now())) {
        bool inHold = false;
        for (String range in data['holdDates']) {
          List<String> dateParts =
              range.split('~').map((e) => e.trim()).toList();
          if (dateParts.length == 2) {
            DateTime startDate = DateTime.parse(dateParts[0]);
            DateTime endDate = DateTime.parse(dateParts[1])
                .add(const Duration(days: 1))
                .subtract(const Duration(microseconds: 1));

            var now = DateTime.now();
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
    } else if (data.containsKey('lessonEndDate') &&
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
