import 'package:flutter/material.dart';

void showModalWindow(BuildContext context, String title, String content, String action){
  if (!context.mounted) return;
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, action),
          child: Text(action),
        ),
      ],
    ),
  );
}