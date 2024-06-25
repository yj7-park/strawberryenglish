import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class AdminStudentsScreen1Listview extends StatefulWidget {
  const AdminStudentsScreen1Listview({
    super.key,
  });

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

  bool cancelFiltered = false;
  bool holdFiltered = false;

  var cancelRequestsCount = 0;
  var holdRequestsCount = 0;

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("users");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        userData = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
      });
    });
    // searchedData = data;
    for (var e in userData.entries) {
      var d = e.value;
      // 수업 취소 요청
      if (d.containsKey('cancelRequestDates') &&
          d['cancelRequestDates'].isNotEmpty) {
        cancelRequestsCount++;
      }

      // 장기 홀드 요청
      if (d.containsKey('holdRequestDates') &&
          d['holdRequestDates'].isNotEmpty) {
        holdRequestsCount++;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool noFilter =
        controller.text.isNotEmpty || cancelFiltered || holdFiltered;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 400,
              height: 50,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var (t, c, n, f, v) in [
                    (
                      '취소 요청',
                      Colors.redAccent,
                      cancelRequestsCount,
                      (v) {
                        cancelFiltered = v;
                        filterData(v);
                      },
                      cancelFiltered,
                    ),
                    (
                      '홀드 요청',
                      Colors.orangeAccent,
                      holdRequestsCount,
                      (v) {
                        holdFiltered = v;
                        filterData(v);
                      },
                      holdFiltered,
                    ),
                  ])
                    // InkWell(
                    //   child:
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(left: 10),
                        color: n > 0 ? c : Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CheckboxListTile(
                            value: v,
                            onChanged: f,
                            enabled: n > 0,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(
                              '$t $n',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  //   onTap: f,
                  // ),
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
                var date = doc.containsKey('lessonEndDate')
                    ? '${doc['lessonStartDate']} ~ ${doc['lessonEndDate']}'
                        .replaceAll('.', '-')
                    : '';
                var cancelRequest = 0;
                var holdRequest = 0;

                // 회원 상태
                var status = '';
                if (doc.containsKey('tutor')) {
                  if (doc.containsKey('lessonEndDate') &&
                      DateTime.parse(doc['lessonEndDate'])
                          .isAfter(DateTime.now())) {
                    status = '🟢 정상수강 중';
                    cancelRequest = (doc['cancelRequestDates'] ?? []).length;
                    holdRequest = (doc['holdRequestDates'] ?? []).length;
                  } else {
                    status = '🔴 수업종료';
                  }
                } else if (doc.containsKey('lessonEndDate')) {
                  status = '🟡 수강신청 대기';
                } else if (doc.containsKey('trialTutor')) {
                  status = '🟢 무료체험 중';
                } else if (doc.containsKey('trialDay')) {
                  status = '🟡 체험신청 대기';
                } else {
                  status = '⚫ 유령회원';
                }
                return Card(
                  elevation: 0.0,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    // tileColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              status,
                              style: TextStyle(
                                color: customTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...[
                              for (var (t, c, n) in [
                                ('취소 요청', Colors.redAccent, cancelRequest),
                                ('홀드 요청', Colors.orangeAccent, holdRequest),
                              ])
                                if (n > 0)
                                  Card(
                                    margin: const EdgeInsets.only(left: 10),
                                    color: c,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        '$t $n',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ],
                        ),
                        Text(
                          '${doc['name']} ($id)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (date.isNotEmpty)
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Column(
                          children: [
                            ...doc.entries.map((e) {
                              controllers['${id}_${e.key}'] = TextEditingController(
                                  text:
                                      '${e.value.runtimeType == List ? e.value.join(', ') : e.value}');
                              return TextFormField(
                                decoration: InputDecoration(
                                  label: Text(e.key),
                                ),
                                controller: controllers['${id}_${e.key}'],
                                // initialValue:
                                //     '${e.value.runtimeType == List ? e.value.join(', ') : e.value}',
                                onEditingComplete: () {
                                  userData[id]![e.key] =
                                      controllers['${id}_${e.key}']!.text;
                                  print(controllers['${id}_${e.key}']!.text);
                                  setState(() {});
                                },
                              );
                            }),
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

  filterData(_) async {
    searchedData.clear();
    Map<String, Map<String, dynamic>> temp = Map.from(userData);
    if (controller.text.isNotEmpty) {
      var removes = [];
      temp.forEach((k, v) {
        if (!k.contains(controller.text) &&
            !v['name'].contains(controller.text)) removes.add(k);
      });
      for (var e in removes) {
        temp.remove(e);
      }
    }
    if (cancelFiltered) {
      var removes = [];
      temp.forEach((k, v) {
        if ((v['cancelRequestDates'] ?? []).length == 0) removes.add(k);
      });
      for (var e in removes) {
        temp.remove(e);
      }
    }
    if (holdFiltered) {
      var removes = [];
      temp.forEach((k, v) {
        if ((v['holdRequestDates'] ?? []).length == 0) removes.add(k);
      });
      for (var e in removes) {
        temp.remove(e);
      }
    }
    searchedData = temp;

    setState(() {});
  }
}
