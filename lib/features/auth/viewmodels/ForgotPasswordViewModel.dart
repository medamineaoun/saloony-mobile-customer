import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  // Simple email validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  Future<void> sendResetLink(BuildContext context) async {
    final email = emailController.text.trim();

    if (emailValidator(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    // TODO: Call your backend API to send reset link
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Reset link sent to $email')));
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }
}
