import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  @override
  TimeTablePageState createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
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
            Text("시간표"),
          ],
        ),
        leading: BackButton(
          color: Theme.of(context).iconTheme.color,
          onPressed: () => {
            Navigator.of(context).pop(),
          },
        ),
      ),
    );
  }
}
