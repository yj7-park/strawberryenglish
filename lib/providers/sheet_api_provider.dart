import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:excel/excel.dart';

class SheetApiProvider {
  static final SheetApiProvider _instance = SheetApiProvider._internal();
  late sheets.SheetsApi sheetsApi;
  late Future<void> _initialization;

  List<List<Object?>>? studentSheet;

  factory SheetApiProvider() {
    return _instance;
  }

  SheetApiProvider._internal() {
    _initialization = _initSheetsApi();
  }

  Future<void> init() async {
    await _initialization; // Wait for _initialization Future to complete
  }

  Future<void> _initSheetsApi() async {
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "strawberry-english",
      "private_key_id": "48040cb2fd1a2324a5465d9bffb56134b7da8f86",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDyQFhHRc4fEJBY\n5+DNzoTcG+qRwI0cZaUr6bO0EVKZKu+tilhrxea+ExHbwhYSC0kW3RjRoHBCaT/y\njeieWphNPVn8CyEOekR1GDDBuP70DYaywlmKazNqLXqHeqTtr3VvhC1/wahz7g4P\nowMHQSGRCd29UCVbWSPKnF5z0eIYWN9n/Eo0X/JWDCdhjv+iASOFCOZaMs9X1FPe\nTSjVKFbnFiC/CwXx0de4RRHL7M+Xp9HCyLeiCDEj24pc+pZye5efBWZAHbLsNAS5\nLWr3jLm5csFnsnAueC3W85tLhuRrSZEI+YhKinlKAjYCYs3WKnyaLOHp/+FIeHo0\nEm+pR8EjAgMBAAECggEAEWePEBvTSccSX9jU/WRThk7ZJPydBsfEvKlvOEYwVYHQ\ns3qnjKKsx8Yt98hzdntqFmLvKAxrVFIkfoQ0jL/8hjwcrW+NQfGF3pXM1vY4Fwer\nwEcXUMsP6BZ5YadtlwgOm2L3M+ERfbbCOtxe2NQUmcuIK1RJQs1eNW3TmWWgZVhF\ndt5MO9DTuwHHsBQSi7KIKPjReINun5Dsa7l+LiO1bbEqdK35apeQjMSkbAZ55bim\nj0R21TwrAer8SQB+ru8gywdMLc67NQllstRvzSdWo4YCf+ZTLFa9ZJQ25zULL5Y7\nUm3mzECYlYjo//bFKQxXt9+kKqmtvS5tingT4MCZwQKBgQD9KQWi65cs3sNKeylg\nxqCUpQCTgRSEgme2irUEzDrpM3PyPkygowBGfLpmrXBpmDrLZJ95bw2NwCrrpX7Q\nrvYzmycgQxejIiJQU93dspneycYATu+YCmpC+zXRyAHFYJsqa3KzTpFLyRtlSkq1\n4AibAoI/dIa7x2KFA27/03knwQKBgQD09/8oImxQJSGf4KyKBMaJTVEgunWFas15\nmPmMopUZ5WdmYFDjy6cR036kcx40//eLMpUbazl5+2+xA0lxd6GRrVxtWKs1geM7\noM+jzPlkEHOjObf+WpeKtx4TtJ5otKVFjL3Qi3X+Dw05xLF2w9cUxRKrQBA33JS8\naAjmLiHB4wKBgQDKQmQGbkMxzigo8Y11jDvvhoSXVKGX3LgP13IYizLl7f3MpImE\nLbaimjQypI8TTlRq+9GNq3QgtE+WRXq0L5T0VhlEZVYVN8hCdT7lSTQ2Eu7mgCpc\nRrXvHdU57Zm8oBpYIdBaAYOEEQCaRGi8Nmmprq9xEyAyFnJX4w5jxgkeAQKBgF46\nWqqcex9k+QcfjB7W8Wt1EyTMtFHqoDkKz8r56vJ4HIrzt4m4F36y5L7rDQ6D+ztO\n7K4MU6KJRhBH3GNKChsYHTpuZgUB/l88X0J5oOCNt31swUqUnEAeafJYgqpx+jTD\ni2wBiRR9w6+Z6k1tzXjOyXyX+uUR8yB5wBqSWifTAoGAGmOOYp/nZxGA81dvgQ5I\nndiwN0IGXCsJWBRdry2wdIM2zSvU9/3JHhGSM83oJ9+Tg7tLMQiQ/uHCHbhbPy9W\n3SKXHBA26wW1kQLHcnYXxJvgalWfbUQiMHvP8A3al1vXSMffbOZQfs6Momv5We/f\n/WPay3+TtSdkknoaIrpSYAs=\n-----END PRIVATE KEY-----\n",
      "client_email": "gsheet-api@strawberry-english.iam.gserviceaccount.com",
      "client_id": "107087363127468556582",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/gsheet-api%40strawberry-english.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    // Authenticate using the service account credentials
    final httpClient = await clientViaServiceAccount(
      serviceAccountCredentials,
      [
        'https://www.googleapis.com/auth/spreadsheets'
      ], // Adjust the scope accordingly
    );

    // Access Google Sheets API
    sheetsApi = sheets.SheetsApi(httpClient);
  }

  Future<List<List<Object?>>> getStudentSheet() async {
    if (studentSheet == null) {
      if (kDebugMode) {
        try {
          var data = await rootBundle.load('assets/images/test.xlsx');
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          var excel = Excel.decodeBytes(bytes);
          var sheet = excel.tables['최신 고객 목록'];
          studentSheet = [];
          for (var row in sheet!.rows) {
            List<Object?> rowData = [];
            for (var cell in row) {
              rowData.add(cell!.value);
            }
          }
        } catch (e) {
          print(e);
        }
      } else {
        var response = await sheetsApi.spreadsheets.values.get(
          '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
          '최신 고객 목록!A6:AO505', // 범위는 필요에 따라 조절하세요
        );
        studentSheet = response.values!;
      }
    }
    return studentSheet!;
  }

  void updateStudentSheet(List<Object?> row, int i) async {
    if (kDebugMode) {
      var data = await rootBundle.load('asset/images/test.xlsx');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      var excel = Excel.decodeBytes(bytes);
      var sheet = excel.tables['최신 고객 목록'];
      for (int j = 0; j < row.length; j++) {
        sheet!.updateCell(
            CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i),
            row[j].toString() as CellValue?);
      }
    } else {
      sheetsApi.spreadsheets.values.update(
        sheets.ValueRange(
          range: '최신 고객 목록!A${i + 6}:AO${i + 6}',
          values: [row],
        ),
        '13cK1mVHqMddsi_YO8iRj6gSbZMQvkyJBSduX9I7Xwt0',
        '최신 고객 목록!A${i + 6}:AO${i + 6}', // 시트 이름을 실제 이름으로 교체
        valueInputOption: 'RAW',
      );
    }
  }
}
