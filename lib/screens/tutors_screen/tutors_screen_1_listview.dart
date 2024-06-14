import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strawberryenglish/themes/my_theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorsScreen1Listview extends StatefulWidget {
  TutorsScreen1Listview({
    super.key,
  });

  final List<bool> controllers = [];

  @override
  State<TutorsScreen1Listview> createState() => _TutorsScreen1ListviewState();
}

class _TutorsScreen1ListviewState extends State<TutorsScreen1Listview> {
  Map<String, Map<String, dynamic>> data = {};

  Future<dynamic> getData() async {
    final collection = FirebaseFirestore.instance.collection("tutors");

    await collection
        .get()
        .then<void>((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      setState(() {
        data = {
          for (var doc in snapshot.docs) doc.id: doc.data(),
        };
        for (var _ in data.keys) {
          widget.controllers.add(false);
        }
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
          itemCount: data.length,
          itemBuilder: (context, index) {
            // name, score, license, body, calendar, youtube
            var id = data.keys.elementAt(index);
            var doc = data[id]!;

            var name = doc['name'];
            var score = doc['score'];
            var license = doc['license'];
            var body = doc['body'].join('\n\n');
            var calendar = doc['calendar'];
            var youtube = doc['youtube'];

            return Card(
              elevation: 0.0,
              child: ExpansionTile(
                // initiallyExpanded: widget.controllers[index],
                // controller: widget.controllers[index],
                tilePadding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 10,
                ),
                onExpansionChanged: (bool expanded) {
                  // Add this
                  setState(() {
                    widget.controllers[index] = expanded;
                  });
                },
                // tileColor: Colors.white,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/tutors/$name.png',
                      width: 200,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "★ $score",
                            style: TextStyle(
                              color: customTheme.colorScheme.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            license,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            body,
                            overflow: TextOverflow.ellipsis,
                            maxLines: widget.controllers[index] ? 100 : 3,
                          ),
                        ],
                      ),
                    ),
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
                          // calendar
                          SizedBox(
                            width: 450,
                            height: 450 / 16 * 9,
                            child: SfCalendar(
                              view: CalendarView.workWeek,
                              showNavigationArrow: true,
                              dataSource: _getCalendarDataSource(calendar),
                              // controller: _calendarController,
                              showDatePickerButton: true,
                              headerDateFormat: 'yyyy년 M월 ', // 원하는 형식으로 지정
                              todayHighlightColor: const Color(0xfffcc021),
                              timeSlotViewSettings: const TimeSlotViewSettings(
                                startHour: 8,
                                timeIntervalHeight: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 450,
                            child: YoutubePlayer(
                              aspectRatio: 16 / 9,
                              controller: YoutubePlayerController.fromVideoId(
                                videoId: youtube,
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

  CalendarDataSource _getCalendarDataSource(calendar) {
    List<Appointment> appointments = [];

    for (Timestamp time in calendar) {
      var date = time.toDate();
      appointments.add(
        Appointment(
          startTime: date,
          endTime: date.add(const Duration(minutes: 29)),
          color: Colors.grey,
        ),
      );
    }
    return MyDataSource(appointments);
  }
}

class MyDataSource extends CalendarDataSource {
  MyDataSource(List<Appointment> source) {
    appointments = source;
  }
}
