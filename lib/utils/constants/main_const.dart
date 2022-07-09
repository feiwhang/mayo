import 'package:flutter/material.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';

// inputDecor
InputDecoration roundedRectDecor(String label) => InputDecoration(
      contentPadding: const EdgeInsets.all(16),
      labelText: label,
      labelStyle: normalTextStyle(lightTextColor),
      counterText: '',
      border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: darkYellowColor)),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: normalRedColor)),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: normalRedColor)),
    );

// regex
const String thaiPhoneNumRegex = r"^0[6,8,9][0-9]{8}$";

// etc
final navigatorKey = GlobalKey<NavigatorState>();
