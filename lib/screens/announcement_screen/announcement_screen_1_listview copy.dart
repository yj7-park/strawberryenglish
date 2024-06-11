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
//   List<Announcement> announcementMessages = [];
//   late final FirebaseDatabase database;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   late DatabaseReference databaseReference;

//   @override
//   void initState() {
//     super.initState();

//     final firebaseApp = Firebase.app();
//     database = FirebaseDatabase.instanceFor(
//         app: firebaseApp,
//         databaseURL: 'https://strawberry-english-default-rtdb.firebaseio.com/');

//     databaseReference = database.ref().child("announcement");
//     databaseReference.onChildAdded.listen(_onEntryAdded);
//     databaseReference.onChildChanged.listen(_onEntryChanged);
//     databaseReference.onChildRemoved.listen(_onEntryRemoved);
//   }

//   void _onEntryAdded(event) {
//     setState(() {
//       announcementMessages.add(Announcement.fromSnapshot(event.snapshot));
//     });
//   }

//   // void handleSubmit() {
//   //   final FormState form = formKey.currentState!;
//   //   if (form.validate()) {
//   //     form.save();
//   //     form.reset();
//   //   // save form data to the database
//   //   announcement.title = '안녕2';
//   //   announcement.body = '테스트야2';

//   //   databaseReference.child("1").set(announcement.toJson());
//   //   }
//   // }

//   void _onEntryChanged(event) {
//     var oldEntry = announcementMessages.singleWhere((entry) {
//       return entry.key == event.snapshot.key;
//     });

//     setState(() {
//       announcementMessages[announcementMessages.indexOf(oldEntry)] =
//           Announcement.fromSnapshot(event.snapshot);
//     });
//   }

//   void _onEntryRemoved(event) {
//     var oldEntry = announcementMessages.singleWhere((entry) {
//       return entry.key == event.snapshot.key;
//     });

//     setState(() {
//       announcementMessages.removeAt(announcementMessages.indexOf(oldEntry));
//     });
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
//         child: ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           separatorBuilder: (_, __) =>
//               Container(height: 1.5, color: Colors.grey[300]),
//           itemCount: announcementMessages.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 0.0,
//               child: ExpansionTile(
//                 tilePadding: const EdgeInsets.symmetric(
//                   vertical: 20,
//                   horizontal: 10,
//                 ),
//                 // tileColor: Colors.white,
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "공지",
//                       style: TextStyle(
//                         color: customTheme.colorScheme.secondary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       announcementMessages[index].title,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       "2024.04.0${index + 1}",
//                       style: const TextStyle(
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ],
//                 ),
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     width: double.infinity,
//                     color: Colors.grey[100],
//                     child: Text(
//                       announcementMessages[index].body,
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
