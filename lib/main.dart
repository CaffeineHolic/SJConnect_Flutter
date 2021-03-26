import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjconnect/idcard.dart';
import 'NEIS/meal/meal.dart';
import 'NEIS/schedule/schedule.dart';
import 'components/card.dart';
import 'tools/dialogs.dart';

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
    setupPref().then(
      (value) {
        prefs = value;
        debugPrint(
          prefs.getString('IdCode'),
        );
      },
    );
  }

  Future<SharedPreferences> setupPref() async {
    return await SharedPreferences.getInstance();
  }

  void saveBarcode(String barcodeRes) async {
    prefs.setString("IdCode", barcodeRes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: null,
            iconSize: 30,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: null,
            iconSize: 30,
          ),
        ],
      ),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/profile.png",
                                width: 50,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Text(
                                  '이상설',
                                  style: TextStyle(fontSize: 28),
                                ),
                              )
                            ],
                          ),
                          Builder(
                            builder: (context) => ElevatedButton(
                              child: Text("전자학생증"),
                              onPressed: () {
                                if (prefs.getString('IdCode') == null) {
                                  okOnlyDialog(
                                    context,
                                    "학생증 등록",
                                    "학생증이 등록되어 있지 않습니다.\n등록 절차를 진행합니다.",
                                    () async {
                                      final barcodeRes =
                                          await FlutterBarcodeScanner
                                              .scanBarcode("#000000", '취소',
                                                  true, ScanMode.BARCODE);
                                      saveBarcode(barcodeRes);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => IdCardPage(),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  showBottomSheet(
                                      context: context,
                                      builder: (context) => Container(
                                            child: IdCardPage(),
                                          ),
                                      backgroundColor: Colors.transparent);
                                  /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IdCardPage(),
                                  ),
                                );*/
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 50,
                      thickness: 0.8,
                      indent: 10,
                      endIndent: 10,
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
                      },
                    ),
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
                      },
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
