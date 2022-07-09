// textstyle
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mayo/utils/constants/color_const.dart';

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
