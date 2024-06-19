import 'package:flutter/material.dart';
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
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    String body = "",
    required String trueButton,
    String falseButton = "",
    String routeToOnLeft = "",
    String routeToOnRight = "",
  }) async {
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
                const SizedBox(height: 50),
                if (body != "")
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            body,
                            style: const TextStyle(
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
              if (falseButton != "")
                TextButton(
                  onPressed: () {
                    routeToOnLeft.isEmpty
                        ? Navigator.of(context).pop(false)
                        : Navigator.pushNamed(context, routeToOnLeft);
                  },
                  child: Text(falseButton),
                ),
              TextButton(
                onPressed: () {
                  routeToOnRight.isEmpty
                      ? Navigator.of(context).pop(true)
                      : Navigator.pushNamed(context, routeToOnRight);
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
