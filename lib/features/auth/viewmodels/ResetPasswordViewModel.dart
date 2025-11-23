import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;
  bool _hasSpecialChar = false;
  bool _passwordsMatch = false;

  bool get isLoading => _isLoading;
  bool get passwordVisible1 => _passwordVisible1;
  bool get passwordVisible2 => _passwordVisible2;

  bool get hasMinLength => _hasMinLength;
  bool get hasUppercase => _hasUppercase;
  bool get hasLowercase => _hasLowercase;
  bool get hasNumber => _hasNumber;
  bool get hasSpecialChar => _hasSpecialChar;
  bool get passwordsMatch => _passwordsMatch;

  bool get isPasswordValid =>
      _hasMinLength &&
      _hasUppercase &&
      _hasLowercase &&
      _hasNumber &&
      _hasSpecialChar &&
      _passwordsMatch &&
      passwordController.text.isNotEmpty &&
      confirmPasswordController.text.isNotEmpty;

  void togglePasswordVisibility1() {
    _passwordVisible1 = !_passwordVisible1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _passwordVisible2 = !_passwordVisible2;
    notifyListeners();
  }

  void validatePassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    _hasMinLength = password.length >= 8;
    _hasUppercase = password.contains(RegExp(r'[A-Z]'));
    _hasLowercase = password.contains(RegExp(r'[a-z]'));
    _hasNumber = password.contains(RegExp(r'[0-9]'));
    _hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    _passwordsMatch = password == confirmPassword && password.isNotEmpty;

    notifyListeners();
  }

  Future<void> changePassword(
    BuildContext context,
    String email,
    String code,
  ) async {
    if (!isPasswordValid) {
      ToastService.showError(context, "Please meet all password requirements");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.resetPassword(
        email: email,
        code: code,
        newPassword: passwordController.text.trim(),
      );

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        ToastService.showSuccess(context, "Password updated successfully");

        if (context.mounted) {
          _showSuccessDialog(
            context,
            result['message'] ?? 'Password reset successfully',
          );
        }
      } else {
        ToastService.showError(
          context,
          result['message'] ?? "Error resetting password",
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      ToastService.showError(
        context,
        "Failed to reset password. Please try again.",
      );
    }
  }

  // Success dialog unchanged
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF27AE60).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 50,
                  color: Color(0xFF27AE60),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Password Changed!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/signIn',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2B3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go to Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
