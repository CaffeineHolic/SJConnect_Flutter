import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'tools/dialogs.dart';

class IdCardPage extends StatefulWidget {
  @override
  IdCardPageState createState() => IdCardPageState();
}

class IdCardPageState extends State<IdCardPage> {
  String IdCode = '';
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadIdCode();
  }

  loadIdCode() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      IdCode = prefs.getString("IdCode");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        shadowColor: Colors.transparent,
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
            Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(38)),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              okOnlyDialog(
                context,
                "학생증 등록",
                "학생증이 등록되어 있습니다. 변경 절차를 시작합니다.",
                () {
                  FlutterBarcodeScanner.scanBarcode(
                          "#000000", '취소', true, ScanMode.BARCODE)
                      .then(
                    (value) {
                      if (value != '-1') {
                        prefs.setString("IdCode", value);
                        loadIdCode();
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
          /*PopupMenuItem(
            child: IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                prefs.remove("IdCode");
                Navigator.pop(context);
              },
            ),
          ),*/
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Theme.of(context).focusColor),
        padding: EdgeInsets.all(2.0),
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
                              style: Theme.of(context).textTheme.headline4,
                            ),
                            Text(
                              "1871년 1월 27일",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                        SvgPicture.asset(
                          "assets/profile.svg",
                          width: 60,
                          height: 60,
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: BarCodeImage(
                      params: Code39BarCodeParams(IdCode,
                          barHeight: 60.0, withText: false),
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
                "전자학생증은 교내 도서관 도서 대출·반납, 석식 인증 등 교내 전용으로만 사용 가능합니다. 실물 학생증의 교통·체크·현금카드 기능은 제공하지 않습니다.",
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.all(10.0),
            )
          ],
        ),
      ),
    );
  }
}
