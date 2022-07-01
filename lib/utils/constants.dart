import 'package:flutter/material.dart';

// textstyle
const titleTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.w800,
  color: darkTextColor,
  decoration: TextDecoration.none,
);

const headerTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: darkTextColor,
  decoration: TextDecoration.none,
);

const subtitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: normalTextColor,
  decoration: TextDecoration.none,
);

const normalTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: lightTextColor,
  decoration: TextDecoration.none,
);

// color
const darkTextColor = Color(0xFF363a52);
const normalTextColor = Color(0xFF7E7A7A);
const lightTextColor = Color(0xFF9DA2B4);
const lightestGreenColor = Color(0xFFE8FBFE);
const lightGreenColor = Color(0xFF81d0db);
const darkGreenColor = Color(0xFF28a1b4);
const lightRedColor = Color(0xFFfff0ed);
const normalRedColor = Color(0xFFFCB2A7);
const darkRedColor = Color(0xFFFF8D81);
const brightYellowColor = Color(0xFFFFF000);
const darkYellowColor = Color(0xFFFBD801);

const mainGradient = LinearGradient(
    colors: [brightYellowColor, darkYellowColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

// spaces
const vSpaceS = SizedBox(height: 8);
const hSpaceS = SizedBox(width: 8);
const vSpaceM = SizedBox(height: 16);
const hSpaceM = SizedBox(width: 16);
