import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class LogoutDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: customTheme, // customTheme을 적용
          child: PointerInterceptor(
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
    required String trueButton,
    List<Widget>? body,
    String falseButton = "",
    String routeToOnLeft = "",
    String routeToOnRight = "",
  }) async {
    Widget? content;
    if (body != null) {
      content = Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: body,
        ),
      );
    }
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: customTheme, // customTheme을 적용
          child: PointerInterceptor(
            child: AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customTheme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              content: content,
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
          ),
        );
      },
    );
  }
}
