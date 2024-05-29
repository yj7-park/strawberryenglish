import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberryenglish/models/payment.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class LogoutDialog {
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
            backgroundColor: Colors.white,
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
          ),
        );
      },
    );
  }
}

class ConfirmDialog {
  static Future<bool?> show(
    BuildContext context,
    String title,
    String body,
    String trueButton,
    String falseButton,
  ) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: customTheme, // customTheme을 적용
          child: AlertDialog(
            title: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(3),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          body,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            titleTextStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(falseButton),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(trueButton),
              ),
            ],
          ),
        );
      },
    );
  }
}
