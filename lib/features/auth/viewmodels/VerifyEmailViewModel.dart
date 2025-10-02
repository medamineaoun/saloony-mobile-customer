import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final String email;
  final TextEditingController codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  VerifyEmailViewModel(this.email);

  /// Vérifie le code entré par l’utilisateur
  Future<bool> verifyCode() async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.verifySignupCode(
      email: email,
      code: codeController.text.trim(),
    );

    isLoading = false;
    notifyListeners();

    return result['success'] == true;
  }

  /// Redemande un code de vérification
  Future<bool> resendCode() async {
    isLoading = true;
    notifyListeners();

    final result = await _authService.requestSignupVerification(email);

    isLoading = false;
    notifyListeners();

    return result['success'] == true;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }
}
