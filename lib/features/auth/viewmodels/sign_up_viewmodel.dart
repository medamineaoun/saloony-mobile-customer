import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class SignUpViewModel extends ChangeNotifier {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedGender = 'MAN'; // MAN ou WOMAN
  String get selectedGender => _selectedGender;

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context) async {
    // Récupération des valeurs
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    // Validation des champs
    if (!_validateInputs(context, fullName, email, password, phone)) {
      return;
    }

    // Séparer prénom et nom
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 
        ? nameParts.sublist(1).join(' ') 
        : '';

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phone.isEmpty ? "00000000" : phone,
        gender: _selectedGender,  // MAN ou WOMAN
        role: "CUSTOMER",         // Par défaut CUSTOMER
      );

      _isLoading = false;
      notifyListeners();

      if (result['success']) {
        _showSuccessSnackBar(context, result['message']);
        
        // Navigation vers la page de vérification avec l'email
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushNamed(
          context,
          "/verifyEmail",
          arguments: email,
        );
      } else {
        _showErrorSnackBar(context, result['message']);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      _showErrorSnackBar(context, "Erreur inattendue: $e");
    }
  }

  bool _validateInputs(
    BuildContext context,
    String fullName,
    String email,
    String password,
    String phone,
  ) {
    if (fullName.isEmpty) {
      _showErrorSnackBar(context, "Le nom complet est obligatoire");
      return false;
    }

    if (email.isEmpty) {
      _showErrorSnackBar(context, "L'email est obligatoire");
      return false;
    }

    if (!_isValidEmail(email)) {
      _showErrorSnackBar(context, "Format d'email invalide");
      return false;
    }

    if (password.isEmpty) {
      _showErrorSnackBar(context, "Le mot de passe est obligatoire");
      return false;
    }

    if (password.length < 8) {
      _showErrorSnackBar(
        context,
        "Le mot de passe doit contenir au moins 8 caractères",
      );
      return false;
    }

    if (phone.isNotEmpty && !_isValidPhone(phone)) {
      _showErrorSnackBar(context, "Format de téléphone invalide");
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^\d{8,15}$').hasMatch(phone);
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}