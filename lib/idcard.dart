import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_flutter/barcode_flutter.dart';

class IdCardPage extends StatefulWidget {
  @override
  IdCardPageState createState() => IdCardPageState();
}

class IdCardPageState extends State<IdCardPage> {
  String IdCode = '';

  @override
  void initState() {
    super.initState();
    loadIdCode();
  }

  loadIdCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      IdCode = prefs.getString("IdCode");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          "전자학생증",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: Image.asset("assets/letterlogo.png"),
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 50),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 100),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "이상설",
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(
                              "1871년 1월 27일",
                              style: TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                        Image.asset(
                          "assets/profile.png",
                          width: 60,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: BarCodeImage(
                      params: Code39BarCodeParams(IdCode,
                          lineWidth: 2.0, barHeight: 60.0, withText: false),
                      onError: (error) {
                        debugPrint("error occoured: " + error);
                      },
                    ),
                  ),
                ],
              ),
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xffd6d6d6)),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white),
              padding: EdgeInsets.all(20),
            ),
            Container(
              child: Text(
                "전자학생증은 교내 도서관 및 석식 인증 등 교내 전용으로만 사용가능합니다. 실물 학생증의 교통/체크/현금카드의 기능은 제공하지 않습니다.",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
