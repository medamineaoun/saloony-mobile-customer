import 'package:flutter/material.dart';

class SuccessResetViewModel extends ChangeNotifier {
  void goToSignIn(BuildContext context) {
    Navigator.pushNamed(context, '/signIn');
  }
}
