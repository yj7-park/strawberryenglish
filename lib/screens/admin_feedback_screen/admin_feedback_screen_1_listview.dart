import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class AdminFeedbackScreen1Listview extends StatefulWidget {
  const AdminFeedbackScreen1Listview({
    super.key,
  });

  static const filterRequests = [
    // button color
    // count
    // onChange callback
    // on/off flag
    ('표시', Colors.green, 'show'),
    ('숨김', Colors.black54, 'hide'),
    ('미확인', Colors.redAccent, 'new'),
  ];

  @override
  State<AdminFeedbackScreen1Listview> createState() =>
      _AdminFeedbackScreen1ListviewState();
}

class _AdminFeedbackScreen1ListviewState
    extends State<AdminFeedbackScreen1Listview> {
  Map<String, Map<String, dynamic>> feedbackData = {};
  Map<String, Map<String, dynamic>> searchedData = {};
  TextEditingController controller = TextEditingController();
  Map<String, TextEditingController> controllers = {};

  Map<String, (dynamic, int)> filters = {};

  Map<String, Map<String, dynamic>> customData = {};
  bool isValidAccess = false;

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("feedback");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        feedbackData = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
        var sortedEntries = feedbackData.entries.toList()
          ..sort((e1, e2) {
            var diff = e2.value['date'].compareTo(e1.value['date']);
            return diff;
          });

        feedbackData =
            Map<String, Map<String, dynamic>>.fromEntries(sortedEntries);

        // 초기화
        filters = {};
        // searchedData = data;
        for (var e in feedbackData.entries) {
          var v = e.value;
          var k = e.key;
          var flag = '';
          // customData 초기화
          customData[k] = {};
          customData[k]!['isFunctionTabOpened'] = true;
          customData[k]!['functionTabMessage'] = '';
          customData[k]!['isDBEditTabOpened'] = false;
          customData[k]!['status'] = '';

          // 숨김 / 표시 초기화
          customData[k]!['show'] = (v['show'] ?? false);
          // 숨김
          flag = 'hide';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (customData[k]!['show'] == false) {
            filters[flag] = (false, filters[flag]!.$2 + 1);
            customData[k]!['hide'] = true;
            customData[k]!['status'] = '⚫ 숨김';
          }
          // 표시
          flag = 'show';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (customData[k]!['show'] == true) {
            filters[flag] = (false, filters[flag]!.$2 + 1);
            customData[k]!['status'] = '🟢 표시';
          }
          // 미확인
          customData[k]!['checked'] = (v['checked'] ?? false);
          flag = 'new';
          if (!filters.containsKey(flag)) filters[flag] = (false, 0);
          if (customData[k]!['checked'] == false) {
            filters[flag] = (false, filters[flag]!.$2 + 1);
            customData[k]!['new'] = true;
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
                          AdminFeedbackScreen1Listview.filterRequests,
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
                              '${noFilter ? searchedData.length : feedbackData.length}/${feedbackData.length}'),
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
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) =>
                        Container(height: 1.5, color: Colors.grey[300]),
                    itemCount:
                        noFilter ? searchedData.length : feedbackData.length,
                    itemBuilder: (context, index) {
                      // 검색
                      var d = noFilter ? searchedData : feedbackData;
                      var id = d.keys.elementAt(index);
                      var doc = d[id];
                      controllers['${id}_title'] =
                          TextEditingController(text: doc!['title']);
                      controllers['${id}_body'] =
                          TextEditingController(text: doc['body'].join('\n'));
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 10,
                          ),
                          // tileColor: Colors.white,
                          leading: Text('${d.length - index}'),
                          title: Builder(
                            builder: (context) {
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
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    doc['tutor'],
                                    style: TextStyle(
                                      color: customTheme.colorScheme.secondary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    Text(
                                      doc['title'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...[
                                          for (var (t, c, f) in [
                                            AdminFeedbackScreen1Listview
                                                .filterRequests[2],
                                          ])
                                            if (customData[id]![f] ?? false)
                                              Card(
                                                margin: const EdgeInsets.only(
                                                    left: 10),
                                                color: c,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    // cancel과 hold만 갯수 출력
                                                    t,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        ],
                                      ],
                                    ),
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
                              var children = [
                                Text(
                                  doc['name'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 50),
                                Text(
                                  doc['date'],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ];
                              return isMobile
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: children,
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: children);
                            },
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              width: double.infinity,
                              color: Colors.grey[100],
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: CheckboxListTile(
                                          value: doc['show'],
                                          tristate: true,
                                          onChanged: (v) {
                                            doc['show'] = !doc['show'];
                                            doc['checked'] = true;
                                            updateToFirestoreAsAdmin(id, doc);
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: const Text(
                                            '표시',
                                            // style: const TextStyle(
                                            //   color: Colors.white,
                                            // ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: CheckboxListTile(
                                          value: doc['checked'],
                                          tristate: true,
                                          onChanged: (v) {
                                            doc['checked'] = !doc['checked'];
                                            if (doc['checked'] == false) {
                                              doc['show'] = false;
                                            }
                                            updateToFirestoreAsAdmin(id, doc);
                                          },
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: const Text(
                                            '확인',
                                            // style: const TextStyle(
                                            //   color: Colors.white,
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TextFormField(
                                    controller: controllers['${id}_title'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // controller: feedbackTitleController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.next,
                                  ),
                                  const SizedBox(height: 5),
                                  TextFormField(
                                    controller: controllers['${id}_body'],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    // Text(
                                    //   doc!['body'].join('\n'),
                                    //   textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(height: 5),
                                  ElevatedButton(
                                    onPressed: () async {
                                      doc['title'] = controllers['${id}_title']!
                                          .text
                                          .trim();
                                      doc['body'] = controllers['${id}_body']!
                                          .text
                                          .trim()
                                          .split('\n');
                                      // doc['checked'] =
                                      //     customData[id]!['checked'];
                                      // doc['show'] = customData[id]!['show'];
                                      updateToFirestoreAsAdmin(id, doc);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(40),
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          customTheme.colorScheme.secondary,
                                      shadowColor: Colors.white,
                                    ),
                                    child: const Text(
                                      '업데이트',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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

  void filterData(_) {
    searchedData.clear();
    Map<String, Map<String, dynamic>> temp = Map.from(feedbackData);

    // Search 텍스트
    if (controller.text.isNotEmpty) {
      var removes = <String>{};
      temp.forEach((k, v) {
        if (!((v['email'] ?? '').contains(controller.text) ||
            v['name'].contains(controller.text) ||
            (((v['tutor'] ?? '').toLowerCase())
                .contains(controller.text.toLowerCase())))) removes.add(k);
      });
      for (var e in removes) {
        temp.remove(e);
      }
    }

    // 체크박스
    for (var flag in [
      for (var e in AdminFeedbackScreen1Listview.filterRequests) e.$3
    ]) {
      if (filters.containsKey(flag) && filters[flag]!.$1) {
        var removes = <String>{};
        temp.forEach((k, v) {
          if ((customData[k]![flag] ?? false) == false) {
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

  Future<void> updateToFirestoreAsAdmin(
      String id, Map<String, dynamic> data) async {
    try {
      FirebaseFirestore.instance
          .collection('feedback')
          .doc(id)
          .set(data)
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
}
