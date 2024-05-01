import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen2Feedback extends StatelessWidget {
  final CarouselController controller = CarouselController();

  HomeScreen2Feedback({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: MouseRegion(
          onEnter: (_) {
            controller.stopAutoPlay();
          },
          onExit: (_) {
            controller.startAutoPlay();
          },
          child: CarouselSlider(
            carouselController: controller,
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
            items: [1, 2, 3, 4, 5].map((int index) {
              return Builder(builder: (BuildContext context) {
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
                            '후기 제목 $index', // 후기 제목
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Expanded(
                            child: Text(
                              '여기에 후기 내용이 들어갑니다. 후기 내용이 길 경우 여기에서 줄여서 보여줄 수 있습니다.',
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: const Text('더보기'),
                              onPressed: () {
                                // TODO : 더보기 클릭 시 동작
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ),
      ),
    );
  }
}
