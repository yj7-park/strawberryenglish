// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/enrollment_screen.dart';

class EnrollmentScreen2PaymentInput extends StatefulWidget {
  final TextEditingController cashReceiptNumberController;

  const EnrollmentScreen2PaymentInput({
    super.key,
    required this.cashReceiptNumberController,
  });

  @override
  EnrollmentScreen2PaymentInputState createState() =>
      EnrollmentScreen2PaymentInputState();
}

class EnrollmentScreen2PaymentInputState
    extends State<EnrollmentScreen2PaymentInput> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: ((screenWidth - 500) / 2).clamp(20, double.nan),
      ),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   '결제 정보',
            //   style: TextStyle(
            //     fontSize: 25,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 30),
            // TextFormField(
            //   controller: widget.cashReceiptNumberController,
            //   decoration: const InputDecoration(
            //     labelText: '현금 영수증 번호',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (_) {
            //     setState(() {});
            //   },
            //   keyboardType: TextInputType.phone,
            //   inputFormatters: [
            //     FilteringTextInputFormatter.allow(
            //       RegExp("[0-9-]"),
            //     ),
            //   ],
            //   textInputAction: TextInputAction.next,
            // ),

            // 개인정보 취급방침 동의
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: EnrollmentScreen.check,
                        onChanged: ((value) {
                          setState(
                            () {
                              EnrollmentScreen.check = value!;
                            },
                          );
                        }),
                      ),
                      const Text('[필수] 개인정보 취급방침 동의'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(50),
                                child: Scrollbar(
                                  controller: scrollController,
                                  interactive: true,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text("""
[필수] 개인정보 취급방침 동의

딸기아카데미는 고객님의 개인정보 보호를 위해 최소한의 정보만 수집합니다.

1. 개인정보의 처리 목적

딸기영어 웹사이트 (‘https://yj7-park.github.io/web_test/’) 및 서비스 운영 주체 ‘딸기아카데미’’(이하 딸기아카데미)는 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다.

- 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리, 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급.배송, 서비스에 대한 안내 및 이벤트/혜택사항 안내 등

2. 개인정보의 처리 및 보유 기간

① 딸기영어는 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.

② 구체적인 개인정보 처리 및 보유 기간은 다음과 같습니다.

고객 가입 및 관리 : 서비스 이용계약 해지 후 5년까지 (고객 서비스 관리 및 분쟁조정을 위함)

- 전자상거래에서의 계약․청약철회, 대금결제, 재화 등 공급기록 : 5년

3. 정보주체와 법정대리인의 권리·의무 및 그 행사방법

이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

① 정보주체는 딸기아카데미에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.

ㄱ. 개인정보 열람요구

ㄴ. 오류 등이 있을 경우 정정 요구

ㄷ. 삭제요구

ㄹ. 처리정지 요구

4. 처리하는 개인정보의 항목

① 딸기아카데미는 다음의 개인정보 항목을 처리하고 있습니다.

- 필수항목 : 이름, 생년월일, 휴대전화번호, 스카이프ID, 기타수강관련기재사항
- 선택항목 : 현금영수증발급정보, 기타수강관련기재사항

5. 개인정보의 파기

딸기아카데미는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

- 파기절차

이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

- 파기기한

이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

6. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

① 딸기아카데미는 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠기(cookie)’를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.

7. 개인정보 보호책임자

① 딸기아카데미는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자

성명 :윤소명

직책 :관리자

직급 :관리자

연락처 :01097230721, hgu0485@naver.com

※ 개인정보 보호 담당부서로 연결됩니다.

▶ 개인정보 보호 담당부서

부서명 :딸기아카데미

담당자 : 윤소명

연락처 :01097230721, hgu0485@naver.com

② 정보주체께서는 딸기아카데미의 서비스를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 딸기아카데미는 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

8. 개인정보 처리방침 변경

①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.

9. 개인정보의 안전성 확보 조치

딸기아카데미는 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

ㄱ. 개인정보 취급 직원의 최소화 및 교육

개인정보를 취급하는 직원을 지정하고 담당자에 한정시켜 최소화 하여 개인정보를 관리하는 대책을 시행하고 있습니다.

ㄴ. 개인정보의 암호화

이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

ㄷ. 개인정보에 대한 접근 제한

개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.

2024년 7월 31일부 개정
                                  """),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: const Text(
                      '내용 보기',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
