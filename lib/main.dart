import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sjconnect/idcard.dart';
import 'package:sjconnect/selftestlogin.dart';
import 'package:sjconnect/settings.dart';
import 'package:sjconnect/selftest.dart';
import 'package:neis_api/school/school.dart';
import 'package:sjconnect/calendar_meal.dart';
import 'package:sjconnect/calendar_schedule.dart';
import 'package:sjconnect/timetable.dart';
import 'components/card.dart';
import 'tools/dialogs.dart';
import 'package:intl/date_symbol_data_local.dart' as locale;
import 'package:url_launcher/url_launcher.dart';

void main() async {
  await locale.initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: () => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xfff2f2f2),
          accentColor: Colors.black,
          cardColor: Colors.grey[300],
          focusColor: Colors.grey[200],
          hintColor: Colors.lightBlue[600],
          errorColor: Colors.white,
          cursorColor: Colors.grey[300],
          canvasColor: Colors.grey[400],
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          textTheme: TextTheme(
            subtitle1: TextStyle(
              // 카드 서브텍스트
              fontSize: 15,
              color: Color(0xff909090),
              height: 1.15,
            ),
            subtitle2: TextStyle(
              // 학생증 생년월일
              fontSize: 15,
              color: Colors.black,
            ),
            headline4: TextStyle(
              // 학생증 이름
              fontSize: 30,
              color: Colors.black,
            ),
          ),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.grey[900],
          accentColor: Colors.grey[300],
          cardColor: Colors.grey[850],
          focusColor: Colors.grey[800],
          errorColor: Colors.grey[800],
          cursorColor: Colors.grey[700],
          unselectedWidgetColor: Colors.grey[600],
          // hintColor: Colors.lightBlue[600],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
            subtitle1: TextStyle(
              // 카드 서브텍스트
              fontSize: 15,
              color: Color(0xffababab),
              height: 1.15,
            ),
            subtitle2: TextStyle(
              // 학생증 생년월일
              fontSize: 15.sp,
              color: Colors.black,
            ),
            headline4: TextStyle(
              // 학생증 이름
              fontSize: 30.sp,
              color: Colors.black,
            ),
          ),
        ),
        themeMode: ThemeMode.system,
        home: MyHomePage(title: 'Flutter Demo Home Page'),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget,
          );
        },
      ),
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
  final school = School(Region.CHUNGBUK, '8000376');
  SharedPreferences prefs;
  String lastSubmitDisplayed = '오늘의 자가진단 기록이 없습니다.';

  @override
  void initState() {
    super.initState();
    setupPref().then(
      (value) {
        prefs = value;
        if (prefs.getString("selfTestLastSubmit") != null) {
          var now = DateFormat('yyyy-MM-dd').format(DateTime.now());
          var nextDay = DateFormat('yyyy-MM-dd')
              .parse(prefs.getString('selfTestLastSubmit'))
              .add(Duration(days: 1));

          print(nextDay.isAfter(DateFormat('yyyy-MM-dd').parse(now)));

          if (prefs.getString('selfTestLastSubmit') == '' ||
              prefs.getString('selfTestLastSubmit') == null) {
            setState(() {
              lastSubmitDisplayed = '오늘의 자가진단 기록이 없습니다.';
            });
          } else {
            if (nextDay.isAfter(DateFormat('yyyy-MM-dd').parse(now)) == true) {
              // 현재 날짜가 다음 날이 아닌 경우
              setState(() {
                lastSubmitDisplayed = prefs.getString('selfTestLastSubmit');
              });
            } else {
              setState(() {
                lastSubmitDisplayed = '오늘의 자가진단 기록이 없습니다.';
              });
            }
          }
        }
      },
    );
  }

  Future<SharedPreferences> setupPref() async {
    return await SharedPreferences.getInstance();
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: null,
            iconSize: 30,
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
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
                              SvgPicture.asset(
                                "assets/profile.svg",
                                width: 50,
                                height: 50,
                                color: Theme.of(context).accentColor,
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
                                if (prefs.getString('IdCode') == null ||
                                    prefs.getString('IdCode') == '-1') {
                                  okOnlyDialog(
                                    context,
                                    "학생증 등록",
                                    "학생증이 등록되어 있지 않습니다.\n등록 절차를 진행합니다.",
                                    () async {
                                      final barcodeRes =
                                          await FlutterBarcodeScanner
                                              .scanBarcode(
                                        "#000000",
                                        '취소',
                                        true,
                                        ScanMode.BARCODE,
                                      );
                                      if (barcodeRes != '-1') {
                                        prefs.setString("IdCode", barcodeRes);
                                      }
                                      Navigator.pop(context);
                                    },
                                  );
                                } else {
                                  showBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                      child: IdCardPage(),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  );
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
                      future: school.getMonthlyMeal(now.year, now.month),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var mealTitle;
                          var mealContent;
                          if (now.hour >= 0 && now.hour < 9) {
                            mealTitle = '오늘의 조식';
                            mealContent = snapshot.data[now.day - 1].breakfast;
                          } else if (now.hour >= 9 && now.hour < 14) {
                            mealTitle = '오늘의 중식';
                            mealContent = snapshot.data[now.day - 1].lunch;
                          } else if (now.hour >= 14 && now.hour < 20) {
                            mealTitle = '오늘의 석식';
                            mealContent = snapshot.data[now.day - 1].dinner;
                          } else if (now.hour >= 20 && now.hour <= 24) {
                            mealTitle = '내일의 조식';
                            mealContent = snapshot.data[now.day].breakfast;
                          }
                          return CardWidget(
                            cardTitle: mealTitle,
                            cardContent: mealContent,
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MealCalendar(school),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          debugPrint(snapshot.error.toString());
                          return CardWidget(
                              cardTitle: '오늘의 급식',
                              cardContent: '급식을 불러오지 못했습니다.');
                        }
                        return Card(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                          ),
                          color: Theme.of(context).errorColor,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            child: Container(
                              padding: EdgeInsets.all(18),
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      '오늘의 급식',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Theme.of(context).cursorColor,
                                    highlightColor:
                                        Theme.of(context).unselectedWidgetColor,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          ),
                                          color: Colors.grey[800]),
                                      child: Text(
                                        '이것은 스켈레톤 UI입니다.',
                                        style: TextStyle(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: school.getMonthlySchedule(now.year, now.month),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return CardWidget(
                            cardTitle: '📅 오늘의 학사일정',
                            cardContent: snapshot.data[now.day - 1].schedule,
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ScheduleCalendar(school),
                                ),
                              );
                            },
                          );
                        } else {
                          return CardWidget(
                            cardTitle: '📅 오늘의 학사일정',
                            cardContent: '학사일정을 불러오지 못했습니다.',
                          );
                        }
                      },
                    ),
                    CardWidget(
                      cardTitle: '🕖 시간표',
                      cardContent: '나만의 시간표를 확인하세요.',
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimeTablePage(),
                          ),
                        );
                      },
                    ),
                    Builder(
                      builder: (context) => CardWidget(
                        cardTitle: '☑️ 코로나 19 자가진단',
                        cardContent:
                            '등교하기 전, 자가진단은 하셨나요?\n마지막 제출 일시: $lastSubmitDisplayed',
                        onClick: () async {
                          if (prefs.getString('selfTestToken') == null ||
                              prefs.getString('selfTestToken') == '-1') {
                            okOnlyDialog(
                              context,
                              '코로나 19 자가진단',
                              '로그인 정보가 등록되어 있지 않습니다. 로그인을 진행합니다.',
                              () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelfTestLoginPage(),
                                  ),
                                );
                              },
                            );
                          } else {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelfTestPage(),
                              ),
                            );
                            setState(() {
                              var now = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());
                              var nextDay = DateFormat('yyyy-MM-dd')
                                  .parse(prefs.getString('selfTestLastSubmit'))
                                  .add(Duration(days: 1));

                              print(nextDay.isAfter(
                                  DateFormat('yyyy-MM-dd').parse(now)));

                              if (prefs.getString('selfTestLastSubmit') == '' ||
                                  prefs.getString('selfTestLastSubmit') ==
                                      null) {
                                setState(() {
                                  lastSubmitDisplayed = '오늘의 자가진단 기록이 없습니다.';
                                });
                              } else {
                                if (nextDay.isAfter(
                                        DateFormat('yyyy-MM-dd').parse(now)) ==
                                    true) {
                                  // 현재 날짜가 다음 날이 아닌 경우
                                  setState(() {
                                    lastSubmitDisplayed =
                                        prefs.getString('selfTestLastSubmit');
                                  });
                                } else {
                                  setState(() {
                                    lastSubmitDisplayed = '오늘의 자가진단 기록이 없습니다.';
                                  });
                                }
                              }
                            });
                          }
                          //_launchURL('https://hcs.eduro.go.kr');
                        },
                      ),
                    ),
                    CardWidget(
                      cardTitle: '💳 H4Pay',
                      cardContent: '매점 온라인 결제 및 예약 서비스',
                      onClick: () {
                        _launchURL('https://h4pay.co.kr');
                      },
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
