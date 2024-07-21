import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class AnnouncementScreen1Listview extends StatefulWidget {
  const AnnouncementScreen1Listview({
    super.key,
  });

  @override
  State<AnnouncementScreen1Listview> createState() =>
      _AnnouncementScreen1ListviewState();
}

class _AnnouncementScreen1ListviewState
    extends State<AnnouncementScreen1Listview> {
  Map<String, Map<String, dynamic>> data = {};

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("announcement");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        data = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
      });
    });
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
            const Divider(height: 0),
            ListView.separated(
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "공지",
                          style: TextStyle(
                            color: customTheme.colorScheme.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          id,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd')
                              .format(doc!['date'].toDate()),
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
                        child: Text(
                          doc['body'].join('\n'),
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

// import '../../models/announcement.dart';

// class AnnouncementScreen1Listview extends StatefulWidget {
//   const AnnouncementScreen1Listview({
//     super.key,
//   });

//   @override
//   State<AnnouncementScreen1Listview> createState() =>
//       _AnnouncementScreen1ListviewState();
// }

// class _AnnouncementScreen1ListviewState
//     extends State<AnnouncementScreen1Listview> {
//   List<dynamic> data = [];

//   Future<dynamic> getData() async {
//     final document = FirebaseFirestore.instance.collection("announcement");

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
//                 .collection('announcement')
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
