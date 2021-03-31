import 'package:flutter/material.dart';
import 'package:sjconnect/NEIS/meal/meal.dart';
import 'package:table_calendar/table_calendar.dart';

class MealCalendar extends StatefulWidget {
  final meal;

  const MealCalendar({Key key, this.meal}) : super(key: key);
  @override
  State<StatefulWidget> createState() => MealCalendarState(meal: meal);
}

class MealCalendarState extends State<MealCalendar> {
  CalendarController calendarController;
  String locale;
  String selectedMeal;
  DateTime selectedDay;

  final meal;
  MealCalendarState({this.meal});

  @override
  void initState() {
    calendarController = CalendarController();
    setState(() {
      selectedMeal = meal[now.day - 1].breakfast;
    });
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    setState(() {
      selectedDay = day;
      selectedMeal = meal[day.day - 1].breakfast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("급식"),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarController: calendarController,
            locale: 'ko-KR',
            events: {},
            onDaySelected: _onDaySelected,
          ),
          Container(
            child: Text(selectedMeal),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.wb_sunny), label: "조식"),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_6_sharp), label: "중식"),
          BottomNavigationBarItem(icon: Icon(Icons.brightness_2), label: "석식"),
        ],
      ),
    );
  }
}

class ScheduleCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScheduleCalendarState();
}

class ScheduleCalendarState extends State<ScheduleCalendar> {
  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: Container(),
    );
  }
}
