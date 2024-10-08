import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class FeedbackScreen1Listview extends StatefulWidget {
  const FeedbackScreen1Listview({super.key});

  @override
  State<FeedbackScreen1Listview> createState() =>
      _FeedbackScreen1ListviewState();
}

class _FeedbackScreen1ListviewState extends State<FeedbackScreen1Listview> {
  Map<String, Map<String, dynamic>> data = {};

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("feedback");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        data = {
          for (var doc in snapshot.docs)
            if (doc.data()['show'] ?? false) doc.id: doc.data(),
        };
      });
    });

    var sortedEntries = data.entries.toList()
      ..sort((e1, e2) {
        var diff = e2.value['date'].compareTo(e1.value['date']);
        return diff;
      });

    data = Map<String, Map<String, dynamic>>.fromEntries(sortedEntries);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;
    var itemCount = data.length;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: Column(
          children: [
            const Divider(height: 0),
            ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
                  Container(height: 1.5, color: Colors.grey[300]),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var id = data.keys.elementAt(index);
                var doc = data[id];
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0.0,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    // tileColor: Colors.white,
                    leading: Text('${itemCount - index}'),
                    title: Builder(
                      builder: (context) {
                        var children = [
                          SizedBox(
                            width: 100,
                            child: Text(
                              doc!['tutor'],
                              style: TextStyle(
                                color: customTheme.colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            doc['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ];
                        return isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: children,
                              )
                            : Row(children: children);
                      },
                    ),
                    trailing: Builder(
                      builder: (context) {
                        var children = [
                          Text(
                            doc!['name'][0] + 'O' * (doc['name'].length - 1),
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
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                        child: Text(
                          doc!['body'].join('\n'),
                          textAlign: TextAlign.left,
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
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:strawberryenglish/themes/my_theme.dart';

// import '../../models/feedback.dart';

// class FeedbackScreen1Listview extends StatefulWidget {
//   const FeedbackScreen1Listview({
//     super.key,
//   });

//   @override
//   State<FeedbackScreen1Listview> createState() =>
//       _FeedbackScreen1ListviewState();
// }

// class _FeedbackScreen1ListviewState
//     extends State<FeedbackScreen1Listview> {
//   List<dynamic> data = [];

//   Future<dynamic> getData() async {
//     final document = FirebaseFirestore.instance.collection("feedback");

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
//                 .collection('feedback')
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
