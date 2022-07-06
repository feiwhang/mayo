import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mayo/screens/shared/phone_verification_screen.dart';
import 'package:mayo/utils/converter.dart';

bool isAuthenticated() {
  FirebaseAuth auth = FirebaseAuth.instance;
  return auth.currentUser != null;
}

Future<void> sendPhoneNumVerificationCode(
    String phoneNum, BuildContext context) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  await auth.verifyPhoneNumber(
    phoneNumber: firebasePhoneNum(phoneNum),
    verificationCompleted: (PhoneAuthCredential credential) async {
      await signUserIn(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      // TODO: alert dialog based on error code ex. invalid phone num
    },
    codeSent: (String verificationId, int? resendToken) {
      // push to phone verification screen (smsCode)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhoneVerificationScreen(
            phoneNum: phoneNum.replaceAll(' ', ''),
            verificationId: verificationId,
          ),
        ),
      );
      // set verificationId to be used in phone verification screen
      print("set veriID: $verificationId");
    },
    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}

Future<void> verifyCodeFromPhoneNum(
    String verificationId, String smsCode) async {
  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: smsCode);

  await signUserIn(credential);
}

Future<void> signUserIn(PhoneAuthCredential credential) async {
  FirebaseAuth auth = FirebaseAuth.instance;

  // TODO: Handle errors & register
  await auth.signInWithCredential(credential);
}
