import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  final String email;
  final BuildContext context;
  final TextEditingController codeController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  VerifyEmailViewModel(this.email, this.context) {
    // Initialiser le ToastService au démarrage
    ToastService.init(context);
  }

  Future<bool> verifyCode() async {
    if (codeController.text.trim().isEmpty) {
      ToastService.showError(context, 'Veuillez entrer le code de vérification');
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.verifySignupCode(
        email: email,
        code: codeController.text.trim(),
      );

      isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        ToastService.showSuccess(context, 'Email vérifié avec succès !');
        return true;
      } else {
        final message = result['message'] ?? 'Erreur lors de la vérification';
        ToastService.showError(context, message);
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastService.showError(context, 'Une erreur est survenue');
      return false;
    }
  }

  /// Redemande un code de vérification
  Future<bool> resendCode() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.requestSignupVerification(email);

      isLoading = false;
      notifyListeners();

      if (result['success'] == true) {
        ToastService.showSuccess(
          context,
          'Code de vérification renvoyé à $email',
        );
        return true;
      } else {
        final message = result['message'] ?? 'Erreur lors du renvoi du code';
        ToastService.showError(context, message);
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ToastService.showError(context, 'Impossible de renvoyer le code');
      return false;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    ToastService.cancelAll();
    super.dispose();
  }
}