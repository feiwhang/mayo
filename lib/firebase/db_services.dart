import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mayo/firebase/auth_services.dart';
import 'package:mayo/screens/shared/main_screen.dart';
import 'package:mayo/utils/constants.dart';
import 'package:mayo/widgets/alert_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final usersCollection = db.collection("users");

Future<void> createUserOnDb(Map<String, String> registerData) async {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (BuildContext context) =>
        LoadingDialog(loadingText: AppLocalizations.of(context)!.signingUp),
    barrierDismissible: false,
  );

  await usersCollection
      .doc(getUID())
      .set(registerData)
      .onError((error, stackTrace) {});

  // navigate to mainscreen
  navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
          (Route<dynamic> route) => false);
}
