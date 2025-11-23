import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';
import 'package:saloony/core/constants/app_routes.dart';

class VerifyResetCodeViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final BuildContext context;
  
  // Controller unique pour le code de vérification
  final TextEditingController codeController = TextEditingController();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  VerifyResetCodeViewModel(this.context) {
    ToastService.init(context);
  }

  /// Vérifie le code de réinitialisation
  Future<void> verifyCode(String email) async {
    final verificationCode = codeController.text.trim();

    if (verificationCode.isEmpty) {
      ToastService.showError(context, 'Veuillez entrer le code de vérification');
      return;
    }

    if (verificationCode.length != 6) {
      ToastService.showError(context, 'Veuillez entrer le code complet à 6 chiffres');
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

      if (result['success'] == true && context.mounted) {
        ToastService.showSuccess(context, 'Code vérifié avec succès');
        
        // Navigate to reset password screen with email and code
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            Navigator.pushNamed(
              context,
              '/resetPassword',
              arguments: {'email': email, 'code': verificationCode},
            );
          }
        });
      } else if (context.mounted) {
        ToastService.showError(
          context,
          result['message'] ?? 'Code invalide ou expiré',
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      if (context.mounted) {
        ToastService.showError(
          context,
          'Une erreur est survenue. Veuillez réessayer.',
        );
      }
    }
  }

  /// Redemande un code de vérification
  Future<void> resendCode(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.requestPasswordReset(email);

      _isLoading = false;
      notifyListeners();

      if (result['success'] == true && context.mounted) {
        ToastService.showSuccess(
          context,
          'Code de réinitialisation renvoyé à $email',
        );
        // Clear le code précédent
        codeController.clear();
      } else if (context.mounted) {
        ToastService.showError(
          context,
          result['message'] ?? 'Erreur lors du renvoi du code',
        );
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      if (context.mounted) {
        ToastService.showError(
          context,
          'Une erreur est survenue. Veuillez réessayer.',
        );
      }
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    ToastService.cancelAll();
    super.dispose();
  }
}