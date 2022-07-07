String textToFirebasePhoneNum(String phoneNum) {
  return '+66 ${phoneNum.substring(1)}';
}

String firebasePhoneNumToText(String firebasePhoneNum) {
  return '0${firebasePhoneNum.substring(3)}';
}
