//TODO: 다른 달 선택 구현
import 'package:flutter/material.dart';
import 'package:neis_api/meal/meal.dart';
import 'package:neis_api/school/school.dart';
import 'package:table_calendar/table_calendar.dart';

class MealCalendar extends StatefulWidget {
  final School school;

  MealCalendar(this.school);

  @override
  State<StatefulWidget> createState() => MealCalendarState(school);
}

class MealCalendarState extends State<MealCalendar> {
  final School school;
  String locale;
  String selectedMeal;
  // Calendar init
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  DateTime now;

  int currentIdx;

  List<bool> mealValid = [false, false, false];
  List<Meal> meals;

  Future<List<Meal>> meal;

  MealCalendarState(this.school);

  @override
  void initState() {
    super.initState();
    currentIdx = 0;
    now = DateTime.now();
    _selectedDay = now;
    selectedMeal = "급식을 불러오는 중입니다.";
    meal = school.getMonthlyMeal(now.year, _selectedDay.month);
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
        switch (currentIdx) {
          case 0:
            selectedMeal = meals[selectedDay.day - 1].breakfast;
            break;
          case 1:
            selectedMeal = meals[selectedDay.day - 1].lunch;
            break;
          case 2:
            selectedMeal = meals[selectedDay.day - 1].dinner;
            break;
        }
        mealValid = [false, false, false];
      });

      if (meals[selectedDay.day - 1].breakfast != '급식이 없는 것 같아요 :(') {
        mealValid[0] = true;
      } else if (meals[selectedDay.day - 1].lunch != '급식이 없는 것 같아요 :(') {
        mealValid[1] = true;
      } else if (meals[selectedDay.day - 1].dinner != '급식이 없는 것 같아요 :(') {
        mealValid[2] = true;
      }
    }
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
              setState(() {
                meal = school.getMonthlyMeal(
                  now.year,
                  focusedDay.month,
                );
              });
            },
          ),
          FutureBuilder(
            future: meal,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                meals = snapshot.data;
                return SingleChildScrollView(
                  child: Container(
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
                          child: Text(selectedMeal == "급식을 불러오는 중입니다."
                              ? meals[now.day - 1].breakfast
                              : selectedMeal),
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
        selectedItemColor: Theme.of(context).hintColor,
        unselectedItemColor: Theme.of(context).accentColor,
        onTap: (selectedIdx) => setState(
          () {
            currentIdx = selectedIdx;
            switch (selectedIdx) {
              case 0:
                selectedMeal = meals[_selectedDay.day - 1].breakfast;
                break;
              case 1:
                selectedMeal = meals[_selectedDay.day - 1].lunch;
                break;
              case 2:
                selectedMeal = meals[_selectedDay.day - 1].dinner;
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
