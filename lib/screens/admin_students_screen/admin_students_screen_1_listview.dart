import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  bool isValidAccess = false;
  bool _isOpen = false;

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
          userData[k]!['flags'] = {};
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
            if (!userData[k]!['flags'].containsKey(flag)) {
              userData[k]!['flags'][flag] = 0;
            }
            userData[k]!['flags'][flag] = v['cancelRequestDates'].length;
          }

          // 장기 홀드 요청
          flag = 'hold';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (v.containsKey('holdRequestDates') &&
              v['holdRequestDates'].isNotEmpty) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!userData[k]!['flags'].containsKey(flag)) {
              userData[k]!['flags'][flag] = 0;
            }
            userData[k]!['flags'][flag] = v['holdRequestDates'].length;
          }

          // 수강신청
          flag = 'enroll';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (v.containsKey('lessonEndDate') &&
              (!v.containsKey('tutor') || (v['tutor'] ?? '').isEmpty)) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!userData[k]!['flags'].containsKey(flag)) {
              userData[k]!['flags'][flag] = 0;
            }
            userData[k]!['flags'][flag]++;
          }

          // 체험신청
          flag = 'trial';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (v.containsKey('trialDay') &&
              (!v.containsKey('trialTutor') ||
                  (v['trialTutor'] ?? '').isEmpty)) {
            // holdRequestsCount++;
            filters[flag] = (false, filters[flag]!.$2 + 1);
            if (!userData[k]!['flags'].containsKey(flag)) {
              userData[k]!['flags'][flag] = 0;
            }
            userData[k]!['flags'][flag]++;
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
                if (!userData[k]!['flags'].containsKey(flag)) {
                  userData[k]!['flags'][flag] = 0;
                }
                userData[k]!['flags'][flag]++;
              } else if (date
                  .subtract(const Duration(days: 3))
                  .isBefore(DateTime.now())) {
                flag = 'd-3';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!userData[k]!['flags'].containsKey(flag)) {
                  userData[k]!['flags'][flag] = 0;
                }
                userData[k]!['flags'][flag]++;
              } else if (date
                  .subtract(const Duration(days: 7))
                  .isBefore(DateTime.now())) {
                flag = 'd-7';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!userData[k]!['flags'].containsKey(flag)) {
                  userData[k]!['flags'][flag] = 0;
                }
                userData[k]!['flags'][flag]++;
              } else if (date
                  .subtract(const Duration(days: 15))
                  .isBefore(DateTime.now())) {
                flag = 'd-15';
                if (!filters.containsKey(flag)) filters[flag] = (false, 0);
                filters[flag] = (false, filters[flag]!.$2 + 1);
                if (!userData[k]!['flags'].containsKey(flag)) {
                  userData[k]!['flags'][flag] = 0;
                }
                userData[k]!['flags'][flag]++;
              }
            }
          }
        }
      });
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
                      var status = '';
                      if (doc.containsKey('tutor')) {
                        if (doc.containsKey('lessonEndDate') &&
                            DateTime.parse(doc['lessonEndDate'])
                                .isAfter(DateTime.now())) {
                          bool inHold = false;
                          for (String range in doc['holdDates']) {
                            List<String> dateParts =
                                range.split('~').map((e) => e.trim()).toList();
                            if (dateParts.length == 2) {
                              DateTime startDate = DateTime.parse(dateParts[0]);
                              DateTime endDate = DateTime.parse(dateParts[1])
                                  .add(const Duration(days: 1))
                                  .subtract(const Duration(microseconds: 1));

                              var now = DateTime.now();
                              if (startDate.isBefore(endDate) &&
                                  (startDate.isBefore(now) &&
                                      endDate.isAfter(now))) {
                                inHold = true;
                                break;
                              }
                            }
                          }
                          if (inHold) {
                            status = '🟡 장기홀드';
                          } else {
                            status = '🟢 정상수강';
                          }
                        } else {
                          status = '🔴 수업종료';
                        }
                      } else if (doc.containsKey('lessonEndDate')) {
                        status = '🟠 수강대기';
                      } else if (doc.containsKey('trialTutor')) {
                        var trialDate = DateTime.tryParse(doc['trialDate']);
                        if (trialDate != null &&
                            trialDate.isBefore(DateTime.now())) {
                          status = '🔴 체험종료';
                        } else {
                          status = '🟢 무료체험';
                        }
                      } else if (doc.containsKey('trialDay')) {
                        status = '🟠 체험대기';
                      } else {
                        status = '⚫ 유령회원';
                      }
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          // tileColor: Colors.white,
                          // title: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Text(
                          //           status,
                          //           style: TextStyle(
                          //             color: customTheme.colorScheme.secondary,
                          //             fontSize: 16,
                          //             fontWeight: FontWeight.bold,
                          //           ),
                          //         ),
                          //         ...[
                          //           for (var (t, c, f) in [
                          //             ...AdminStudentsScreen1Listview
                          //                 .filterRequests,
                          //             ...AdminStudentsScreen1Listview.filterDday
                          //           ])
                          //             if ((doc['flags']![f] ?? 0) > 0)
                          //               Card(
                          //                 margin:
                          //                     const EdgeInsets.only(left: 10),
                          //                 color: c,
                          //                 child: Padding(
                          //                   padding: const EdgeInsets.symmetric(
                          //                       horizontal: 10),
                          //                   child: Text(
                          //                     // cancel과 hold만 갯수 출력
                          //                     '$t${[
                          //                       'cancel',
                          //                       'hold'
                          //                     ].contains(f) ? doc['flags']![f] : ''}',
                          //                     style: const TextStyle(
                          //                       color: Colors.white,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //         ],
                          //       ],
                          //     ),
                          //     Text(
                          //       '${doc['name']} ($id)',
                          //       style: const TextStyle(
                          //         fontSize: 18,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     Row(
                          //       children: [
                          //         const SizedBox(width: 10),
                          //         if ((doc['tutor'] ?? '').isNotEmpty) ...[
                          //           const Text(
                          //             'TUTOR  ',
                          //             style: TextStyle(
                          //               fontSize: 10,
                          //             ),
                          //           ),
                          //           Text(
                          //             '${doc['tutor'] ?? ''}',
                          //             // style: const TextStyle(
                          //             //   fontWeight: FontWeight.bold,
                          //             // ),
                          //           ),
                          //           const SizedBox(width: 30),
                          //         ],
                          //         if ((doc['trialTutor'] ?? '').isNotEmpty) ...[
                          //           const Text(
                          //             'TRIAL  ',
                          //             style: TextStyle(
                          //               fontSize: 10,
                          //             ),
                          //           ),
                          //           Text(
                          //             '${doc['trialTutor'] ?? ''}',
                          //             // style: const TextStyle(
                          //             //   fontWeight: FontWeight.bold,
                          //             // ),
                          //           ),
                          //         ],
                          //       ],
                          //     ),
                          //     if (date.isNotEmpty)
                          //       Text(
                          //         date,
                          //         style: const TextStyle(
                          //           color: Colors.grey,
                          //         ),
                          //       ),
                          //   ],
                          // ),
                          title: Builder(
                            builder: (contexxt) {
                              var children = [
                                Text(
                                  status,
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
                                        if ((doc['flags']![f] ?? 0) > 0)
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
                                                ].contains(f) ? doc['flags']![f] : ''}',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // DB 직접 수정 widget

                                Container(
                                  // duration: const Duration(milliseconds: 2000),
                                  // duration: const Duration(milliseconds: 200),
                                  // width: 300,
                                  height: 800,
                                  color: Colors.grey[100],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                                '▲ Edit Database',
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
                                            _isOpen = !_isOpen;
                                          });
                                        },
                                      ),
                                      if (_isOpen)
                                        SizedBox(
                                          // duration:
                                          //     const Duration(milliseconds: 500),
                                          width: 200,
                                          child: SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
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
                                                            text: initialText);
                                                    return Padding(
                                                      padding: const EdgeInsets
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
                                                        onEditingComplete: () {
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
                                                                    .split(',');
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
                                                          userData[id]![e.key] =
                                                              updateText;
                                                          inputText
                                                              .split(',')
                                                              .length = 0;
                                                          updateStudentToFirestoreAsAdmin(
                                                                  Student(
                                                                      data: userData[
                                                                          id]!))
                                                              .then((context) {
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
                                    ],
                                  ),
                                ),
                                // 마이페이지
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    child: CalendarBody(
                                        user: Student(data: doc),
                                        isAdmin: true,
                                        updated: (_) {
                                          Future.delayed(
                                              const Duration(milliseconds: 200),
                                              () {
                                            setState(() {
                                              getData();
                                            });
                                          });
                                        }),
                                  ),
                                ),
                              ],
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
          if (!v['flags'].keys.contains(flag)) {
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
          .set(updatedStudent.data);
    } catch (e) {
      if (kDebugMode) {
        print('Student 데이터 업데이트 중 오류 발생: $e');
      }
    }
  }
}
