// color
import 'package:flutter/painting.dart';

const darkTextColor = Color(0xFF363a52);
const normalTextColor = Color(0xFF7E7A7A);
const lightTextColor = Color(0xFFCAC8C8);
const lightestGreyColor = Color(0xFFF8F7F7);
const lightestGreenColor = Color(0xFFE8FBFE);
const lightGreenColor = Color(0xFF81d0db);
const darkGreenColor = Color(0xFF28a1b4);
const lightRedColor = Color.fromARGB(255, 255, 198, 187);
const normalRedColor = Color.fromARGB(255, 255, 136, 118);
const darkRedColor = Color.fromARGB(255, 250, 102, 86);
const brightestYellowColor = Color(0xFFFFF66F);
const brightYellowColor = Color(0xFFFFF000);
const darkYellowColor = Color(0xFFFBD801);
const darkestYellowColor = Color(0xFFFFC338);
const lightYellowColor = Color(0xFFFFFEF1);

const mainGradientV = LinearGradient(
  colors: [brightestYellowColor, darkestYellowColor],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

const mainGradientH = LinearGradient(
  colors: [brightestYellowColor, darkestYellowColor],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
