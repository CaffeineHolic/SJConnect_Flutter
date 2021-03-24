import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjconnect/tools/emptyappbar.dart';
import 'package:sjconnect/idcard.dart';
import 'NEIS/meal/meal.dart';
import 'NEIS/schedule/schedule.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class CardWidget extends StatefulWidget {
  final String cardTitle;
  final String cardContent;
  final Color color;
  final onClick;

  const CardWidget(
      {Key key,
      @required this.cardTitle,
      @required this.cardContent,
      this.onClick,
      this.color = Colors.white})
      : super(key: key);

  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
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
                style: TextStyle(
                    fontSize: 15, color: Color(0xff909090), height: 1.15),
              ),
            ],
          ),
        ),
        onTap: widget.onClick);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final now = DateTime.now();
final formatter = DateFormat('yyyyMMdd');

class _MyHomePageState extends State<MyHomePage> {
  Future<Meal> meal;
  Future<Schedule> schedule;
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    meal = fetchMeal();
    schedule = fetchSchedule();
    setupPref().then((value) {
      prefs = value;
      debugPrint(prefs.getString('IdCode'));
    });
  }

  Future<SharedPreferences> setupPref() async {
    return await SharedPreferences.getInstance();
  }

  void saveBarcode(String barcodeRes) async {
    prefs.setString("IdCode", barcodeRes);
  }

  void _showDialog(String title, String content, okEvent) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              new TextButton(
                onPressed: okEvent,
                child: Text("확인"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: EmptyAppBar(),
      body: SingleChildScrollView(
        child: Center(
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
                      onClick: () async {
                        if (prefs.getString('IdCode') == null) {
                          _showDialog(
                              "학생증 등록", "학생증이 등록되어 있지 않습니다.\n등록 절차를 진행합니다.",
                              () async {
                            final barcodeRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                    "#000000", '취소', true, ScanMode.BARCODE);
                            saveBarcode(barcodeRes);
                          });
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IdCardPage()));
                        }
                      },
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
