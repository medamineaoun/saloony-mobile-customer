import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool _isLoading = false;

  bool get passwordVisible1 => _passwordVisible1;
  bool get passwordVisible2 => _passwordVisible2;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility1() {
    _passwordVisible1 = !_passwordVisible1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _passwordVisible2 = !_passwordVisible2;
    notifyListeners();
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> changePassword(
    BuildContext context,
    String email,
    String code,
  ) async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validation
    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.resetPassword(
        email: email,
        code: code,
        newPassword: password,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Password reset successfully',
            ),
          ),
        );
        
        // Navigate to success screen or login
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/signIn',
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Error resetting password',
            ),
          ),
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}