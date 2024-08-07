import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/screens/calendar_body.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class AdminStudentsScreen1Listview extends StatefulWidget {
  const AdminStudentsScreen1Listview({
    super.key,
  });

  static const filterRequests = [
    // button color
    // count
    // onChange callback
    // on/off flag
    ('취소요청', Colors.redAccent, 'cancel'),
    ('홀드요청', Colors.orangeAccent, 'hold'),
    ('수강신청', Colors.blueAccent, 'enroll'),
    ('체험신청', Colors.green, 'trial'),
  ];
  static const filterDday = [
    // button color
    // count
    // onChange callback
    // on/off flag
    ('D-1', Colors.blueGrey, 'd-1'),
    ('D-3', Colors.blueGrey, 'd-3'),
    ('D-7', Colors.blueGrey, 'd-7'),
    ('D-15', Colors.blueGrey, 'd-15'),
  ];

  @override
  State<AdminStudentsScreen1Listview> createState() =>
      _AdminStudentsScreen1ListviewState();
}

class _AdminStudentsScreen1ListviewState
    extends State<AdminStudentsScreen1Listview> {
  Map<String, Map<String, dynamic>> userData = {};
  Map<String, Map<String, dynamic>> searchedData = {};
  TextEditingController controller = TextEditingController();
  Map<String, TextEditingController> controllers = {};

  Map<String, (dynamic, int)> filters = {};

  Set<String> listNames = {};
  Set<String> intNames = {};

  Map<String, Map<String, dynamic>> customData = {};
  bool isValidAccess = false;

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("users");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        userData = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
        // 초기화
        filters = {};
        listNames = {};
        intNames = {};
        // searchedData = data;
        for (var e in userData.entries) {
          var v = e.value;
          var k = e.key;
          var flag = '';
          // customData 초기화
          customData[k] = {};
          customData[k]!['isFunctionTabOpened'] = true;
          customData[k]!['functionTabMessage'] = '';
          customData[k]!['isDBEditTabOpened'] = false;
          customData[k]!['status'] = '';

          // 수업 취소 요청
          flag = 'cancel';
          for (var e2 in v.entries) {
            if (e2.value.runtimeType == List) listNames.add(e2.key);
            if (e2.value.runtimeType == int) intNames.add(e2.key);
          }
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (v.containsKey('cancelRequestDates') &&
              v['cancelRequestDates'].isNotEmpty) {
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!customData[k]!.containsKey(flag)) {
              customData[k]![flag] = 0;
            }
            customData[k]![flag] = v['cancelRequestDates'].length;
          }

          // 장기 홀드 요청
          flag = 'hold';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (v.containsKey('holdRequestDates') &&
              v['holdRequestDates'].isNotEmpty) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!customData[k]!.containsKey(flag)) {
              customData[k]![flag] = 0;
            }
            customData[k]![flag] = v['holdRequestDates'].length;
          }

          // 수강신청
          flag = 'enroll';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (Student(data: v).getStudentState() ==
              StudentState.lectureRequested) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!customData[k]!.containsKey(flag)) {
              customData[k]![flag] = 0;
            }
            customData[k]![flag]++;
          }

          // 체험신청
          flag = 'trial';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (Student(data: v).getStudentState() ==
              StudentState.trialRequested) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!customData[k]!.containsKey(flag)) {
              customData[k]![flag] = 0;
            }
            customData[k]![flag]++;
          }

          // 수업 종료 기준 (D-n)
          if (v.containsKey('lessonEndDate')) {
            var date = DateTime.tryParse(v['lessonEndDate']);
            if (date != null && date.isAfter(DateTime.now())) {
              if (date
                  .subtract(const Duration(days: 1))
                  .isBefore(DateTime.now())) {
                flag = 'd-1';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!customData[k]!.containsKey(flag)) {
                  customData[k]![flag] = 0;
                }
                customData[k]![flag]++;
              } else if (date
                  .subtract(const Duration(days: 3))
                  .isBefore(DateTime.now())) {
                flag = 'd-3';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!customData[k]!.containsKey(flag)) {
                  customData[k]![flag] = 0;
                }
                customData[k]![flag]++;
              } else if (date
                  .subtract(const Duration(days: 7))
                  .isBefore(DateTime.now())) {
                flag = 'd-7';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!customData[k]!.containsKey(flag)) {
                  customData[k]![flag] = 0;
                }
                customData[k]![flag]++;
              } else if (date
                  .subtract(const Duration(days: 15))
                  .isBefore(DateTime.now())) {
                flag = 'd-15';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!customData[k]!.containsKey(flag)) {
                  customData[k]![flag] = 0;
                }
                customData[k]![flag]++;
              }
            }
          }

          switch (Student(data: v).getStudentState()) {
            case StudentState.registeredOnly:
              customData[k]!['status'] = '⚪ 유령회원';
              break;
            case StudentState.trialRequested:
              customData[k]!['status'] = '🟠 체험대기';
              break;
            case StudentState.trialConfirmed:
              customData[k]!['status'] = '🟢 무료체험';
              break;
            case StudentState.trialFinished:
              customData[k]!['status'] = '🔴 체험종료';
              break;
            case StudentState.lectureRequested:
              customData[k]!['status'] = '🟠 수강대기';
              break;
            case StudentState.lectureOnGoing:
              customData[k]!['status'] = '🟢 정상수강';
              break;
            case StudentState.lectureOnHold:
              customData[k]!['status'] = '⚫ 장기홀드';
              break;
            case StudentState.lectureFinished:
              customData[k]!['status'] = '🔴 수업종료';
              break;
            default:
              customData[k]!['status'] = '❌ 정보오류';
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // TODO: for test
    // isValidAccess = (FirebaseAuth.instance.currentUser != null &&
    //     FirebaseAuth.instance.currentUser!.email == 'admin@admin.com');
    isValidAccess = true;
    if (isValidAccess) {
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 1000;
    bool noFilter = controller.text.isNotEmpty ||
        [for (var e in filters.values) e.$1].contains(true);
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          children: !isValidAccess
              ? [const Text('잘못된 접근입니다.')]
              : [
                  SizedBox(
                    // width: 400,
                    // height: 50,
                    child: Column(
                      children: [
                        for (var filterList in [
                          AdminStudentsScreen1Listview.filterRequests,
                          AdminStudentsScreen1Listview.filterDday,
                        ])
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (var (t, c, f) in filterList)
                                Builder(
                                  builder: (context) {
                                    var count = filters.containsKey(f)
                                        ? filters[f]!.$2
                                        : 0;
                                    var toggle = filters.containsKey(f)
                                        ? filters[f]!.$1
                                        : false;
                                    return Expanded(
                                      child: Card(
                                        margin: const EdgeInsets.all(3),
                                        color: count > 0 ? c : Colors.grey,
                                        child: CheckboxListTile(
                                          value: toggle,
                                          onChanged: (v) {
                                            filters[f] = (v, count);
                                            filterData(v);
                                          },
                                          enabled: count > 0,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: Text(
                                            '$t ($count)',
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.search),
                      title: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                        ),
                        // enabled: !cancelFiltered && !holdFiltered,
                        onChanged: filterData,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '${noFilter ? searchedData.length : userData.length}/${userData.length}'),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              controller.clear();
                              filterData('');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(height: 0),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (_, __) =>
                        Container(height: 1.5, color: Colors.grey[300]),
                    itemCount: noFilter ? searchedData.length : userData.length,
                    itemBuilder: (context, index) {
                      // 검색
                      var d = noFilter ? searchedData : userData;
                      // 이메일 주소
                      var id = d.keys.elementAt(index);
                      // 데이터 정렬
                      var doc = Map.fromEntries(d[id]!.entries.toList()
                        ..sort((e1, e2) => e1.key.compareTo(e2.key)));
                      // 날짜 표시 (수업 날짜)
                      // var date = doc.containsKey('lessonEndDate')
                      //     ? '${doc['lessonStartDate']} ~ ${doc['lessonEndDate']}'
                      //         .replaceAll('.', '-')
                      //     : '';
                      // var cancelRequest = 0;
                      // var holdRequest = 0;

                      // 회원 상태
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          title: Builder(
                            builder: (contexxt) {
                              var children = [
                                Text(
                                  customData[id]!['status'],
                                  style: TextStyle(
                                    color: customTheme.colorScheme.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                Text(
                                  '${doc['name']} ($id)',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ...[
                                      for (var (t, c, f) in [
                                        ...AdminStudentsScreen1Listview
                                            .filterRequests,
                                        ...AdminStudentsScreen1Listview
                                            .filterDday
                                      ])
                                        if ((customData[id]![f] ?? 0) > 0)
                                          Card(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            color: c,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Text(
                                                // cancel과 hold만 갯수 출력
                                                '$t${[
                                                  'cancel',
                                                  'hold'
                                                ].contains(f) ? customData[id]![f] : ''}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                    ],
                                  ],
                                ),
                              ];
                              return isMobile
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: children,
                                    )
                                  : Row(children: children);
                            },
                          ),
                          trailing: Builder(
                            builder: (context) {
                              var tutor = doc['tutor'] ?? '';
                              var trial = doc['trialTutor'] ?? '';
                              var children = [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    // if (tutor.isNotEmpty) ...[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '$tutor',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          '  TUTOR',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // ],
                                    // if (trial.isNotEmpty) ...[
                                    const SizedBox(width: 30),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '$trial',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          '  TRIAL',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // ],
                                    // const SizedBox(width: 50),
                                    // Text(
                                    //   DateFormat('yyyy-MM-dd')
                                    //       .format(doc['date'].toDate()),
                                    //   style: const TextStyle(
                                    //     fontSize: 13,
                                    //     color: Colors.grey,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ];
                              return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: children);
                            },
                          ),
                          children: [
                            Container(
                              height: 820,
                              color: Colors.grey[100],
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // DB 직접 수정 widget
                                  Container(
                                    // duration: const Duration(milliseconds: 200),
                                    // width: 300,
                                    height: 800,
                                    color: Colors.grey[100],
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: SizedBox(
                                            width: 20,
                                            height: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: RotatedBox(
                                                quarterTurns: 1,
                                                child: Text(
                                                  '▲ Function Tab',
                                                  style: TextStyle(
                                                    color: customTheme
                                                        .colorScheme.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              customData[id]![
                                                      'isFunctionTabOpened'] =
                                                  !customData[id]![
                                                      'isFunctionTabOpened'];
                                            });
                                          },
                                        ),
                                        if (customData[id]![
                                            'isFunctionTabOpened'])
                                          Builder(builder: (context) {
                                            Map<String, bool> inputCondition =
                                                {};
                                            var student = Student(data: doc);

                                            // 기본 정보
                                            inputCondition['기본 정보'] = false;

                                            inputCondition['name'] = true;
                                            inputCondition['points'] = true;
                                            inputCondition['studyPurpose'] =
                                                true;
                                            inputCondition['level'] = true;

                                            // 수강신청
                                            bool isEnroll =
                                                (customData[id]!['enroll'] ??
                                                        0) >
                                                    0;
                                            if (isEnroll) {
                                              inputCondition['수강신청 정보'] = false;

                                              inputCondition['tutor'] = true;
                                              inputCondition['lessonTime'] =
                                                  true;
                                              inputCondition['lessonMonths'] =
                                                  true;
                                              inputCondition['lessonDays'] =
                                                  true;
                                              inputCondition['lessonPeriod'] =
                                                  true;
                                              inputCondition[
                                                  'lessonStartDate'] = isEnroll;
                                              inputCondition['lessonEndDate'] =
                                                  true;

                                              // 수강신청 - 결제 관련 정보
                                              inputCondition['결제 관련 정보'] =
                                                  false;

                                              inputCondition[
                                                  'cashReceiptNumber'] = true;
                                              inputCondition['billingAmount'] =
                                                  true;
                                              inputCondition[
                                                  'billingDiscount'] = true;
                                              inputCondition['billingFinal'] =
                                                  true;
                                              inputCondition['paymentAmmount'] =
                                                  true;
                                            }

                                            // 체험신청
                                            bool isTrial =
                                                (customData[id]!['trial'] ??
                                                        0) >
                                                    0;
                                            if (isTrial) {
                                              inputCondition['체험신청 정보'] = false;

                                              inputCondition['trialTutor'] =
                                                  true;
                                              inputCondition['trialDate'] =
                                                  true;
                                              inputCondition['trialTime'] =
                                                  true;
                                            }

                                            var lectureState = student
                                                .getStudentLectureState();
                                            // 정상수강 / 장기홀드
                                            bool isLectureOnGoing =
                                                lectureState ==
                                                        StudentState
                                                            .lectureOnGoing ||
                                                    lectureState ==
                                                        StudentState
                                                            .lectureOnHold;
                                            if (isLectureOnGoing) {
                                              inputCondition['수강 정보'] = false;

                                              inputCondition['tutor'] = true;
                                              inputCondition['lessonTime'] =
                                                  true;
                                              inputCondition['lessonMonths'] =
                                                  true;
                                              inputCondition['lessonDays'] =
                                                  true;
                                              inputCondition['lessonPeriod'] =
                                                  true;
                                              inputCondition['program'] = true;
                                              inputCondition['topic'] = true;
                                            }

                                            // 체험 신청 완료
                                            var trialState =
                                                student.getStudentTrialState();
                                            if (trialState ==
                                                StudentState.trialConfirmed) {
                                              inputCondition['체험 수업 정보'] =
                                                  false;

                                              inputCondition['trialTutor'] =
                                                  true;
                                              inputCondition['trialTime'] =
                                                  true;
                                              inputCondition['trialDate'] =
                                                  true;
                                            }

                                            return SizedBox(
                                              // duration:
                                              //     const Duration(milliseconds: 500),
                                              width: 200,
                                              child: SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        customData[id]![
                                                            'functionTabMessage'],
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      // 수강신청
                                                      if (isEnroll) ...[
                                                        ElevatedButton(
                                                          onPressed: (() {
                                                            Clipboard.setData(
                                                              ClipboardData(
                                                                  text: """
*Regular Class*
*Student's Name: ${doc['name']}
*Age: ${userAge(doc['birthDate'].replaceAll('.', '-'))}
*Skype ID: ${doc['skypeId'] ?? '-'}
*Times (KST): ${(doc['lessonTime'] ?? []).join(', ')}
*GOAL: ${doc['studyPurpose'] ?? 'No comment'}
*Starting Date: ${DateFormat('d MMM, E').format(DateTime.tryParse(doc['lessonStartDate'] ?? '') ?? DateTime.now())}
*Program: ${doc['program'] ?? '-'} (${doc['topic'] ?? '-'})
*Student's Level: ${doc['studentLevel'] ?? '-'}
"""),
                                                            );
                                                            setState(() {
                                                              customData[id]![
                                                                      'functionTabMessage'] =
                                                                  'Text copied to Clipboard';
                                                            });
                                                          }),
                                                          child: const Text(
                                                              '수강 정보 복사'),
                                                        ),
                                                        const SizedBox(
                                                            height: 5)
                                                      ],
                                                      // 체험신청
                                                      if (isTrial) ...[
                                                        ElevatedButton(
                                                          onPressed: (() {
                                                            Clipboard.setData(
                                                              ClipboardData(
                                                                  text: """
*TRIAL CLASS DETAILS*
*Student's Name: ${doc['name']}
*Age: ${userAge(doc['birthDate'].replaceAll('.', '-'))}
*Skype ID: ${doc['skypeId'] ?? '-'}
*Date: ${DateFormat('d MMM, E').format(DateTime.tryParse(doc['trialDate'] ?? '') ?? DateTime.now())}
*Time (KST): ${doc['trialTime'] ?? '-'} 
*GOAL: ${doc['studyPurpose'] ?? '-'}
"""),
                                                            );
                                                            setState(() {
                                                              customData[id]![
                                                                      'functionTabMessage'] =
                                                                  'Text copied to Clipboard';
                                                            });
                                                          }),
                                                          child: const Text(
                                                              '체험 정보 복사'),
                                                        ),
                                                        const SizedBox(
                                                            height: 5)
                                                      ],
                                                      ...[
                                                        for (var ic
                                                            in inputCondition
                                                                .entries)
                                                          if (ic.value ==
                                                              false) ...[
                                                            SizedBox(
                                                                height: 50),
                                                            Divider(
                                                              height: 0,
                                                              thickness: 2,
                                                            ),
                                                            Text(ic.key,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 17,
                                                                )),
                                                            Divider(
                                                              height: 0,
                                                              thickness: 2,
                                                            ),
                                                          ] else if (ic.value)
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                var e = MapEntry(
                                                                    ic.key,
                                                                    doc[ic
                                                                        .key]);
                                                                var initialText = e
                                                                            .value
                                                                            .runtimeType ==
                                                                        List
                                                                    ? '${e.value.join(',')}'
                                                                    : '${e.value ?? (intNames.contains(e.key) ? 0 : '')}';
                                                                controllers[
                                                                        '${id}_${e.key}'] =
                                                                    TextEditingController(
                                                                        text:
                                                                            initialText);
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  child:
                                                                      TextFormField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelStyle: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color: initialText.isEmpty
                                                                              ? Colors.red
                                                                              : Colors.black),
                                                                      label: Text(
                                                                          e.key),
                                                                    ),
                                                                    controller:
                                                                        controllers[
                                                                            '${id}_${e.key}'],
                                                                    // initialValue:
                                                                    //     '${e.value.runtimeType == List ? e.value.join(', ') : e.value}',
                                                                    // onEditingComplete:
                                                                    //     () {
                                                                    //   var inputText =
                                                                    //       controllers['${id}_${e.key}']!
                                                                    //           .text;
                                                                    //   dynamic
                                                                    //       updateText;
                                                                    //   if (listNames
                                                                    //       .contains(e
                                                                    //           .key)) {
                                                                    //     updateText =
                                                                    //         inputText
                                                                    //             .split(',');
                                                                    //     if (updateText[
                                                                    //             0]
                                                                    //         .isEmpty) {
                                                                    //       updateText
                                                                    //           .length = 0;
                                                                    //     }
                                                                    //   } else if (intNames
                                                                    //       .contains(
                                                                    //           e.key)) {
                                                                    //     updateText =
                                                                    //         int.tryParse(inputText) ??
                                                                    //             0;
                                                                    //   } else {
                                                                    //     updateText =
                                                                    //         inputText;
                                                                    //   }
                                                                    //   d[id]![e.key] =
                                                                    //       updateText;
                                                                    //   inputText
                                                                    //       .split(
                                                                    //           ',')
                                                                    //       .length = 0;
                                                                    //   updateStudentToFirestoreAsAdmin(
                                                                    //       Student(
                                                                    //           data:
                                                                    //               d[id]!),
                                                                    //               );
                                                                    // },
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                        const SizedBox(
                                                            height: 5),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            for (var ic
                                                                in inputCondition
                                                                    .entries) {
                                                              var e = MapEntry(
                                                                  ic.key,
                                                                  doc[ic.key]);
                                                              if (ic.value) {
                                                                var inputText =
                                                                    controllers[
                                                                            '${id}_${e.key}']!
                                                                        .text;
                                                                dynamic
                                                                    updateText;
                                                                if (listNames
                                                                    .contains(e
                                                                        .key)) {
                                                                  updateText =
                                                                      inputText
                                                                          .split(
                                                                              ',');
                                                                  if (updateText[
                                                                          0]
                                                                      .isEmpty) {
                                                                    updateText
                                                                        .length = 0;
                                                                  }
                                                                } else if (intNames
                                                                    .contains(e
                                                                        .key)) {
                                                                  updateText =
                                                                      int.tryParse(
                                                                              inputText) ??
                                                                          0;
                                                                } else {
                                                                  updateText =
                                                                      inputText;
                                                                }
                                                                d[id]![e.key] =
                                                                    updateText;
                                                              }
                                                            }

                                                            updateStudentToFirestoreAsAdmin(
                                                              Student(
                                                                  data: d[id]!),
                                                            );
                                                          },
                                                          child: const Text(
                                                              '업데이트'),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                      ],
                                    ),
                                  ),
                                  // 마이페이지
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey[100]!,
                                          width: 5,
                                        ),
                                      ),
                                      child: CalendarBody(
                                          user: Student(data: doc),
                                          isAdmin: true,
                                          updated: (_) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              setState(() {
                                                getData();
                                              });
                                            });
                                          }),
                                    ),
                                  ),
                                  // 기능 버튼 창
                                  Container(
                                    height: 800,
                                    color: Colors.grey[100],
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (customData[id]![
                                            'isDBEditTabOpened'])
                                          SizedBox(
                                            // duration:
                                            //     const Duration(milliseconds: 500),
                                            width: 200,
                                            child: SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    // Text(
                                                    //   'Database',
                                                    //   style: TextStyle(
                                                    //     color: customTheme
                                                    //         .colorScheme
                                                    //         .secondary,
                                                    //     fontSize: 16,
                                                    //     fontWeight:
                                                    //         FontWeight.bold,
                                                    //   ),
                                                    // ),
                                                    // Divider(),
                                                    ...doc.entries.map((e) {
                                                      var initialText = e.value
                                                                  .runtimeType ==
                                                              List
                                                          ? '${e.value.join(',')}'
                                                          : '${e.value}';
                                                      controllers[
                                                              '${id}_${e.key}'] =
                                                          TextEditingController(
                                                              text:
                                                                  initialText);
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
                                                        child: TextFormField(
                                                          decoration:
                                                              InputDecoration(
                                                            label: Text(e.key),
                                                          ),
                                                          controller: controllers[
                                                              '${id}_${e.key}'],
                                                          // initialValue:
                                                          //     '${e.value.runtimeType == List ? e.value.join(', ') : e.value}',
                                                          onEditingComplete:
                                                              () {
                                                            var inputText =
                                                                controllers[
                                                                        '${id}_${e.key}']!
                                                                    .text;
                                                            dynamic updateText;
                                                            if (listNames
                                                                .contains(
                                                                    e.key)) {
                                                              updateText =
                                                                  inputText
                                                                      .split(
                                                                          ',');
                                                              if (updateText[0]
                                                                  .isEmpty) {
                                                                updateText
                                                                    .length = 0;
                                                              }
                                                            } else if (intNames
                                                                .contains(
                                                                    e.key)) {
                                                              updateText =
                                                                  int.tryParse(
                                                                          inputText) ??
                                                                      0;
                                                            } else {
                                                              updateText =
                                                                  inputText;
                                                            }
                                                            d[id]![e.key] =
                                                                updateText;
                                                            inputText
                                                                .split(',')
                                                                .length = 0;
                                                            updateStudentToFirestoreAsAdmin(
                                                                Student(
                                                                    data: d[
                                                                        id]!));
                                                          },
                                                        ),
                                                      );
                                                    }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        InkWell(
                                          child: SizedBox(
                                            width: 20,
                                            height: double.infinity,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: RotatedBox(
                                                quarterTurns: 1,
                                                child: Text(
                                                  '▼ Database Edit Tab',
                                                  style: TextStyle(
                                                    color: customTheme
                                                        .colorScheme.secondary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              customData[id]![
                                                      'isDBEditTabOpened'] =
                                                  !customData[id]![
                                                      'isDBEditTabOpened'];
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 0),
                ],
        ),
      ),
    );
  }

  filterData(_) {
    searchedData.clear();
    Map<String, Map<String, dynamic>> temp = Map.from(userData);
    if (controller.text.isNotEmpty) {
      var removes = <String>{};
      temp.forEach((k, v) {
        if (!(k.contains(controller.text) ||
            v['name'].contains(controller.text) ||
            (((v['tutor'] ?? '').toLowerCase())
                .contains(controller.text.toLowerCase())) ||
            (((v['trialTutor'] ?? '').toLowerCase())
                .contains(controller.text.toLowerCase())))) removes.add(k);
      });
      for (var e in removes) {
        temp.remove(e);
      }
    }

    for (var flag in [
              for (var e in AdminStudentsScreen1Listview.filterRequests) e.$3
            ] +
            [for (var e in AdminStudentsScreen1Listview.filterDday) e.$3]
        // ['cancel', 'hold', 'd-1', 'd-3', 'd-7', 'd-15']
        ) {
      if (filters.containsKey(flag) && filters[flag]!.$1) {
        var removes = <String>{};
        temp.forEach((k, v) {
          if (!customData[k]!.keys.contains(flag)) {
            removes.add(k);
          }
        });
        for (var e in removes) {
          temp.remove(e);
        }
      }
    }
    searchedData = temp;

    setState(() {});
  }

  Future<void> updateStudentToFirestoreAsAdmin(Student updatedStudent) async {
    try {
      // Google Sheets에서 기존 사용자 데이터 가져오기
      FirebaseFirestore.instance
          .collection('users')
          .doc(updatedStudent.data['email'])
          .set(updatedStudent.data)
          .then((context) {
        setState(() {
          getData();
        });
      });
    } catch (e) {
      if (kDebugMode) {
        print('Student 데이터 업데이트 중 오류 발생: $e');
      }
    }
  }

  userAge(String usersBirthDate) {
    Duration parse = DateTime.now()
        .difference(DateTime.tryParse(usersBirthDate) ?? DateTime.now())
        .abs();
    return "${parse.inDays ~/ 360}";
  }
}
