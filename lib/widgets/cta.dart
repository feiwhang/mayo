import 'package:flutter/material.dart';
import 'package:mayo/utils/constants.dart';

class Cta extends StatelessWidget {
  const Cta({Key? key, required this.label, this.onPressed}) : super(key: key);

  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        gradient: mainGradientH,
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
