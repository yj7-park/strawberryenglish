import 'package:flutter/services.dart';
// import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:strawberryenglish/screens/signup_screen.dart';

class SignupScreen1LoginInfo extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const SignupScreen1LoginInfo({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  SignupScreen1LoginInfoState createState() => SignupScreen1LoginInfoState();
}

class SignupScreen1LoginInfoState extends State<SignupScreen1LoginInfo> {
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
            TextFormField(
              controller: widget.emailController,
              decoration: const InputDecoration(
                  labelText: '*아이디(이메일)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: '*비밀번호', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                  labelText: '*비밀번호 확인', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: SignupScreen.check1 &
                      SignupScreen.check2 &
                      SignupScreen.check3,
                  onChanged: ((value) {
                    setState(
                      () {
                        SignupScreen.check1 =
                            SignupScreen.check2 = SignupScreen.check3 = value!;
                      },
                    );
                  }),
                ),
                const Text('모두 선택'),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: SignupScreen.check1,
                        onChanged: ((value) {
                          setState(
                            () {
                              SignupScreen.check1 = value!;
                            },
                          );
                        }),
                      ),
                      const Text('[필수] 개인정보 수집이용 동의'),
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        showModalBottomSheet(
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
[필수] 개인정보 수집이용 동의

딸기아카데미는 고객님의 개인정보 보호를 위해 최소한의 정보만 수집합니다.

1. 개인정보의 처리 목적

딸기영어 웹사이트 ('https://strawberryenglish.com') 및 서비스 운영 주체 '딸기아카데미'(이하 딸기아카데미)는 다음의 목적을 위하여 개인정보를 처리하고 있으며, 다음의 목적 이외의 용도로는 이용하지 않습니다.

- 고객에 대한 서비스 제공에 따른 본인 식별.인증, 회원자격 유지.관리, 서비스 공급에 따른 금액 결제, 물품 또는 서비스의 공급.배송, 서비스에 대한 안내 및 이벤트/혜택사항 안내 등

2. 개인정보의 처리 및 보유 기간

① 딸기아카데미는 정보주체로부터 개인정보를 수집할 때 동의 받은 개인정보 보유․이용기간 또는 법령에 따른 개인정보 보유․이용기간 내에서 개인정보를 처리․보유합니다.

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

- 필수항목 : 이메일 주소, 한국이름, 휴대전화번호, 스카이프ID, 기타수강관련기재사항
- 선택항목 : 현금영수증발급정보, 기타수강관련기재사항

5. 개인정보의 파기

딸기아카데미는 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

- 파기절차

이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

- 파기기한

이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

6. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

① 딸기아카데미는 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 '쿠기(cookie)'를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.

7. 개인정보 보호책임자

① 딸기아카데미는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자

성명 :윤소명

직책 :대표자

직급 :대표자

연락처 :01097230721, strawberryenglish23@gmail.com

※ 개인정보 보호 담당부서로 연결됩니다.

▶ 개인정보 보호 담당부서

부서명 :딸기아카데미

담당자 :윤소명

연락처 :01097230721, strawberryenglish23@gmail.com

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
                      )),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: SignupScreen.check2,
                        onChanged: ((value) {
                          setState(
                            () {
                              SignupScreen.check2 = value!;
                            },
                          );
                        }),
                      ),
                      const Text('[필수] 딸기영어 이용 약관 동의'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
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
[필수] 딸기영어 이용 약관 동의

제 1조 목적

본 약관은 '딸기영어 수강안내' 및 '딸기영어 수강신청' 페이지에 게시 되어있는 수강 규칙을 구체적으로 설명한 것이며, 딸기아카데미(이하 '회사')가 운영하는 딸기영어 웹 사이트와 모든 서비스를 이용하는 것과 관련된 권리, 의무 등을 규정하는 것을 목적으로 하고 있습니다.

제 2조 정의

“회사” : 딸기영어를 운영하는 회사를 의미합니다.

“방문자” : 딸기영어 웹사이트에 방문한 모든 방문자를 의미합니다.

“이용자” : 딸기영어 서비스를 이용하는 모든 이용자를 의미합니다.

“강사” : 딸기영어 플랫폼에서 영어 수업을 제공하는 자를 의미합니다.

“회원” : 딸기영어 웹사이트에 가입한 모든 회원을 의미합니다.

“포인트” : 딸기영어 서비스 과정에서 회원에게 주어지는 포인트를 의미합니다. 딸기영어회원은 포인트를 사용해 수강권 구매 시 해당 액수만큼 할인을 받을 수 있습니다.

“컨텐츠” : 딸기영어 웹사이트에 업로드 되어있는 모든 자료를 의미합니다.

“수업 세션” : 이용자가 수업료를 지불하고 수업을 수강하는 해당 수강 기간을 의미합니다. 예를 들어, 주 2회 수업 1개월(4주)를 신청하여 수강하는 경우 해당 1개월(4주)간의 수강기간이 1개의 수업 세션입니다. 수업 세션은 수업 연기 혹은 조정이 발생한 경우 조정될 수 있습니다.

제 3조 약관의 명시와 개정

1. 본 약관은 회원가입 화면에 게시되며, 회사는 필요한 경우 약관을 개정할 수 있습니다. 개정된 약관은 딸기영어 웹사이트 “공지사항”에 게시됩니다.

2. 약관 개정은 효력 시행 7일 이전부터 통지되며, 약관 효력 시행일까지 이용자가 거부 의사를 표하지 않는 경우 약관 변경에 동의하는 것으로 간주됩니다.

3. 본 약관에 규정되지 않은 사항은 관계 법령 혹은 회사의 세부 운영 규칙에 따릅니다.

제 4조 서비스의 제공, 변경, 중단

1. 회사는 이용자가 구매한 서비스를 이용하는 것에 차질이 없도록 서비스 품질을 관리합니다.

2. 회사는 서비스의 품절, 법률적 문제, 국가 비상 사태 등이 발생하는 경우 서비스 제공을 중지할 수 있으며, 서비스 제공이 완료되지 않은 이용자에게는 수업료를 일할 계산하여 환불합니다.

3. 회사 혹은 강사의 단순 과실(행정상 오류, 착오 등으로 발생한 과실)으로 인해 사전 고지 없이 서비스 제공이 되지 않은 경우에는 진행되지 않은 해당 수업을 보상하고, 이에 더해 이용자에게 적립금 보상을 제공합니다.

4. 아래 한 가지에 해당하는 이유로 서비스 제공이 되지 않은 경우에는 진행되지 않은 수업을 보상하고, 문제가 해결되어 서비스 제공을 재개할 수 있을 때까지 서비스 제공이 중단될 수 있습니다. 이 경우, 진행되지 않은 수업 보상 외에 추가 보상은 지급되지 않습니다.

➀ 국가적 재난, 천재지변 혹은 이에 준하는 상황으로 인해 회사가 정상적으로 서비스 진행이 불가능한 경우.

② 수업 진행을 위해 사용하는 소프트웨어에 광범위적 문제(광범위한 지역에서의 사용 장애)가 발생해 정상적으로 서비스 진행이 불가능한 경우.

5. 이용자의 담당 강사가 더 이상 수업 제공이 불가능한 경우 이용자는 담당 강사를 교체해서 수업을 진행할 수 있으며, 새로운 담당 강사와 일정이 확정될 때까지 수업이 중단될 수 있습니다.

6. 이용자는 수강기간 내에 특정 수업에 참여가 어려운 경우 수강 연기를 진행할 수 있습니다. 1개월 구독 시, 주 2회 이하 수업의 경우 4주 세션동안 총 2회, 주 3회 수업의 경우 4주 세션동안 총 3회, 주 5회 수업의 경우 4주 세션 동안 총 5회 수업 연기가 가능합니다. 3개월 구독 시, 주 2회 이하 수업의 경우 12주 세션동안 총 5회, 주 3회 수업의 경우 12주 세션동안 총 7회, 주 5회 수업의 경우 12주 세션 동안 총 12회 수업 연기가 가능합니다.모든 수업 연기는 연기하고자 하는 수업 12시간 이전까지 신청할 수 있으며, 수업까지 12시간이 남지 않은 경우에는 해당 수업에 대한 연기를 신청할 수 없습니다. 강사 또한 수업 연기가 가능하며, 별도의 횟수 제한은 존재하지 않습니다. 강사가 수강 연기를 너무 잦게 신청하는 경우, 이용자는 언제든지 강사를 교체할 수 있습니다. 수업이 연기되는 경우 해당 수업은 취소되고 해당 수강기간의 종료일이 연장됩니다. “종료일 연장”은 마지막 수업이 1회 밀리는 것을 의미합니다. 예를 들어, 수업 스케줄이 월/수/금 오후 8시이며 마지막 수업이 5월 15일(수요일)인 경우, 임의의 1회 수업이 연기되면 연기한 수업이 취소됨과 동시에 마지막 수업이 1회 추가되어 종료일이 5월 17일(금요일)으로 밀리게 됩니다.

7. 수업이 진행되지 않는 경우에도 아래 각 호의 하나에 해당하는 경우 수업은 진행된 것으로 간주합니다.

① 수업이 이용자에 의해 수업 시작 12시간 이내에 취소된 경우.

② 이용자가 연기신청 없이 수업에 참여하지 않은 경우.

③ 이용자가 외설적인 언행 및 행동, 욕설 등 사회통념에 어긋나는 행위를 함으로 인해 담당 강사가 수업을 거부한 경우.

8. 회사는 필요에 의해 서비스 제공 방식, 서비스의 내용을 변경할 수 있습니다. 서비스 변경이 예정된 경우 이용자에게 해당 변경 내용이 변경 이전에 공지됩니다. 회사는 미리 이용권을 결제한 이용자의 수강 기간 동안에 서비스의 내용이 변경되는 경우, 이용자와 협의를 통해 보상을 제공할 수 있습니다.

제 5조 회원가입 및 수강신청

1. 방문자는 캐스영어 웹사이트에 최소한의 개인정보를 기입하여 회원가입을 할 수 있습니다. 회원가입을 진행한 회원은 수강신청을 할 수 있는 자격을 얻습니다.

2. 방문자는 서비스 이용 약관과 회사의 개인정보 처리방침에 동의하는 경우 회원가입을 진행할 수 있습니다.

3. 회원은 서비스 이용에 있어 필수적인 정보(영어 이름, Skype ID, 원하는 수업 방향 등)를 입력한 후 수강신청을 진행할 수 있습니다.

4. 회원이 수강신청시 기입한 수강 관련 정보는 회원의 담당 강사가 확인할 수 있습니다.

제 6조 회원 탈퇴 및 자격의 상실

1. 회사는 회원이 아래 각 호중 하나에 해당하는 경우 회원자격을 상실시킬 수 있습니다.

① 적절하지 않은 방법으로 딸기영어 웹사이트 및 서비스를 이용해 회사에 손실을 끼치거나, 잠재적으로 손실을 끼칠 위험이 있는 경우

② 본인이 아닌 타인의 개인정보로 회원가입을 진행한 경우.

③ 회원가입시 등록한 내용에 허위, 기재누락, 오기가 있는 경우.

④ 서비스에 대한 채무를 서비스 제공일까지 지불하지 않는 경우.

⑤ 서비스 이용 중 외설적인 언행, 폭언, 욕설, 타 업체 홍보 등을 표출하는 경우.

⑥ 회사의 지식재산권을 침해하거나, 회사의 직원 및 수업을 제공하는 강사의 초상권 및 법적으로 보호되는 권리를 침해할 경우.

2. 제 6조 1항 ①호, ⑤호, ⑥호에 근거해 회원자격이 상실 된 경우, 회사는 당사자에게 손해배상을 청구할 수 있습니다.

3. 회원은 언제든지 회원 탈퇴를 신청할 수 있습니다. 회원 탈퇴 시 서비스 제공이 완료되지 않은 경우에도 서비스 제공은 중단되며, 적립된 포인트는 즉시 소멸됩니다. 회원은 이에 대해 보상을 요청할 수 없습니다. 회사는 회원이 뜻하지 않게 회원 탈퇴 신청할 가능성을 고려해, 회원 탈퇴 신청이 이뤄진 후 관리자가 2차 확인을 한 후 회원 탈퇴를 진행합니다. 이 때, 관리자는 회원의 탈퇴 의사를 확인하기 위해 회원이 회원가입과 수강신청 시 입력한 이메일 혹은 전화번호로 연락을 취할 수 있습니다. 회원 탈퇴 신청 이후 최소 7일의 유예기간이 존재하며, 유예기간동안 회원이 회원 탈퇴 의사를 철회하는 경우 회원 탈퇴는 취소됩니다. 회원이 즉각 탈퇴를 원하는 경우, 유효한 상담 통로(유선, 카카오톡채널 등)으로 즉각 탈퇴 의사를 표명할 수 있습니다. 이 경우 회원 탈퇴는 24시간 이내에 이뤄집니다.

제 7조 결제 및 영수증 발급

1. 결제는 카드결제, 간편결제, 계좌이체 등으로 이뤄집니다.

2. 결제 증빙(카드전표, 현금영수증 등)이 필요한 경우 이용자는 회사에 결제 증빙을 요청할 수 있습니다. 각 카드사 및 법에서 정하는 특정 기간이 지난 경우 결제 증빙 발행이 불가할 수 있습니다.

제 8조 포인트

1. 회사는 서비스에 대한 보상 및 이벤트 보상 차원에서 회원에게 적립금을 지급할 수 있습니다.

2. 지급한 적립금은 지급 시점부터 1년간 사용 가능합니다. 사용기간이 지난 적립금은 소멸됩니다.

3. 회원은 회사의 서비스를 구매할 때 적립금을 활용할 수 있으며, 활용한 적립금만큼 서비스에 대해 할인을 받을 수 있습니다. 적립금 액수가 서비스의 가액을 초과한 경우, 적립금만을 활용해 서비스를 제공받을 수 있습니다.

4. 적립금은 현금성 가치가 없으며, 현금으로 환급 받을 수 없습니다.

5. 회사 서비스 종료 시 적립금도 함께 소멸됩니다.

6. 회사가 서비스를 더 이상 제공할 수 없어 이용자가 적립금을 활용할 수 없는 경우에도, 적립금에 대한 보상은 이뤄지지 않습니다.

7. 적립금이 회사의 착오 혹은 잘못된 정보로 인해 오지급된 경우, 회사는 적립금을 회수할 수 있습니다.

8. 이용자가 적절하지 않은 방식으로 적립금을 적립한 경우, 회사는 적립금을 회수할 수 있습니다.

9. 적립금의 양도는 불가하며, 적립금은 적립금이 발행된 ID에서만 사용할 수 있습니다.

제 9조 환불

1. 이용자는 서비스에 대해 환불을 요청할 수 있습니다. 환불 규정은 아래 각 호와 같습니다.

① 수업시작 12시간 전 : 전액 환불

② 수업시작 7일 이내: 기 납입한 이용료 7일치를 제외한 금액 환불

③ 수업 시작 7일이 지난 이후: 반환하지 아니함

2. 적립금은 현금성이 없으므로 어떠한 경우에도 현금으로 지급하지 않습니다. 적립금은 적립 이후 최대한 빠른 시일 내에 사용하는 것을 권장합니다.

제 10조 잔여수업의 보존 및 소멸

2. 수업 홀드 이후 잔여 수업은 수업 홀드 이전 마지막 수업 이후 1년간 유효합니다.

3. 잔여 수업은 유효기간 이후 소멸되며, 이에 대한 보상은 이뤄지지 않습니다.

제 11조 지적재산권

1. 회사는 회사가 운영하는 모든 플랫폼에서 제공하는 것에 대한 저작권 등 모든 권리를 소유합니다.

2. 교재를 포함하여 회사의 재산을 상업적으로 이용하고자 하는 경우, 적법한 경로로 회사의 승인을 받아야 합니다.

제 12조 이용자의 의무

1. 이용자는 아래 각 항의 항목의 행위를 하여서는 안 되며, 이용자가 의무를 위반하는 경우에는 회사는 이용자의 서비스 이용 자격을 제한할 수 있습니다.

① 회사의 웹사이트에 과도한 트래픽을 발생시켜 회사에 손해를 발생시키는 행위

② 회원가입 및 수강신청 시 고의로 잘못된 정보를 기입하는 행위

③ 회사의 웹 서비스 및 어플리케이션을 회사가 의도하지 않은 방식으로 활용하는 행위

④ 회사 및 타인의 지식재산권 및 초상권을 침해하는 행위

⑤ 서비스를 이용하는 전반적인 과정에서 외설적인 언행, 욕설, 다른 업체에 대한 홍보 등 사회 통념에 어긋나는 행위

⑥ 녹화한 수업을 상대방 및 회사의 동의 없이 공공 포털에 게시하는 행위

⑦ 기타 회사에 손해를 발생시키는 행위

제 13조 면책사항

1. 회사는 국가 재난, 천재지변, 혹은 이에 준하는 불가항력으로 인해 서비스 제공을 할 수 없는 경우에 이로 발생한 손해에 대한 책임이 면제됩니다.

2. 회사는 이용자의 귀책사유로 인해 발생한 손해에 대해 책임이 면제됩니다.

3. 회사는 회사가 제공하는 컨텐츠에 대한 정확성을 보장하지 않습니다. 이로 인해 발생한 손해에 대해 회사는 책임을 지지 않습니다.

4. 회사는 회사가 운영하는 플랫폼 내에서 이용자간 발생한 분쟁에 대해 책임을 지지 않습니다.

제 14조 분쟁의 해결

1. 회사와 이용자 간에 발생한 분쟁에 관한 소송은 한국법을 적용합니다.

2. 회사와 이용자 간에 발생한 분쟁에 대한 소는 회사 소재지의 관할법원에 제기합니다.

본 이용 약관은 2024년 5월 6일부터 시행됩니다.
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
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: SignupScreen.check3,
                        onChanged: ((value) {
                          setState(
                            () {
                              SignupScreen.check3 = value!;
                            },
                          );
                        }),
                      ),
                      const Text('[선택] 딸기영어 헤택, 이벤트 등 소식 받아보기'),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              color: Colors.white,
                              child: Scrollbar(
                                controller: scrollController,
                                interactive: true,
                                thumbVisibility: true,
                                child: Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Text("""
목적: 딸영어 할인 혜택, 이벤트 정보, 신규 서비스 안내 등 마케팅용 정보 발송

항목: 이메일 주소

보유 및 이용 기간: 이용자의 동의 철회 시까지
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
