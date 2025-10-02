import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class VerifyResetCodeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final List<TextEditingController> codeControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get code => codeControllers.map((c) => c.text).join();

  void onCodeChanged(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < 5) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    notifyListeners();
  }

  void onBackspace(int index, BuildContext context) {
    if (index > 0) {
      codeControllers[index - 1].clear();
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
    notifyListeners();
  }

  Future<void> verifyCode(BuildContext context, String email) async {
    final verificationCode = code;

    if (verificationCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the complete code')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.verifyResetCode(
        email: email,
        code: verificationCode,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        // Navigate to reset password screen with email and code
        Navigator.pushNamed(
          context,
          '/resetPassword',
          arguments: {'email': email, 'code': verificationCode},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Invalid or expired code'),
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

  Future<void> resendCode(BuildContext context, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.requestPasswordReset(email);

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Code resent to your email')),
        );
        // Clear previous code
        for (var controller in codeControllers) {
          controller.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Error resending code')),
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
    for (var controller in codeControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}