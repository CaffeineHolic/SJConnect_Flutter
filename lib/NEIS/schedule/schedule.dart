import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');

class Schedule {
  final String schedule;

  Schedule({this.schedule});
  factory Schedule.fromJson(Map<String, dynamic> json) {
    String scheduleString = '';
    for (int i = 0; i < json['row'].length; i++) {
      if (i == json['row'].length - 1) {
        scheduleString += (json['row'][i]['EVENT_NM']);
      } else {
        scheduleString += (json['row'][i]['EVENT_NM'] + "\n");
      }
    }
    return Schedule(schedule: scheduleString);
  }
}

Future<Schedule> fetchSchedule() async {
  String firstDayOfMonth = formatter.format(DateTime(now.year, now.month, 1));
  String endOfMonth = formatter.format(DateTime(now.year, now.month + 1, 0));
  debugPrint(firstDayOfMonth + ", " + endOfMonth);
  final res = await http.get(Uri.parse(
      'https://open.neis.go.kr/hub/SchoolSchedule?ATPT_OFCDC_SC_CODE=M10&SD_SCHUL_CODE=8000376&Type=json&AA_FROM_YMD=20210301&AA_TO_YMD=20210321'));
  if (res.statusCode == 200) {
    return Schedule.fromJson(json.decode(res.body)['SchoolSchedule'][1]);
  } else {
    throw Exception("Failed..");
  }
}
