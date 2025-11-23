import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';
import 'package:saloony/core/constants/app_routes.dart';

class SignInViewModel extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validation des champs
    if (email.isEmpty || password.isEmpty) {
      ToastService.showError(
        context,
        'Please enter your email and password',
      );
      return;
    }

    // Validation du format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      ToastService.showError(
        context,
        'Please enter a valid email address',
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final authService = AuthService();
      final result = await authService.signIn(
        email: email,
        password: password,
      );

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        // ✅ Connexion réussie
        ToastService.showSuccess(context, 'Welcome back!');
        
        // Petit délai pour afficher le message de succès
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Navigation vers l'accueil
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        
      } else {
        // ❌ Échec de connexion
        final message = result['message'] ?? 'Login failed';
        final status = result['status'];
        
        // 🔔 Vérification si le compte est en attente de vérification
        if (status == 'PENDING' || 
            message.toLowerCase().contains('verify') || 
            message.toLowerCase().contains('verification') ||
            message.toLowerCase().contains('pending')) {
          
          // Redirection vers la page de vérification d'email
          ToastService.showInfo(
            context,
            'Please verify your email to continue',
          );
          
          await Future.delayed(const Duration(milliseconds: 500));
          
          Navigator.pushNamed(
            context,
            AppRoutes.verifyEmail,
            arguments: email,
          );
          
        } else {
          // Autre erreur (mauvais mot de passe, compte inexistant, etc.)
          ToastService.showError(context, message);
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      
      ToastService.showError(
        context,
        'Connection error. Please try again.',
      );
      
      // Log de l'erreur pour le debug
      debugPrint('Sign In Error: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}