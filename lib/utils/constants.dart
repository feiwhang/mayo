import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// textstyle
var titleTextStyle = GoogleFonts.nunito(
  fontSize: 28,
  fontWeight: FontWeight.w800,
  color: darkTextColor,
  decoration: TextDecoration.none,
);

TextStyle headerTextStyle(Color color) => GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
      decoration: TextDecoration.none,
    );

var subtitleTextStyle = GoogleFonts.nunito(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: normalTextColor,
  decoration: TextDecoration.none,
);

TextStyle normalTextStyle(Color color) => GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      decoration: TextDecoration.none,
    );

var normalTextButtonStyle = GoogleFonts.nunito(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: darkestYellowColor,
  decoration: TextDecoration.underline,
);

// color
const darkTextColor = Color(0xFF363a52);
const normalTextColor = Color(0xFF7E7A7A);
const lightTextColor = Color(0xFFCAC8C8);
const lightestGreyColor = Color(0xFFF8F7F7);
const lightestGreenColor = Color(0xFFE8FBFE);
const lightGreenColor = Color(0xFF81d0db);
const darkGreenColor = Color(0xFF28a1b4);
const lightRedColor = Color(0xFFfff0ed);
const normalRedColor = Color(0xFFFCB2A7);
const darkRedColor = Color(0xFFFF8D81);
const brightYellowColor = Color(0xFFFFF000);
const darkYellowColor = Color(0xFFFBD801);
const darkestYellowColor = Color(0xFFFFC338);
const lightYellowColor = Color(0xFFFFFEF1);

const mainGradientV = LinearGradient(
  colors: [brightYellowColor, darkYellowColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const mainGradientH = LinearGradient(
  colors: [brightYellowColor, darkYellowColor],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

// spaces
const vSpaceS = SizedBox(height: 8);
const hSpaceS = SizedBox(width: 8);
const vSpaceM = SizedBox(height: 16);
const hSpaceM = SizedBox(width: 16);
const vSpaceL = SizedBox(height: 24);
const hSpaceL = SizedBox(width: 24);
const vSpaceXL = SizedBox(height: 32);
const hSpaceXL = SizedBox(width: 32);
