import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromRGBO(52, 51, 67, 1),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromRGBO(52, 51, 67, 1),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blue, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
