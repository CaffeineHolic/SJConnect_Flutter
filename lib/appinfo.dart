import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppInfoPageState();
}

class AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: getVersionNumber(),
          builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(30.w)),
                  Text(
                    '서전고 알리미',
                    style: TextStyle(fontSize: 40.sp),
                  ),
                  Padding(padding: EdgeInsets.all(10.w)),
                  Text(
                      '버전 ' +
                          snapshot.data.version +
                          '-' +
                          snapshot.data.buildNumber,
                      style: Theme.of(context).textTheme.subtitle1),
                  Padding(padding: EdgeInsets.all(5.w)),
                  Text(
                    '최신 버전입니다.',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Padding(padding: EdgeInsets.all(100.w)),
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        width: 230.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '오픈소스 라이선스',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      child: Container(
                        padding: EdgeInsets.all(10.w),
                        width: 230.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '개인정보 처리방침',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '서전고 알리미',
                    style: TextStyle(fontSize: 40.sp),
                  ),
                  Padding(padding: EdgeInsets.all(10.w)),
                  Text('버전을 불러올 수 없습니다.',
                      style: Theme.of(context).textTheme.subtitle1),
                  Padding(padding: EdgeInsets.all(5.w)),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Future<PackageInfo> getVersionNumber() async {
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo;
}
