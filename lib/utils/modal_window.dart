import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/widgetStyles/buttons/button_styles.dart';

void showModalWindow(BuildContext context, String title, String content, String action){
  if (!context.mounted) return;
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () => Navigator.pop(context, action),
          style: ButtonStyles.redButton(),
          child: Text(action),
        ),
      ],
    ),
  );
}