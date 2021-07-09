import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjconnect/tools/apipost.dart';
import 'package:sjconnect/tools/dialogs.dart';
import 'components/card.dart';

class SelfTestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SelfTestPageState();
}

class SelfTestPageState extends State<SelfTestPage> {
  SharedPreferences prefs;
  var _1styesno;
  var _2ndyesno;
  var _3rdyesno;

  @override
  void initState() {
    super.initState();
    setupPref().then(
      (value) {
        prefs = value;
      },
    );
  }

  Future<SharedPreferences> setupPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("코로나 19 자가진단"),
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.send),
              color: Theme.of(context).iconTheme.color,
              onPressed: () {
                apiPost(
                  'https://cbehcs.eduro.go.kr/registerServey',
                  {
                    "rspns00": "Y",
                    "rspns01": "1",
                    "rspns02": "1",
                    "rspns03": null,
                    "rspns04": null,
                    "rspns05": null,
                    "rspns06": null,
                    "rspns07": null,
                    "rspns08": null,
                    "rspns09": "0",
                    "rspns10": null,
                    "rspns11": null,
                    "rspns12": null,
                    "rspns13": null,
                    "rspns14": null,
                    "rspns15": null,
                    "deviceUuid": "",
                    "upperToken": prefs.getString('selfTestToken'),
                    "upperUserNameEncpt": prefs.getString('selfTestName'),
                  },
                  {
                    'Content-Type': 'application/json',
                    'Authorization': prefs.getString('selfTestToken')
                  },
                ).then(
                  (res) {
                    prefs.setString(
                        'selfTestLastSubmit', jsonDecode(res)['registerDtm']);
                    okOnlyDialog(
                        context,
                        '코로나 19 자가진단',
                        '제출이 완료되었습니다.\n제출 일시: ' +
                            jsonDecode(res)['registerDtm'], () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                );
              }),
        ],
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
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
                    CardWidget(
                      cardTitle: '1.',
                      cardContent:
                          '37.5℃ 이상의 체온, 기침, 호흡곤란, 오한, 근육통, 두통, 인후통, 후각·미각 소실 또는 폐렴 등의 증상이 있나요?',
                    ),
                    RadioListTile(
                      title: Text('아니오'),
                      value: false,
                      groupValue: _1styesno,
                      onChanged: (value) {
                        setState(() {
                          _1styesno = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('예'),
                      value: true,
                      groupValue: _1styesno,
                      onChanged: (value) {
                        setState(() {
                          _1styesno = value;
                        });
                      },
                    ),
                    CardWidget(
                      cardTitle: '2.',
                      cardContent:
                          '학생 본인 또는 동거인이 코로나 19 의심증상으로 진단검사를 받고 그 결과를 기다리고 있나요?',
                    ),
                    RadioListTile(
                      title: Text('아니오'),
                      value: false,
                      groupValue: _2ndyesno,
                      onChanged: (value) {
                        setState(() {
                          _2ndyesno = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('예'),
                      value: true,
                      groupValue: _2ndyesno,
                      onChanged: (value) {
                        setState(() {
                          _2ndyesno = value;
                        });
                      },
                    ),
                    CardWidget(
                      cardTitle: '3.',
                      cardContent: '학생 본인 또는 동거인이 방역당국에 의해 현재 자가격리가 이루어지고 있나요?',
                    ),
                    RadioListTile(
                      title: Text('아니오'),
                      value: false,
                      groupValue: _3rdyesno,
                      onChanged: (value) {
                        setState(() {
                          _3rdyesno = value;
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text('예'),
                      value: true,
                      groupValue: _3rdyesno,
                      onChanged: (value) {
                        setState(() {
                          _3rdyesno = value;
                        });
                      },
                    ),
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
