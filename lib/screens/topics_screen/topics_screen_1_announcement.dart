import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class TopicsScreen1Announcement extends StatelessWidget {
  final String videoId = 'gVtH8X8peZk'; // TODO: youtube 영상 ID 추가

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
""",
          ),
        ),
      ),
    );
  }
}
