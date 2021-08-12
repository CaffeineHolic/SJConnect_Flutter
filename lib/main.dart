import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sjconnect/idcard.dart';
import 'package:sjconnect/settings.dart';
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

  @override
  void initState() {
    super.initState();
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
                                    highlightColor: Colors.grey[400],
                                    baseColor: Colors.grey[350],
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
