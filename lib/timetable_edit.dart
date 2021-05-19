import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class TimeTableEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimeTableEditState();
}

class TimeTableEditState extends State<TimeTableEdit> {
  var _selectedSubject;
  var _selectedTeacher;
  var _selectedDay;
  var _selectedStartPeriod;
  var _selectedEndPeriod;
  @override
  Widget build(BuildContext context) {
    List<String> subjects = ['미적분', '물리', '기하'];
    List<String> teachers = ['박지혜', '김정훈', '황영연'];
    List days = [0, 1, 2, 3, 4];
    List periods = [
      {"id": 0, "text": "월요일"},
      {"id": 1, "text": "화요일"},
      {"id": 2, "text": "수요일"},
      {"id": 3, "text": "목요일"},
      {"id": 4, "text": "금요일"}
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("시간표 수정"),
          ],
        ),
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: Column(
        children: [
          Text("과목명: "),
          SearchableDropdown.single(
            hint: "과목을 선택해주세요.",
            value: _selectedSubject,
            items: subjects.map((e) {
              return DropdownMenuItem(child: Text(e), value: e);
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubject = value;
              });
            },
          ),
          Text("교사: "),
          SearchableDropdown.single(
            hint: "선택해주세요.",
            value: _selectedTeacher,
            items: teachers.map((e) {
              return DropdownMenuItem(child: Text(e), value: e);
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTeacher = value;
              });
            },
          ),
          Text("요일: "),
          DropdownButton(
            hint: Text(_selectedDay.toString()),
            value: _selectedDay,
            items: periods.map((e) {
              return DropdownMenuItem(child: Text(e['text']), value: e['id']);
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDay = value;
              });
              print(value);
              //print(_selectedDay);
            },
          ),
          Text("교시: "),
          Row(
            children: [
              SearchableDropdown.single(
                hint: "선택해주세요.",
                value: _selectedSubject,
                items: subjects.map((e) {
                  return DropdownMenuItem(child: Text(e), value: e);
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              ),
              DropdownButton(
                hint: Text("선택해주세요."),
                value: _selectedSubject,
                items: subjects.map((e) {
                  return DropdownMenuItem(child: Text(e), value: e);
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value;
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
