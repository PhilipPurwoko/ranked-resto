import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  primaryColor: const Color(0xFF66bb6a),
  accentColor: const Color(0xFF98ee99),
  primaryColorDark: const Color(0xFF338a3e),
  focusColor: const Color(0xFF98ee99),
  fontFamily: 'Georgia',
  textTheme: const TextTheme(
    headline6: TextStyle(
      fontSize: 20.0,
      fontStyle: FontStyle.italic,
    ),
    bodyText1: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    bodyText2: TextStyle(
      fontSize: 14.0,
    ),
  ),
);
