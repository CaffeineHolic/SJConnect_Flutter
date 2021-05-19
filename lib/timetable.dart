import 'package:flutter/material.dart';
import 'package:sjconnect/timetable_edit.dart';
import 'package:sjconnect/tools/DBHelper.dart';
import 'components/table/table.dart';

class TimeTablePage extends StatefulWidget {
  @override
  TimeTablePageState createState() => TimeTablePageState();
}

class TimeTablePageState extends State<TimeTablePage> {
  @override
  void initState() {
    super.initState();
    getDB();
  }

  Future<List<Map<String, Object>>> getDB() async {
    var db = await DBHelper().database;
    return await db.rawQuery('SELECT * FROM timeTable');
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "시간표 수정",
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimeTableEdit(),
                ),
              )
            },
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getDB(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TimeTable(data: snapshot.data);
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}
