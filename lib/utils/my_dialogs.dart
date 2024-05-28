import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:strawberryenglish/models/payment.dart';
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

class EnrollmentDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: customTheme, // customTheme을 적용
          child: AlertDialog(
            title: Column(
              children: [
                const Text(
                  '수강료 결제',
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
                          """
구독기간 : 3개월
수업횟수 : 주 3회
수업길이 : 30분
수업토픽 : Power/Fluency
결제금액 : 267,000원 (월 89,000원)""",
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
                child: const Text('나중에 결제하기'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('결제하기'),
              ),
            ],
          ),
        );
      },
    );
  }
}
