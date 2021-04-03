//TODO: 다른 달 선택 구현
import 'package:flutter/material.dart';
import 'package:sjconnect/NEIS/meal/meal.dart';
import 'package:sjconnect/components/card.dart';
import 'package:table_calendar/table_calendar.dart';

class MealCalendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MealCalendarState();
}

class MealCalendarState extends State<MealCalendar> {
  CalendarController calendarController;
  String locale;
  String selectedMeal;
  int selectedDay;
  int currentIdx;
  DateTime now;
  Future<List<Meal>> _mealFuture;
  List<Meal> meals;
  List<bool> mealValid = [false, false, false];

  @override
  void initState() {
    super.initState();
    currentIdx = 0;
    now = DateTime.now();
    _mealFuture = fetchMeals();
    selectedMeal = "급식을 불러오는 중입니다.";
    calendarController = CalendarController();
  }

  @override
  void dispose() {
    calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime date, List events, List holidays) => setState(
        () {
          selectedDay = date.day;
          selectedMeal = meals[date.day - 1].breakfast;
          mealValid = [false, false, false];
          if (meals[date.day - 1].breakfast != '급식이 없는 것 같아요 :(') {
            mealValid[0] = true;
          } else if (meals[date.day - 1].lunch != '급식이 없는 것 같아요 :(') {
            mealValid[1] = true;
          } else if (meals[date.day - 1].dinner != '급식이 없는 것 같아요 :(') {
            mealValid[2] = true;
          }
        },
      );

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
          FutureBuilder(
            future: _mealFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                meals = snapshot.data;
                selectedMeal = snapshot.data[DateTime.now().day - 1].breakfast;
                return Container();
              }
              return CircularProgressIndicator();
            },
          ),
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
                  child: Text(selectedMeal),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        selectedItemColor: Theme.of(context).hintColor,
        unselectedItemColor: Theme.of(context).accentColor,
        onTap: (selectedIdx) => setState(
          () {
            debugPrint(selectedDay.toString());
            currentIdx = selectedIdx;

            switch (selectedIdx) {
              case 0:
                selectedMeal = meals[selectedDay - 1].breakfast;
                break;
              case 1:
                selectedMeal = meals[selectedDay - 1].lunch;
                break;
              case 2:
                selectedMeal = meals[selectedDay - 1].dinner;
                break;
            }
          },
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.brightness_7_sharp,
            ),
            label: "조식",
          ),
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
