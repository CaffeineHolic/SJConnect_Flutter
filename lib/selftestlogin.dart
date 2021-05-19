import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjconnect/tools/apipost.dart';
import 'package:sjconnect/tools/dialogs.dart';
import 'package:sjconnect/tools/encrypt.dart';
import 'dart:convert';

class SelfTestLoginPage extends StatefulWidget {
  @override
  SelfTestLoginPageState createState() => SelfTestLoginPageState();
}

class SelfTestLoginPageState extends State<SelfTestLoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var name;
  var birthday;
  bool _loading = false;
  SharedPreferences prefs;

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        shape: ContinuousRectangleBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("자가진단 로그인"),
          ],
        ),
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: '이름',
                              labelText: '이름',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '필수';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: birthdayController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(Icons.perm_contact_calendar),
                              hintText: 'YYMMDD',
                              labelText: '생년월일',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '필수';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(Icons.perm_contact_calendar),
                              hintText: '비밀번호',
                              labelText: '비밀번호',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return '필수';
                              } else {
                                return null;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                      child: Builder(
                        builder: (context) => !_loading
                            ? ElevatedButton(
                                child: Text("로그인"),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => _loading = true);
                                    apiPost(
                                      'https://cbehcs.eduro.go.kr/v2/findUser',
                                      {
                                        'birthday':
                                            encrypt(birthdayController.text),
                                        'name': encrypt(nameController.text),
                                        'loginType': 'school',
                                        'orgCode': 'M100002171',
                                        'stdntPNo': null,
                                      },
                                      {'Content-Type': 'application/json'},
                                    ).then(
                                      (res) {
                                        if (res == '500') {
                                          setState(() => _loading = false);
                                          okOnlyDialog(
                                            context,
                                            '자가진단 로그인',
                                            '이름, 생년월일 또는 비밀번호가 틀립니다. 다시 입력해주세요.',
                                            () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        } else {
                                          prefs.setString('selfTestFindToken',
                                              jsonDecode(res)['token']);
                                          apiPost(
                                            'https://cbehcs.eduro.go.kr/v2/hasPassword',
                                            {},
                                            {
                                              'Content-Type':
                                                  'application/json',
                                              'Authorization':
                                                  jsonDecode(res)['token']
                                            },
                                          ).then(
                                            (res) {
                                              if (res == 'true') {
                                                setState(
                                                    () => _loading = false);
                                                apiPost(
                                                  'https://cbehcs.eduro.go.kr/v2/validatePassword',
                                                  {
                                                    'password': encrypt(
                                                        passwordController
                                                            .text),
                                                    'deviceUuid': ''
                                                  },
                                                  {
                                                    'Content-Type':
                                                        'application/json',
                                                    'Authorization':
                                                        prefs.getString(
                                                            'selfTestFindToken')
                                                  },
                                                ).then(
                                                  (res) {
                                                    if (jsonDecode(res)
                                                            .runtimeType !=
                                                        String) {
                                                      if (jsonDecode(
                                                              res)['isError'] ==
                                                          true) {
                                                        setState(() =>
                                                            _loading = false);
                                                        okOnlyDialog(
                                                          context,
                                                          '자가진단 로그인',
                                                          '이름, 생년월일 또는 비밀번호가 틀립니다. 다시 입력해주세요.',
                                                          () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      apiPost(
                                                        'https://cbehcs.eduro.go.kr/v2/selectUserGroup',
                                                        {},
                                                        {
                                                          'Authorization':
                                                              res.replaceAll(
                                                                  '"', '')
                                                        },
                                                      ).then(
                                                        (res) {
                                                          setState(() =>
                                                              _loading = false);
                                                          prefs.setString(
                                                              'selfTestName',
                                                              jsonDecode(res)[0]
                                                                  [
                                                                  'userNameEncpt']);
                                                          prefs.setString(
                                                              'selfTestToken',
                                                              jsonDecode(res)[0]
                                                                  ['token']);
                                                          okOnlyDialog(
                                                            context,
                                                            '자가진단 로그인',
                                                            '로그인이 완료되었습니다. 자가진단 메뉴에 다시 진입해주세요.',
                                                            () {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                setState(
                                                    () => _loading = false);
                                                okOnlyDialog(
                                                  context,
                                                  '자가진단 로그인',
                                                  '초기 비밀번호가 설정되어 있지 않습니다. 자가진단 웹사이트에서 설정해주세요.',
                                                  () {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              )
                            : CircularProgressIndicator(),
                      ),
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
