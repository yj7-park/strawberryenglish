import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class ConfirmationDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: customTheme, // customTheme을 적용
            child: AlertDialog(
              title: const Text('로그아웃 하시겠습니까?'),
              titleTextStyle:
                  const TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('확인'),
                ),
              ],
            ));
      },
    );
  }
}
