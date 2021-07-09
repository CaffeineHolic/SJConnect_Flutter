import 'package:flutter/material.dart';

void okOnlyDialog(BuildContext context, String title, String content, okEvent) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            new TextButton(
              onPressed: okEvent,
              child: Text("확인"),
            )
          ],
        );
      });
}
