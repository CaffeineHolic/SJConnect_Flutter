import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');

class Meal {
  final String mealName;
  final String meal;

  Meal({this.meal, this.mealName});

  factory Meal.fromJson(Map<String, dynamic> json) {
    var mealName = '';
    switch (int.parse(json['MMEAL_SC_CODE'])) {
      case 1:
        mealName = "오늘의 아침";
        break;
      case 2:
        mealName = "오늘의 점심";
        break;
      case 3:
        mealName = "오늘의 저녁";
    }
    if (now.hour >= 19 && now.hour < 24) {
      mealName = "내일의 아침";
    }
    return Meal(
        meal: json['DDISH_NM']
            .replaceAll(new RegExp(r"[0-9.*]"), "")
            .replaceAll('<br/>', "\n"),
        mealName: mealName);
  }
}

Future<Meal> fetchMeal() async {
  String formatted = formatter.format(now);
  var mealCode;
  if (now.hour >= 19 && now.hour < 24) {
    // 내일 오전 급식
    mealCode = 1;
    formatted = formatter.format(now.add(Duration(days: 1)));
  } else if (now.hour >= 9 && now.hour < 14) {
    mealCode = 2;
  } else if (now.hour >= 15 && now.hour < 19) {
    mealCode = 3;
  } else if (now.hour >= 0 && now.hour < 9) {
    mealCode = 1;
  }
  final res = await http.get(Uri.parse(
      "https://open.neis.go.kr/hub/mealServiceDietInfo?ATPT_OFCDC_SC_CODE=M10&MMEAL_SC_CODE=$mealCode&SD_SCHUL_CODE=8000376&Type=json&KEY=76ebe67f34c44b7ba5c10ac9f3b4060e&MLSV_FROM_YMD=$formatted&MLSV_TO_YMD=$formatted"));
  if (res.statusCode == 200) {
    return Meal.fromJson(
        json.decode(res.body)['mealServiceDietInfo'][1]['row'][0]);
  } else {
    throw Exception('Failed..;');
  }
}
