import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  const ShadowContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
