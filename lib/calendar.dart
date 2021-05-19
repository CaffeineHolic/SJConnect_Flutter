//TODO: 다른 달 선택 구현
import 'package:flutter/material.dart';
import 'package:neis_api/meal/meal.dart';
import 'package:neis_api/school/school.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealCalendar extends StatefulWidget {
  final School school;

  MealCalendar(this.school);

  @override
  State<StatefulWidget> createState() => MealCalendarState(school);
}

class MealCalendarState extends State<MealCalendar> {
  final School school;
  CalendarController calendarController;
  String locale;
  String selectedMeal;
  int selectedDay;
  int currentIdx;
  DateTime now;
  List<bool> mealValid = [false, false, false];
  List<Meal> meals;

  MealCalendarState(this.school);

  @override
  void initState() {
    super.initState();
    currentIdx = 0;
    now = DateTime.now();
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
            future: school.getMonthlyMeal(now.year, now.month),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                meals = snapshot.data;
                selectedDay = now.day;
                return Card(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  color: Theme.of(context).errorColor,
                  child: Container(
                    padding: EdgeInsets.all(18.w),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            selectedMeal == "급식을 불러오는 중입니다."
                                ? meals[now.day - 1].breakfast
                                : selectedMeal,
                            style: TextStyle(fontSize: 15, height: 1.15),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        selectedItemColor: Colors.blue,
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
  final School school;
  ScheduleCalendar(this.school);

  @override
  State<StatefulWidget> createState() => ScheduleCalendarState(school);
}

class ScheduleCalendarState extends State<ScheduleCalendar> {
  final School school;
  ScheduleCalendarState(this.school);

  @override
  Widget build(BuildContext context) {
    Scaffold(
      body: Container(),
    );
  }
}
