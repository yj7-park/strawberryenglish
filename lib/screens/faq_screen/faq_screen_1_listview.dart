import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class FaqScreen1Listview extends StatelessWidget {
  const FaqScreen1Listview({
    super.key,
  });

  static const Map<String, String> faqMap = {
    "1. 트라이얼 수업은 어떻게 진행 되나요?": """
무료 트라이얼 신청을 하시면 스케줄 확정 후 카톡 채널을 통해 안내드립니다.

트라이얼 수업은 20분간 진행되며 레벨 테스트로 진행되어 정규 수업과 수업 방식과는 다릅니다.
트라이얼 신청 시, 수업 가능 시간대를 여러개 주시면 트라이얼 진행이 수월하겠습니다!""",
    "2. 정규 수업 등록은 어떻게 하나요?": """
딸기영어 회원가입 후 홈페이지 상단 '수강신청'을 누르시면 정규수업 신청이 가능합니다.

정규수업에 대한 문의는 카톡 상담(카카오톡 채널: 딸기영어(http://pf.kakao.com/_aSqxeT)으로 상담받으실 수 있습니다.
상담 가능시간은 평일 오전 9시부터 오후 5시까지이며, 상담시간 외 상담건은 다음 업무시간에 진행됩니다.""",
    "3. 가능 수업 시간대는 어떻게 되나요?": """
수강 가능 시간은 오전 7시 00분(한국시간) 부터 오전 12시 00분(한국시간) 까지 수업이 진행되지만
튜터분들에 따라 수업 가능시간이 달라질 수 있겠습니다.
오전 수업을 하다 저녁 수업으로 변경 시, 튜터분도 변경 될 수 있는 점 양해 부탁 드립니다.""",
    "4. 개인 사정으로 수업 연기(취소)가 가능한가요?": """
수업 시작 *12시간 전에* 마이페이지에서 취소 신청 할 수 있으며 취소 신청 시 자동으로 수업 종료 일정이 연기됩니다.

취소 횟수 및 수업 중지 가능 횟수는 구독 기간과 주 수업 횟수에 따라 아래와 같습니다.

>>1개월 구독<<
주 2회 수업: 2회 수업 취소 / 1회 수업 중지
주 3회 수업: 3회 수업 취소 / 1회 수업 중지
주 5회 수업: 5회 수업 취소 / 1회 수업 중지

>>3개월 구독<<
주 2회 수업: 5회 수업 취소 / 3회 수업 중지
주 3회 수업: 7회 수업 취소 / 3회 수업 중지
주 5회 수업: 12회 수업 취소 / 3회 수업 중지""",
    "5. 수강증, 영수증을 발급 받을 수 있나요?": """
영수증과 수강증, 출석증 발급이 가능합니다. 카톡상담으로 요청해주세요.""",
    "6. 수업시간에 선생님과 연락되지 않는 경우에는 어떻게 하나요?": """
드물지만 담당 강사의 실수나 인터넷 문제 등으로 이 같은 경우가 발생할 수 있습니다.
만약 수업시간이 되었는데도, 담당강사의 연락이 없다면, 되도록 빨리 카톡으로 연락을 주시기 바랍니다.

강사 측의 책임으로 당일 수업을 받지 못했을 경우, 수업은 연기 처리가 되며 보상 적립금 3000포인트가 적립됩니다.
만약, 상담시간 이후 연락을 주시면 1영업일 이후 도움드리도록 하겠습니다.""",
    "7. 교재가 있나요?": """
네, 저희는 수업을 위해 다양한 교재가 사용 되고 있습니다.
트라이얼을 통해 학생의 레벨을 평가 한 후 요청하시는 토픽에 맞춰 수업 교재를 선정하여 수업을 진행합니다.

수업 교재로는 튜터분의 판단에 따라 학습교재가 아닌 Article 혹은 Case Study를 가지고 토론 형식의 수업도 될 수 있겠습니다.
무엇보다도 학생분들의 성향과 관심사에 맞게 맞춤형 진행을 지향하고 있기에 소통을 통해 수업 방식을 맞춰갈 수 있겠습니다.""",
    "8. 필리핀 튜터 발음은 괜찮나요?": """
타사 대비 높은 임금과 근무 여건을 보장하며 수 많은 지원자들 중 최고의 튜터만을 뽑고 있습니다.
3차 스크리닝에 걸쳐 까다롭게 채용을 하기에 딸기영어 튜터분들을 만나 보신다면 필리핀 튜터에 대한 고정관념이 깨지게 될 것입니다 :)""",
    "9. 딸기영어는 왜 이렇게 저렴한가요?": """
딸기영어는 최고의 튜터분들을 뽑기 위해 높은 임금을 보장함에도 불구하고 이렇게 저렴하게 수업을 제공할 수 있는 이유는
불필요한 고정비와 마케팅비를 철저하게 제한하여 거품을 뺐기 때문입니다.

이는 창업전 타사 전화 영어를 경험하며 튜터분들의 실력이 천차만별인 것과 그에 비해 수업비가 너무 비싸 부담을 느꼈던 경험 때문에
좋은 수업을 저렴한 가격에 제공하자는 의지에서 마진을 최소화 하여 가격을 결정하게 되었습니다.

사실 사업이 처음이라 운영진 인건비나 부가세, 소득세 등과 같은 세금을 고려하지 못해 어려움이 있지만
이 역시도 많은 분들이 딸기영어를 이용하면 해결 될 문제라고 믿으며 저렴한 가격을 고수하고 있습니다!""",
    "10. 현금영수증, 세금계산서를 발급 받고 싶어요": """
1) 현금영수증 발급방법

  가상계좌 결제 시 현금영수증 발급번호를 기입해 주세요.

2) 세금계산서 발급방법

  세금계산서는 카톡상담으로 신청해 주시면 발급받으실 수 있습니다.
  사업자등록증 캡처본과 기타 비고사항을 카톡상담을 통해 보내주시면 5영업일 이내로 발행해드립니다.""",
    "11. 적립금은 어떻게 사용할 수 있나요?": """
적립금은 다음 수강료 결제 시 사용 할 수 있으며, 사용한 적립금 만큼 수강료 할인이 적용됩니다.

적립금 사용을 원하는 경우, 수업 연장 안내 시 사용 여부를 말해주시면 됩니다.
(적립금 사용 유효기간은 적립 사유 발생일로부터 1년입니다.)""",
    "12. 수업 녹화 가능한가요?": """
딸기영어는 모든 수업을 녹화하고 있습니다. 수업이 종료 된 이후 녹화된 영상이 전달 되어집니다.""",
    "13. 튜터를 바꿀 수 있나요?": """
딸기영어는 학생분들의 수업 만족도를 최우선으로 생각합니다!

튜터분 변경을 원하신다면 카카오톡 채널을 통해 말씀해 주시면 도움드리도록 하겠습니다.
시간이 다소 소요될 수 있지만 학생분과 잘 맞는 튜터분과 매칭 될 때까지 튜터 변경이 가능하겠습니다.

다음 수업 시작하기 12시간 전까지만 수업 연기나 변경이 가능하기 때문에 그 부분만 유의해 주시면 되겠습니다.
만약, 튜터분은 좋지만 수업 방식을 바꾸고 싶다면 카톡 채널로 연락을 주셔서 요청 주시면 수업 방식이 변경 될 수 있도록 조율 하겠습니다 🙂"""
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
              vertical: 50.0,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, __) =>
                  Container(height: 1.5, color: Colors.grey[300]),
              itemCount: faqMap.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.zero,
                  elevation: 0.0,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    // tileColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          faqMap.keys.elementAt(index),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: double.infinity,
                        color: Colors.grey[100],
                        child: Text(
                          faqMap.values.elementAt(index),
                          style: const TextStyle(
                            // color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
