import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TopicsScreen1Announcement extends StatelessWidget {
  final String videoId = 'f8aIT__EL70'; // TODO: youtube 영상 ID 추가

  const TopicsScreen1Announcement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Theme(
      data: customTheme,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ((screenWidth - 1000) / 2).clamp(20, double.nan),
          vertical: 50.0,
        ),
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: const Markdown(
            shrinkWrap: true,
            data: """
### * 딸기영어는 스피킹 능력 향상에 집중하고 있습니다.
해당 토픽은 레벨에 따라 나눠진 것이 아니라  
학생분들의 공부 목적에 따라 토픽을 선택하시면 레벨에 맞춰 수업이 진행되겠습니다.  
 
#  
#  
#  
#  
## 1️⃣ **스피킹 스킬**  
    
   **Structured Speaking**  
    
- Grammar, Pronunciations, Expressions, Idioms  
- 문장 구조를 만드는 것이 어렵고 기초를 잡기 원하는 초보자 혹은 좀 더 논리적이고 전문적인 스피킹을 원하는 중, 고급 학생에게 추천!  
   
    
   **Business English**  
- Office Expressions, Business Expressions, Business meetings and presentations, etc.  
- 비즈니스 미팅 예절, 프레젠테이션 같은 업무적인 용어를 배우고 커리어 하이를 찍고 싶은 비즈니스 맨 & 워먼에게 추천!  

    
   **Power/Fluency**  
- Free Conversational class  
- 부담 없이 기초적인 일상 대화를 원화는 초보자 혹은 스피킹 능력 유지와 본인의 생각을 자유롭게 이야기하는 토론식 수업을 원하는 중, 고급 학생에게 추천  

 
#  
#  
#  
#  
## 2️⃣ **주니어 스피킹**  
    
   **Kids English**  
    
- Reading, Speaking, and Comprehension  
- 3~15세 기초 주니어 학생에게 추천!  

   
#  
#  
#  
#  
## 3️⃣ **어학시험**  
   
- IELTS Speaking  
- TOEIC Speaking  
- OPIC  
"""
//
// #
// #
// #
// #
// 딸기영어는 학습자가 영어 공부를 학업이 아닌 소통의 즐거움으로 느끼게 하는 데 목표를 두고 있습니다.
// 학생 수준에 맞게 세션을 진행할 때, 영어를 친근하게 받아들인다고 믿습니다.
// 딸기영어는 여타의 문법 교정과 학습 진도 중심의 수업이 아닌 1:1 맞춤형 수업을 통해 영어를 즐겁게 배울 수 있도록 프로그램을 구성하고 있습니다.

//
// #
// #
// #
// #
// ## 1️⃣ **스피킹 능력 향상**
// ## 1. Structured Speaking은 말의 구조를 스스로 구상할 수 있도록 문법과 숙어 표현 향상에 집중된 수업입니다.

// ✅기초회화 스피킹 – 일상생활에서 자주 사용하는 핵심 어휘와 표현을 익혀서 평소에서 영어를 자연스럽게 써먹을 수 있는 왕초보를 위한 수업

// ✅프레젠테이션 스피킹 – 제한 시간 안에 논리적으로 자신의 생각을 이야기할 수 있도록 돕는 수업

// ✅원서 리딩 스피킹 – 다양한 분야의 원서를 읽으면서 표현력과 어휘력 그리고 독해력 향상을 돕는 수업

// ✅주제 토론 스피킹 – 하나의 주제를 가지고 때론 간결하고, 때론 길게 문장을 조리있게 말할 수 있도록 돕는 수업

// ## 2. Business English는 비즈니스 미팅이나 프레젠테이션 같은 업무적인 주제들을 중심으로 이루어진 수업입니다.

// ✅비즈니스 스피킹 – 일상대화, 화상회의, 메일 작성, 프레젠테이션 등 비즈니스 업무에 관련된 회화 실력을 향상시킬 수 있도록 돕는 수업

// ✅상황별 스피킹 – 가정생활, 일상생활, 취미생활, 학교생활 등 실제 마주하는 다양한 상황에서 적절한 표현법을 배우고 연습하는 수업

// ## 3. Power/Fluency는 일상생활을 하면서 경험할 수 있는 여러 상황에서 자유롭게 말하는 수업입니다.

// ✅상황별 스피킹 – 가정생활, 일상생활, 취미생활, 학교생활 등 실제 마주하는 다양한 상황에서 적절한 표현법을 배우고 연습하는 수업

// ✅주제 토론 스피킹 – 하나의 주제를 가지고 때론 간결하고, 때론 길게 문장을 조리 있게 말할 수 있도록 돕는 수업

// ✅애니메이션 스피킹 – 애니메이션에서 나타나는 가볍고 친근한 표현을 쉽게 배우는 수업.

// ✅프리토킹 스피킹 – 외국인 친구와 가까워지면서 나눌 수 있는 가벼운 주제와 수다 중심으로 영어회화를 익히는 수업

// ## 2️⃣ 주니어 스피킹
// ## Kid's English는 만 3~15세 주니어 학생을 위한 수업으로서 Speaking, Reading, and Comprehension을 재미있고 친근하게 익힐 수 있는 수업입니다.
//    아이 레벨에 맞게 아래 커리큘럼을 적절하게 적용하여 1:1 맞춤형 수업을 진행합니다.

// ✅파닉스 – 영어 알파벳과 소리의 관계를 익혀 스펠링만 보고도 정확하게 발음할 수 있도록 돕는 수업

// ✅애니메이션 스피킹 – 애니메이션을 보면서 부담 없이 영어회화를 시작하도록 돕는 수업

// ✅상황별 스피킹 – 가정생활, 일상생활, 취미생활, 학교생활 등 실제 마주하는 다양한 상황에서 적절한 표현법을 배우고 연습하는 수업

// ✅원서리딩 스피킹 – 다양한 분야의 원서를 읽으면서 표현력과 어휘력 그리고 독해력 향상을 돕는 수업

// ✅주제 토론 스피킹 – 하나의 주제를 가지고 때론 간결하고, 때론 길게 문장을 조리있게 말할 수 있도록 돕는 수업

// 딸기영어 프로그램은 공통적으로 주제별 아티클을 가지고 자신의 생각을 자유롭고 자신있게 이야기하는 토론식 수업을 지향합니다.
// 때로는 픽션과 논픽션 등 장르 불문의 책을 읽고 자신의 생각을 나누는 밀도 있는 수업도 진행하고 있습니다.
// 모든 프로그램의 궁극적인 목표는 하나입니다. 영어회화를 부담이 아닌 재미로 느끼는 것입니다.
            ,
          ),
        ),
      ),
    );
  }
}
