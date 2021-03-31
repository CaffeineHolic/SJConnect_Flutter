import 'package:flutter/material.dart';

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
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Theme.of(context).highlightColor),
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.cardTitle,
                style: TextStyle(fontSize: 18),
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
            ),
            Text(
              widget.cardContent,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
      onTap: widget.onClick,
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
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: Color(0xffd6d6d6)),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: widget.color),
          padding: EdgeInsets.all(18),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cardTitle,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        onTap: widget.onClick);
  }
}
