import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppInfoPageState();
}

class AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
                  Text(
                    '서전고 알리미',
                    style: TextStyle(fontSize: 40),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                      '버전 ' +
                          snapshot.data.version +
                          '-' +
                          snapshot.data.buildNumber,
                      style: Theme.of(context).textTheme.subtitle1),
                  Padding(padding: EdgeInsets.all(5)),
                  Text(
                    '최신 버전입니다.',
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '서전고 알리미',
                    style: TextStyle(fontSize: 40),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text('버전을 불러올 수 없습니다.',
                      style: Theme.of(context).textTheme.subtitle1),
                  Padding(padding: EdgeInsets.all(5)),
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
