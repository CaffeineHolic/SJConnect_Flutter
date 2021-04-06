import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/card.dart';

class SettingsPage extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
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
            Text("설정"),
          ],
        ),
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: Center(
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
                  CardWidget(
                    cardTitle: '시간표 백업',
                    cardContent: '시간표를 파일로 내보냅니다.',
                  ),
                  CardWidget(
                    cardTitle: '시간표 복원',
                    cardContent: '시간표 파일을 불러와 적용합니다.',
                  ),
                  CardWidget(
                    cardTitle: '버그 보고',
                    cardContent: '서전고 알리미의 버그를 알려주세요!',
                    onClick: () {
                      _launchURL(
                        Uri.encodeFull(
                            'mailto:support@yoon-lab.xyz?subject=서전고 알리미 버그 제보'),
                      );
                    },
                  ),
                  CardWidget(
                    cardTitle: '버전',
                    cardContent: 'v1.0.0-alpha',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
