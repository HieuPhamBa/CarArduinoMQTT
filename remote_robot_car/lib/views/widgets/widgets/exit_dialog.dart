import 'package:flutter/material.dart';

class ExitAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text('Warning'),
      content: Text('Do you really want to exit?'),
      actions: [
        FlatButton(
          child: Text('Yes'),
          onPressed: () => Navigator.pop(context, true),
        ),
        FlatButton(
          child: Text('No'),
          onPressed: () => Navigator.pop(context, false),
        ),
      ],
    );
  }
}
