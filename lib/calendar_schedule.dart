import 'package:flutter/material.dart';
import 'package:neis_api/schedule/schedule.dart';
import 'package:neis_api/school/school.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendar extends StatefulWidget {
  final School school;
  ScheduleCalendar(this.school);

  @override
  State<StatefulWidget> createState() => ScheduleCalendarState(school);
}

class ScheduleCalendarState extends State<ScheduleCalendar> {
  final School school;
  String locale;
  String selectedSchedule;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime now;
  bool scheduleValid;
  List<Schedule> schedules;
  Future<List<Schedule>> schedule;

  ScheduleCalendarState(this.school);

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _selectedDay = now;
    selectedSchedule = "학사일정을 불러오는 중입니다.";
    schedule = school.getMonthlySchedule(now.year, _selectedDay.month);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        selectedSchedule = schedules[selectedDay.day - 1].schedule;
        scheduleValid = false;
        if (schedules[selectedDay.day - 1].schedule != '학사일정이 없는 것 같아요 :)') {
          scheduleValid = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("학사일정"),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ko-KR',
            firstDay: DateTime(now.year, 1, 1),
            lastDay: DateTime(now.year, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
              setState(
                () {
                  schedule = school.getMonthlySchedule(
                    now.year,
                    focusedDay.month,
                  );
                },
              );
            },
          ),
          FutureBuilder(
            future: schedule,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print("mth: ${_focusedDay.month}");
                schedules = snapshot.data;
                final Map<DateTime, List> _schedules = {};
                for (var i = 0; i < schedules.length; i++) {
                  if (schedules[i].schedule != "학사일정이 없는 것 같아요 :)") {
                    _schedules[DateTime(
                        _focusedDay.month, _focusedDay.month, i + 1)] = [
                      schedules[i].schedule
                    ];
                  }
                }

                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      padding: EdgeInsets.all(18),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Theme.of(context).highlightColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(selectedSchedule == "학사일정을 불러오는 중입니다."
                                ? schedules[_focusedDay.day - 1].schedule
                                : selectedSchedule),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
