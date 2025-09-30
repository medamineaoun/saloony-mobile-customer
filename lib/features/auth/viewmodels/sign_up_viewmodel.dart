import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/services/AuthService.dart';

class SignUpViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont obligatoires")),
      );
      return;
    }

    final authService = AuthService();
    final result = await authService.signUp(
      firstName: name,
      lastName: "", // si tu veux demander le prénom/nom séparés
      email: email,
      password: password,
      phoneNumber: "00000000",
      gender: "HOMME",
      role: "USER",
    );

    if (result['success']) {
      Navigator.pushNamed(context, "/verifyEmail");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result['message'])));
    }
  }
}
