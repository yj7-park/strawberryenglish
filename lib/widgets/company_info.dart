import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class CompanyInfo extends StatelessWidget {
  const CompanyInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Container(
        color: Colors.grey.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: (screenWidth - 400).clamp(20, 200), vertical: 30),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                """
딸기아카데미 | 519-55-00921 | 대표자 윤소명 | 이메일 strawberryacademy23@gmail.com | 전화번호 054-451-0722
통신판매업 신고번호 | 제 2024-경북구미-0940 호
경북 구미시 고아읍 송평구길 62 나동 1402호

딸기영어는 '딸기아카데미'의 영어교육 서비스 브랜드입니다.
상표권 등록번호 | 40-2024-0081521
                """,
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 12,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
