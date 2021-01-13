import 'package:remoterobotcar/configs/values/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final themeDefault = ThemeData(
      appBarTheme: AppBarTheme(
          color: primary, iconTheme: IconThemeData(color: colorIconBlack)),
      fontFamily: 'Montserrat',
      primaryColor: primary,
      primaryColorDark: primary,
      primaryColorLight: primaryLight,
      accentColor: secondary,
      // indicatorColor: secondaryLight,
      focusColor: primary,
      disabledColor: primaryLight,
      hintColor: primaryLight,
      cursorColor: secondary,
      primaryTextTheme: TextTheme(
        title: TextStyle(color: colorTextWhite, fontWeight: FontWeight.bold),
        headline: TextStyle(color: colorTextWhite, fontWeight: FontWeight.bold),
        subhead: TextStyle(
          color: colorTextBlack,
        ),
        body2: TextStyle(
          color: colorTextBlack,
        ),
        body1: TextStyle(
          color: colorTextBlack,
        ),
        caption: TextStyle(
          color: colorTextBlack,
        ),
        button: TextStyle(
          color: colorTextWhite, fontWeight: FontWeight.bold
        ),
        subtitle: TextStyle(
          color: colorTextBlack,
        ),
        display1: TextStyle(color: colorTextBlack, fontWeight: FontWeight.bold),
      ),
      primaryIconTheme: IconThemeData(color: colorIconWhite),
      accentIconTheme: IconThemeData(color: colorIconWhite));
}
