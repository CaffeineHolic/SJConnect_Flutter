import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardWidget extends StatefulWidget {
  final String cardTitle;
  final String cardContent;
  final onClick;

  const CardWidget({
    Key key,
    @required this.cardTitle,
    @required this.cardContent,
    this.onClick,
  }) : super(key: key);

  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: InkWell(
        onTap: widget.onClick,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: Container(
          padding: EdgeInsets.all(18.w),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  widget.cardTitle,
                  style: TextStyle(fontSize: 18.sp),
                ),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5.w),
              ),
              Text(
                widget.cardContent,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentCardWidget extends StatefulWidget {
  final String cardTitle;
  final String cardContent;
  final Color color;
  final onClick;

  const StudentCardWidget(
      {Key key,
      @required this.cardTitle,
      @required this.cardContent,
      this.onClick,
      this.color = Colors.white})
      : super(key: key);

  _StudentCardWidgetState createState() => _StudentCardWidgetState();
}

class _StudentCardWidgetState extends State<StudentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10.w),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Color(0xffd6d6d6)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: widget.color),
        padding: EdgeInsets.all(18.w),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.cardTitle,
              style: TextStyle(fontSize: 18.sp),
            ),
          ],
        ),
      ),
      onTap: widget.onClick,
    );
  }
}
