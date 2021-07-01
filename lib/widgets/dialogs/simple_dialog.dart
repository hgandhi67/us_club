import 'package:flutter/material.dart';
import 'package:us_club/base/export_base.dart';

import '../widgets.dart';

class AppSimpleDialog extends StatelessWidget {
  final title;
  final content;
  final onTap;

  const AppSimpleDialog({
    Key key,
    this.title,
    this.content,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Texts(
        "Success!",
        color: Palette.black,
        fontSize: 20,
        fontFamily: bold,
      ),
      content: Texts(
        // "Verification link has been sent to your registered email address, please follow the instruction to start using the app.",
        content,
        color: Palette.grey,
        fontFamily: semiBold,
        fontSize: 16,
      ),
      actions: [
        FlatButton(
          onPressed: onTap,
          child: Texts(
            "OK",
            fontFamily: semiBold,
          ),
        )
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialog({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Texts(
        title,
        color: Palette.black,
        fontSize: 17.0,
      ),
      actions: [
        FlatButton(
          color: context.accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Texts("Cancel"),
        ),
        FlatButton(
          color: context.accentColor,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Texts("Ok"),
        ),
      ],
    );
  }
}
