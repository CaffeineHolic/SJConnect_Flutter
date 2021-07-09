import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('시간표'),
      ),
    );
  }
}
