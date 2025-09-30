import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  bool get passwordVisible1 => _passwordVisible1;
  bool get passwordVisible2 => _passwordVisible2;

  void togglePasswordVisibility1() {
    _passwordVisible1 = !_passwordVisible1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _passwordVisible2 = !_passwordVisible2;
    notifyListeners();
  }

  void changePassword(BuildContext context) {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // TODO: Appel API pour changer le mot de passe
    Navigator.pushNamed(context, '/successReset');
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
