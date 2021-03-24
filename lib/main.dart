import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}

class CardWidget extends StatefulWidget {
  final String cardTitle;
  final String cardContent;
  final Color color;

  const CardWidget(
      {Key key,
      @required this.cardTitle,
      @required this.cardContent,
      this.color = Colors.white})
      : super(key: key);

  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffd6d6d6)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: widget.color),
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              widget.cardTitle,
              style: TextStyle(fontSize: 18),
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
          ),
          Text(
            widget.cardContent,
            style:
                TextStyle(fontSize: 15, color: Color(0xff909090), height: 1.15),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');

Future<Meal> fetchMeal() async {
  String formatted = formatter.format(now);
  var mealCode;
  debugPrint(now.hour.toString());
  if (now.hour >= 20 && now.hour < 24) {
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
    if (now.hour >= 20 && now.hour < 24) {
      mealName = "내일의 아침";
    }
    return Meal(
        meal: json['DDISH_NM']
            .replaceAll(new RegExp(r"[0-9.*]"), "")
            .replaceAll('<br/>', "\n"),
        mealName: mealName);
  }
}

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

class _MyHomePageState extends State<MyHomePage> {
  Future<Meal> meal;
  Future<Schedule> schedule;
  @override
  void initState() {
    super.initState();
    meal = fetchMeal();
    schedule = fetchSchedule();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 28),
                      child: (Text(
                        '점심도 맛있게 먹었겠다\n열심히 공부해봐요!',
                        style: TextStyle(fontSize: 28),
                      )),
                    ),
                    CardWidget(
                      cardTitle: '전자학생증',
                      cardContent: '전자학생증을 사용해보세요!',
                      color: Color(0xFFD6EAF8),
                    ),
                    FutureBuilder(
                        future: meal,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CardWidget(
                                cardTitle: snapshot.data.mealName,
                                cardContent: snapshot.data.meal);
                          } else if (snapshot.hasError) {
                            return CardWidget(
                                cardTitle: '오늘의 급식',
                                cardContent: '급식을 불러오지 못했습니다.');
                          }
                          return CircularProgressIndicator();
                        }),
                    FutureBuilder(
                        future: schedule,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CardWidget(
                                cardTitle: '📅 이달의 학사일정',
                                cardContent: snapshot.data.schedule);
                          } else {
                            return CardWidget(
                              cardTitle: '📅 이달의 학사일정',
                              cardContent: '학사일정을 불러오지 못했습니다.',
                            );
                          }
                        }),
                    CardWidget(
                      cardTitle: '🕖 시간표',
                      cardContent: '나만의 시간표를 확인하세요.',
                    ),
                    CardWidget(
                      cardTitle: '☑️ 코로나 19 자가진단',
                      cardContent: '등교하기 전, 자가진단 했나요?',
                    ),
                    CardWidget(
                      cardTitle: '💳 H4Pay',
                      cardContent: '매점 온라인 결제 및 예약 서비스',
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
