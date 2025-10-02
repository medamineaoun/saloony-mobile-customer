import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedGender = ''; // Vide par défaut pour forcer la sélection
  String get selectedGender => _selectedGender;

  String? _genderError;
  String? get genderError => _genderError;

  final AuthService _authService = AuthService();

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    _genderError = null; // Efface l'erreur quand un genre est sélectionné
    notifyListeners();
  }

  void setGenderError(String error) {
    _genderError = error;
    notifyListeners();
  }

  void clearGenderError() {
    _genderError = null;
    notifyListeners();
  }

  // Validateurs
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (!RegExp(r'^\+?[\d\s-]{8,}$').hasMatch(value)) {
        return 'Please enter a valid phone number';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Must contain at least one number';
    }
    return null;
  }

  Future<void> signUp(BuildContext context) async {
    // Validation du formulaire
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validation du genre
    if (_selectedGender.isEmpty) {
      setGenderError('Please select your gender');
      return;
    }

    // Récupération des valeurs
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

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