import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:strawberryenglish/models/student.dart';
import 'package:strawberryenglish/providers/student_provider.dart';
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
  // Map<String, Map<String, dynamic>> userData = {};
  Map<String, Student> userData = {};
  // Map<String, Map<String, dynamic>> searchedData = {};
  Map<String, Student> searchedData = {};
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
      for (var doc in snapshot.docs) {
        userData[doc.id] = await getStudentFromFirestore(doc.id);
      }
      // userData = {
      //   for (var doc in snapshot.docs) doc.id: doc.data(),
      // };
      // 초기화
      filters = {};
      listNames = {};
      intNames = {};
      // searchedData = data;
      for (var e in userData.entries) {
        var lectures = e.value;
        var k = e.key;
        var flag = '';
        // customData 초기화
        customData[k] = {};
        customData[k]!['isFunctionTabOpened'] = true;
        customData[k]!['functionTabMessage'] = '';
        customData[k]!['isDBEditTabOpened'] = false;
        customData[k]!['status'] = '';

        for (var lecture in (lectures.lectures ?? {}).values) {
          // 수업 취소 요청
          flag = 'cancel';
          var v = lecture.data;
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
          if (v.containsKey('lessonEndDate') && ((v['tutor'] ?? '').isEmpty)) {
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
          if (v.containsKey('trialDay') && (v['trialTutor'] ?? '').isEmpty) {
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

          // if ((v['tutor'] ?? '').isNotEmpty) {
          //   if (v.containsKey('lessonEndDate') &&
          //       DateTime.parse(v['lessonEndDate']).isAfter(DateTime.now())) {
          //     bool inHold = false;
          //     for (String range in v['holdDates']) {
          //       List<String> dateParts =
          //           range.split('~').map((e) => e.trim()).toList();
          //       if (dateParts.length == 2) {
          //         DateTime startDate = DateTime.parse(dateParts[0]);
          //         DateTime endDate = DateTime.parse(dateParts[1])
          //             .add(const Duration(days: 1))
          //             .subtract(const Duration(microseconds: 1));

          //         var now = DateTime.now();
          //         if (startDate.isBefore(endDate) &&
          //             (startDate.isBefore(now) && endDate.isAfter(now))) {
          //           inHold = true;
          //           break;
          //         }
          //       }
          //     }
          //     if (inHold) {
          //       customData[k]!['status'] = '🟡 장기홀드';
          //     } else {
          //       customData[k]!['status'] = '🟢 정상수강';
          //     }
          //   } else {
          //     customData[k]!['status'] = '🔴 수업종료';
          //   }
          // } else if (v.containsKey('lessonEndDate')) {
          //   customData[k]!['status'] = '🟠 수강대기';
          // } else if ((v['trialTutor'] ?? '').isNotEmpty) {
          //   var trialDate = DateTime.tryParse(v['trialDate']);
          //   if (trialDate != null && trialDate.isBefore(DateTime.now())) {
          //     customData[k]!['status'] = '🔴 체험종료';
          //   } else {
          //     customData[k]!['status'] = '🟢 무료체험';
          //   }
          // } else if ((v['trialDay'] ?? '').isNotEmpty) {
          //   customData[k]!['status'] = '🟠 체험대기';
          // } else {
          //   customData[k]!['status'] = '⚫ 유령회원';
          // }
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
                      var doc = d[id]!.data;
                      // Map.fromEntries(d[id]!.entries.toList()
                      //   ..sort((e1, e2) => e1.key.compareTo(e2.key)));
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
                              height: 900,
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
                                    // height: 800,
                                    color: Colors.grey[100],
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            width: 20,
                                            height: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10),
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
                                            // 기본 정보
                                            inputCondition['name'] = true;
                                            inputCondition['points'] = true;

                                            // 수강신청
                                            bool isEnroll =
                                                (customData[id]!['enroll'] ??
                                                        0) >
                                                    0;
                                            inputCondition['tutor'] = isEnroll;
                                            inputCondition['lessonTime'] =
                                                isEnroll;
                                            inputCondition['lessonStartDate'] =
                                                isEnroll;
                                            inputCondition['lessonEndDate'] =
                                                isEnroll;
                                            inputCondition['paymentAmount'] =
                                                isEnroll;

                                            // 체험신청
                                            bool isTrial =
                                                (customData[id]!['trial'] ??
                                                        0) >
                                                    0;
                                            inputCondition['trialTutor'] =
                                                isTrial;
                                            inputCondition['trialDate'] =
                                                isTrial;
                                            inputCondition['trialTime'] =
                                                isTrial;

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
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      // 수강신청
                                                      if ((customData[id]![
                                                                  'enroll'] ??
                                                              0) >
                                                          0)
                                                        ElevatedButton(
                                                          onPressed: (() {
                                                            Clipboard.setData(
                                                              ClipboardData(
                                                                  text: """
*TRIAL CLASS DETAILS*
"*Student's Name: ${doc['name']}
*Age: ${userAge(doc['birthDate'].replaceAll('.', '-'))}
*Skype ID: ${doc['skypeId'] ?? '-'}
*Times (KST): ${doc['lessonTime'] ?? '-'}
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
                                                          child:
                                                              Text('신청 정보 복사'),
                                                        ),
                                                      // 체험신청
                                                      if ((customData[id]![
                                                                  'trial'] ??
                                                              0) >
                                                          0)
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
                                                          child:
                                                              Text('신청 정보 복사'),
                                                        ),
                                                      ...[
                                                        for (var ic
                                                            in inputCondition
                                                                .entries)
                                                          if (ic.value)
                                                            Builder(builder:
                                                                (context) {
                                                              var e = MapEntry(
                                                                  ic.key,
                                                                  doc[ic.key]);
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            5),
                                                                child:
                                                                    TextFormField(
                                                                  decoration:
                                                                      InputDecoration(
                                                                    label: Text(
                                                                        e.key),
                                                                  ),
                                                                  controller:
                                                                      controllers[
                                                                          '${id}_${e.key}'],
                                                                  // initialValue:
                                                                  //     '${e.value.runtimeType == List ? e.value.join(', ') : e.value}',
                                                                  onEditingComplete:
                                                                      () {
                                                                    var inputText =
                                                                        controllers['${id}_${e.key}']!
                                                                            .text;
                                                                    dynamic
                                                                        updateText;
                                                                    if (listNames
                                                                        .contains(e
                                                                            .key)) {
                                                                      updateText =
                                                                          inputText
                                                                              .split(',');
                                                                      if (updateText[
                                                                              0]
                                                                          .isEmpty) {
                                                                        updateText
                                                                            .length = 0;
                                                                      }
                                                                    } else if (intNames
                                                                        .contains(
                                                                            e.key)) {
                                                                      updateText =
                                                                          int.tryParse(inputText) ??
                                                                              0;
                                                                    } else {
                                                                      updateText =
                                                                          inputText;
                                                                    }
                                                                    d[id]!.data[
                                                                            e.key] =
                                                                        updateText;
                                                                    inputText
                                                                        .split(
                                                                            ',')
                                                                        .length = 0;
                                                                    updateStudentToFirestoreAsAdmin(d[
                                                                            id]!)
                                                                        .then(
                                                                            (context) {
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              milliseconds: 200),
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          getData();
                                                                        });
                                                                      });
                                                                    });
                                                                  },
                                                                ),
                                                              );
                                                            })
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
                                          user: d[id]!,
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
                                                            d[id]!.data[e.key] =
                                                                updateText;
                                                            inputText
                                                                .split(',')
                                                                .length = 0;
                                                            updateStudentToFirestoreAsAdmin(
                                                                    d[id]!)
                                                                .then(
                                                                    (context) {
                                                              Future.delayed(
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                                  () {
                                                                setState(() {
                                                                  getData();
                                                                });
                                                              });
                                                            });
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
                                          child: Container(
                                            width: 20,
                                            height: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10),
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
                ],
        ),
      ),
    );
  }

  filterData(_) {
    searchedData.clear();
    Map<String, Student> temp = Map.from(userData);
    if (controller.text.isNotEmpty) {
      var removes = <String>{};
      temp.forEach((k, v) {
        bool hasValue = false;
        for (var v2 in v.lectures!.values) {
          if ((v2.data['tutor'] ?? '')
              .toLowerCase()
              .contains(controller.text.toLowerCase())) hasValue = true;
        }
        if (!(k.contains(controller.text) ||
            v.data['name'].contains(controller.text) ||
            (((v.data['trialTutor'] ?? '').toLowerCase())
                .contains(controller.text.toLowerCase())) ||
            hasValue == true)) {
          removes.add(k);
        }
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
      // currentUser = FirebaseAuth.instance.currentUser;
      // if (currentUser != null) {
      // Google Sheets에서 기존 사용자 데이터 가져오기
      FirebaseFirestore.instance
          .collection('users')
          // .doc(currentUser!.email)
          .doc(updatedStudent.data['email'])
          .set(updatedStudent.data);
      for (var e in (updatedStudent.lectures ?? {}).entries) {
        FirebaseFirestore.instance
            .collection('users')
            // .doc(currentUser!.email)
            .doc(updatedStudent.data['email'])
            .collection('lectures')
            .doc(e.key)
            .set(e.value.data);
      }
      // }
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

  Future<Student> getStudentFromFirestore(String email) async {
    try {
      var values =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      // print(response.values);
      Map<String, Lecture>? lectures = {};
      FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('lectures')
          .get()
          .then((value) {
        for (var i in value.docs) {
          lectures[i.id] = Lecture(data: i.data());
        }
      });
      // return Student.transform(data: values.data()!, lectureName: 'lecture2');
      return Student(data: values.data()!, lectures: lectures);
    } catch (e) {
      if (kDebugMode) {
        print('Firestore에서 Student 가져오는 중 오류 발생: $e');
      }
    }
    throw Exception('Student를 찾을 수 없습니다.');
  }
}
