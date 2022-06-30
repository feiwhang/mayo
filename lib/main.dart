import 'package:flutter/material.dart';

void main() {
  runApp(const Mayo());
}

class Mayo extends StatelessWidget {
  const Mayo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Container(),
    );
  }
}
