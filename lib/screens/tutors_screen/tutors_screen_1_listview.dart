import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorsScreen1Listview extends StatelessWidget {
  final String videoId = 'gVtH8X8peZk'; // TODO: youtube 영상 ID 추가
  const TutorsScreen1Listview({
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
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) =>
              Container(height: 1.5, color: Colors.grey[300]),
          itemCount: 9,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0.0,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                // tileColor: Colors.white,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/logo.jpg',
                      width: 200,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "★ 4.9",
                            style: TextStyle(
                              color: customTheme.colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Diago D.",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "English Education Lv2 License",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            """
Hi, I'm Stephanie! I'm from New Hampshire, United States and I'm a Ph. D. student, English teacher and researcher/instructor of Hispanic Literature. I've been teaching English as a Second Language for 8 years, both in-person and online.
🌵 I have lived in Argentina for the last 8 years.
Why choose Stephanie S.
"Stephanie is an outstanding teacher; I thoroughly enjoy my classes with her. She treats me with utmost respect and friendliness, making each session both comfortable and engaging. Furthermore, her extensive educational background has endowed her with a diverse vocabulary, enriching our discussions. Her prompt corrections help me improve effectively. As each class draws to a close, I eagerly anticipate the next session with her."
""",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton(
                          //     child: const Text('더보기'),
                          //     onPressed: () {
                          //       // TODO : 더보기 클릭 시 동작
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // const SizedBox(width: 16),
                  ],
                ),
                children: [
                  Container(
                    color: Colors.grey.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 450,
                            height: 450 / 16 * 9,
                            child: SfCalendar(
                              view: CalendarView.week,
                              showNavigationArrow: true,
                              // dataSource: _getCalendarDataSource(),
                              // controller: _calendarController,
                              showDatePickerButton: true,
                              headerDateFormat: 'yyyy년 M월', // 원하는 형식으로 지정
                              todayHighlightColor: const Color(0xfffcc021),
                              monthViewSettings: const MonthViewSettings(
                                agendaItemHeight: 50,
                                agendaViewHeight: 60,
                                appointmentDisplayMode:
                                    MonthAppointmentDisplayMode.appointment,
                                appointmentDisplayCount: 1,
                                showTrailingAndLeadingDates: false,
                                agendaStyle: AgendaStyle(
                                  appointmentTextStyle:
                                      TextStyle(fontSize: 15.0),
                                  backgroundColor:
                                      Color.fromARGB(255, 246, 246, 246),
                                ),
                                showAgenda: true,
                                navigationDirection:
                                    MonthNavigationDirection.horizontal,
                                monthCellStyle: MonthCellStyle(
                                  backgroundColor:
                                      Color.fromARGB(255, 246, 246, 246),
                                  todayBackgroundColor:
                                      Color.fromARGB(255, 246, 246, 246),
                                ),
                              ),
                              // onTap: _buildOnTapWidget,
                            ),
                          ),
                          SizedBox(
                            width: 450,
                            child: YoutubePlayer(
                              aspectRatio: 16 / 9,
                              controller: YoutubePlayerController.fromVideoId(
                                videoId: videoId,
                                autoPlay: false,
                                params: const YoutubePlayerParams(
                                    showFullscreenButton: true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
