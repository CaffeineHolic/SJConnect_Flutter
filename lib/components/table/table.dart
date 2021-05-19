import 'package:flutter/material.dart';
import 'package:sjconnect/components/table/table_strings.dart';
import 'cell.dart';

class TimeTable extends StatefulWidget {
  final data;

  const TimeTable({Key key, this.data}) : super(key: key);
  @override
  State<StatefulWidget> createState() => TimeTableState(data);
}

class TimeTableState extends State<TimeTable> {
  final List table;

  TimeTableState(this.table);
  Map<int, List<Map>> tableData = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(table);

    tableData = {
      // datas by Day
      0: [
        {
          "range": [0, 1],
          "subject": 0
        },
        {
          "range": [2, 3],
          "subject": 1
        },
      ],
      1: [
        {
          "range": [0, 1],
          "subject": 2
        },
        {
          "range": [2, 3],
          "subject": 3
        },
      ],
      2: [
        {
          "range": [0, 1],
          "subject": 4
        },
        {
          "range": [2, 3],
          "subject": 5
        },
      ],
      3: [
        {
          "range": [0, 1],
          "subject": 6
        },
        {
          "range": [2, 3],
          "subject": 7
        },
      ],
      4: [
        {
          "range": [0, 1],
          "subject": 8
        },
        {
          "range": [2, 3],
          "subject": 9
        },
      ],
    };
  }

  onCellTapped(int day, int period) {
    //print("$day , $period");
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: periods.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, idx) {
        // ListView by Periods
        List<Widget> rows = [];
        rows.add(
          Text(
            periods[idx],
          ),
        ); // Add Period Text
        rows.addAll(
          List.generate(daysOfWeek.length - 1, (index) {
            final lesson = tableData[index]; // Load all lessons on that day
            Cell cellToReturn;

            for (var i = 0; i < lesson.length; i++) {
              // Check all lessons if this period included in range
              if (idx == 5) {
                //print(lesson[i]["range"].toString());
              }
              if (idx >= lesson[i]["range"][0] &&
                  idx <= lesson[i]["range"][1]) {
                //print(lesson[i]["subject"].toString());
                print("in range!  $index , $idx , $i , ${lesson[i]["range"]}");
                return Cell(
                  content: lesson[i]["subject"].toString(),
                  onCellTapped: onCellTapped(index, idx),
                  day: index,
                  period: idx,
                );
              }
            }
            //i = 0;
            print("nothing happend $index , $idx ,");
            return Cell(
              content: "",
              onCellTapped: onCellTapped(index, idx),
              day: index,
              period: idx,
            );
          }),
        );

        print(rows);
        return Row(
          children: rows,
        );
      },
    );
  }
}
