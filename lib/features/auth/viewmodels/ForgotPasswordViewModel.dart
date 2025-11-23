import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

  Future<void> sendResetCode(BuildContext context) async {
    final email = emailController.text.trim();

    if (emailValidator(email) != null) {
      ToastService.showError(context, "Please enter a valid email");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.requestPasswordReset(email);

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        ToastService.showSuccess(context, result['message'] ?? "Code sent to your email");

        // Navigation
        Navigator.pushNamed(
          context,
          '/verifyResetCode',
          arguments: email,
        );

      } else {
        ToastService.showError(context, result['message'] ?? "Error sending code");
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ToastService.showError(context, "Error : $e");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }
}
