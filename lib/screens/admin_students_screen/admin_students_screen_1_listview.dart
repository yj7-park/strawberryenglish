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
  Map<String, Map<String, dynamic>> data = {};
  Map<String, Map<String, dynamic>> searchedData = {};
  TextEditingController controller = TextEditingController();

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("users");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        data = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
      });
    });
    // searchedData = data;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    leading: const Icon(Icons.search),
                    title: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          hintText: 'Search', border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${controller.text.isNotEmpty ? searchedData.length : data.length}/${data.length}'),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) =>
                  Container(height: 1.5, color: Colors.grey[300]),
              itemCount: controller.text.isNotEmpty
                  ? searchedData.length
                  : data.length,
              itemBuilder: (context, index) {
                var d = controller.text.isNotEmpty ? searchedData : data;
                var id = d.keys.elementAt(index);
                var doc = Map.fromEntries(d[id]!.entries.toList()
                  ..sort((e1, e2) => e1.key.compareTo(e2.key)));
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
                        Text(
                          id,
                          style: TextStyle(
                            color: customTheme.colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${doc['name']} ($id)',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${doc['lessonStartDate']} ~ ${doc['lessonEndDate']}'
                              .replaceAll('.', '-'),
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
                            ...doc.entries.map(
                              (e) => TextFormField(
                                decoration: InputDecoration(
                                  label: Text(e.key),
                                ),
                                initialValue:
                                    '${e.value.runtimeType == List ? e.value.join(', ') : e.value}',
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

  onSearchTextChanged(String text) async {
    searchedData.clear();
    if (text.isEmpty) {
      // searchedData = data;
      setState(() {});
      return;
    }

    data.forEach((k, v) {
      if (k.contains(text) || v['name'].contains(text)) searchedData[k] = v;
    });

    setState(() {});
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:strawberryenglish/themes/my_theme.dart';

// import '../../models/adminstudents.dart';

// class AdminStudentsScreen1Listview extends StatefulWidget {
//   const AdminStudentsScreen1Listview({
//     super.key,
//   });

//   @override
//   State<AdminStudentsScreen1Listview> createState() =>
//       _AdminStudentsScreen1ListviewState();
// }

// class _AdminStudentsScreen1ListviewState
//     extends State<AdminStudentsScreen1Listview> {
//   List<dynamic> data = [];

//   Future<dynamic> getData() async {
//     final document = FirebaseFirestore.instance.collection("adminstudents");

//     await document.get().then<dynamic>((snapshot) async {
//       setState(() {
//         data = snapshot.docs;
//       });
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Theme(
//       data: customTheme,
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
//           vertical: 50.0,
//         ),
//         child: SizedBox(
//           height: 500,
//           child: StreamBuilder(
//             stream: FirebaseFirestore.instance
//                 .collection('adminstudents')
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) =>
//                 ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               // separatorBuilder: (_, __) =>
//               //     Container(height: 1.5, color: Colors.grey[300]),
//               itemCount: streamSnapshot.data?.docs.length ?? 1,
//               itemBuilder: (context, index) {
//                 if (streamSnapshot.data == null) {
//                   return null;
//                 } else {
//                   return Card(
//                     elevation: 0.0,
//                     child: ExpansionTile(
//                       tilePadding: const EdgeInsets.symmetric(
//                         vertical: 20,
//                         horizontal: 10,
//                       ),
//                       // tileColor: Colors.white,
//                       title: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "공지",
//                             style: TextStyle(
//                               color: customTheme.colorScheme.secondary,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             data[index]['title'],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             "2024.04.0${index + 1}",
//                             style: const TextStyle(
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           width: double.infinity,
//                           color: Colors.grey[100],
//                           child: Text(
//                             data[index]['body'],
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
