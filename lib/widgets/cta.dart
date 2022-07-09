import 'package:flutter/material.dart';
import 'package:mayo/utils/constants/color_const.dart';
import 'package:mayo/utils/constants/text_style_const.dart';

class Cta extends StatelessWidget {
  const Cta({Key? key, required this.label, this.onPressed, this.bgColor})
      : super(key: key);

  final String label;
  final Color? bgColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        gradient: bgColor == null ? mainGradientH : null,
        color: bgColor,
      ),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        child: Text(
          label,
          style: subtitleTextStyle,
        ),
      ),
    );
  }
}
