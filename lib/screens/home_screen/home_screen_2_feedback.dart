import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:strawberryenglish/themes/my_theme.dart';

class HomeScreen2Feedback extends StatefulWidget {
  HomeScreen2Feedback({super.key});
  final CarouselController controller = CarouselController();

  @override
  State<HomeScreen2Feedback> createState() => _HomeScreen2FeedbackState();
}

class _HomeScreen2FeedbackState extends State<HomeScreen2Feedback> {
  Map<String, Map<String, dynamic>> data = {};

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("feedback");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        data = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            MouseRegion(
              onEnter: (_) {
                widget.controller.stopAutoPlay();
              },
              onExit: (_) {
                widget.controller.startAutoPlay();
              },
              child: CarouselSlider.builder(
                carouselController: widget.controller,
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  viewportFraction: 400 / screenWidth,
                  // enlargeCenterPage: true,
                  // enlargeFactor: 0.2,
                  enableInfiniteScroll: true,
                ),
                itemCount: data.length,
                itemBuilder: (context, index, _) {
                  if (data.isEmpty) return const Text('리뷰를 읽는 중입니다.');
                  var id = data.keys.elementAt(index);
                  var doc = data[id];
                  return SizedBox(
                    width: 300, // 각 카드의 너비 조절
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16), // 내부 여백 설정
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "$id 학생 후기",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                doc!['body'].join('\n\n'),
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: const Text('더보기'),
                                onPressed: () {
                                  // 더보기 클릭 시 동작
                                  Navigator.pushNamed(context, '/feedbacks')
                                      .then((_) => setState(() {}));
                                  // TODO: 해당 리뷰 위치로 이동 및 펼치기
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
              onTap: () {
                // 더보기 클릭 시 동작
                Navigator.pushNamed(context, '/feedbacks');
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 7,
                        width: 200,
                        decoration: BoxDecoration(
                          color: customTheme.colorScheme.secondary
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    ' ✔ 딸기후기 바로가기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
