// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:googleapis/sheets/v4.dart' as sheets;
// import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

// class SheetApiProvider {
//   static final SheetApiProvider _instance = SheetApiProvider._internal();
//   late sheets.SheetsApi sheetsApi;
//   late Future<void> _initialization;

//   List<List<Object?>>? studentSheet;
//   List<List<Object?>>? tutorSheet;

//   factory SheetApiProvider() {
//     return _instance;
//   }

//   SheetApiProvider._internal() {
//     _initialization = _initSheetsApi();
//   }

//   Future<void> init() async {
//     await _initialization; // Wait for _initialization Future to complete
//   }

//   Future<void> _initSheetsApi() async {
//     final serviceAccountCredentials = ServiceAccountCredentials.fromJson({});

//     // Authenticate using the service account credentials
//     final httpClient = await clientViaServiceAccount(
//       serviceAccountCredentials,
//       [
//         'https://www.googleapis.com/auth/spreadsheets'
//       ], // Adjust the scope accordingly
//     );

//     // Access Google Sheets API
//     sheetsApi = sheets.SheetsApi(httpClient);
//   }

//   Future<List<List<Object?>>> getStudentSheet() async {
//     // if (studentSheet == null || studentSheet!.isEmpty) {
//     if (kDebugMode) {
//       try {
//         var data = await rootBundle.load('assets/images/test.xlsx');
//         List<int> bytes =
//             data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//         var excel = SpreadsheetDecoder.decodeBytes(bytes, update: true);
//         var sheet = excel.tables['최신 고객 목록'];
//         studentSheet = [];
//         studentSheet = sheet!.rows.sublist(5).map((innerList) {
//           return innerList.map((dynamicItem) => dynamicItem ?? '').toList();
//         }).toList();
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       var response = await sheetsApi.spreadsheets.values.get(
//         '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
//         '최신 고객 목록!A6:AO505', // 범위는 필요에 따라 조절하세요
//       );
//       studentSheet = response.values!;
//     }
//     // }
//     return studentSheet!;
//   }

//   Future<List<List<Object?>>> getTutorSheet() async {
//     // if (tutorSheet == null || tutorSheet!.isEmpty) {
//     if (kDebugMode) {
//       try {
//         var data = await rootBundle.load('assets/images/test.xlsx');
//         List<int> bytes =
//             data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//         var excel = SpreadsheetDecoder.decodeBytes(bytes, update: true);
//         var sheet = excel.tables['튜터 목록'];
//         tutorSheet = [];
//         tutorSheet = sheet!.rows.sublist(5).map((innerList) {
//           return innerList.map((dynamicItem) => dynamicItem ?? '').toList();
//         }).toList();
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       var response = await sheetsApi.spreadsheets.values.get(
//         '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
//         '튜터 목록!A6:AO505', // 범위는 필요에 따라 조절하세요
//       );
//       tutorSheet = response.values!;
//     }
//     // }
//     return tutorSheet!;
//   }

//   void updateStudentSheet(List<Object?> row, int i) async {
//     if (kDebugMode) {
//       var data = await rootBundle.load('assets/images/test.xlsx');
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       var excel = SpreadsheetDecoder.decodeBytes(bytes, update: true);
//       var sheet = excel.tables['최신 고객 목록'];
//       for (int j = 0; j < row.length; j++) {
//         excel.updateCell(sheet!.name, j, i, row[j].toString());
//       }
//     } else {
//       sheetsApi.spreadsheets.values.update(
//         sheets.ValueRange(
//           range: '최신 고객 목록!A${i + 6}:AO${i + 6}',
//           values: [row],
//         ),
//         '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
//         '최신 고객 목록!A${i + 6}:AO${i + 6}', // 시트 이름을 실제 이름으로 교체
//         valueInputOption: 'RAW',
//       );
//     }
//   }

//   void updateTutorSheet(List<Object?> row, int i) async {
//     if (kDebugMode) {
//       var data = await rootBundle.load('assets/images/test.xlsx');
//       List<int> bytes =
//           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//       var excel = SpreadsheetDecoder.decodeBytes(bytes, update: true);
//       var sheet = excel.tables['튜터 목록'];
//       for (int j = 0; j < row.length; j++) {
//         excel.updateCell(sheet!.name, j, i, row[j].toString());
//       }
//     } else {
//       sheetsApi.spreadsheets.values.update(
//         sheets.ValueRange(
//           range: '튜터 목록!A${i + 6}:AO${i + 6}',
//           values: [row],
//         ),
//         '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
//         '튜터 목록!A${i + 6}:AO${i + 6}', // 시트 이름을 실제 이름으로 교체
//         valueInputOption: 'RAW',
//       );
//     }
//   }
// }
