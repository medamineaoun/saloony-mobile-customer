import 'package:flutter/material.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/ToastService.dart';

class SignUpViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _selectedGender = '';
  String get selectedGender => _selectedGender;

  String? _genderError;
  String? get genderError => _genderError;

  bool _termsAccepted = false;
  bool get termsAccepted => _termsAccepted;

  String? _termsError;
  String? get termsError => _termsError;

  // Toggle password
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void setGender(String gender) {
    _selectedGender = gender;
    _genderError = null;
    notifyListeners();
  }

  void setTermsAccepted(bool value) {
    _termsAccepted = value;
    _termsError = null;
    notifyListeners();
  }

  // ---------------- VALIDATORS ----------------

  String? validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
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
    if (value == null || value.trim().isEmpty) return null;

    if (!RegExp(r'^\+?[\d\s-]{8,}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 8) return 'Password must be at least 8 characters';

    List<String> missing = [];

    if (!RegExp(r'[A-Z]').hasMatch(value)) missing.add('uppercase letter');
    if (!RegExp(r'[a-z]').hasMatch(value)) missing.add('lowercase letter');
    if (!RegExp(r'[0-9]').hasMatch(value)) missing.add('number');
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      missing.add('special character (!@#\$&*~)');
    }

    if (missing.isNotEmpty) return 'Missing: ${missing.join(', ')}';

    return null;
  }

  // ---------------- SIGN UP ----------------

  Future<void> signUp(BuildContext context) async {
    // 1️⃣ Validate form
    if (!formKey.currentState!.validate()) {
      ToastService.showError(context, 'Please fill all required fields');
      return;
    }

    // 2️⃣ Validate gender
    if (_selectedGender.isEmpty) {
      _genderError = 'Please select your gender';
      notifyListeners();
      ToastService.showError(context, 'Please select your gender');
      return;
    }

    // 3️⃣ Validate terms
    if (!_termsAccepted) {
      _termsError =
          'You must accept the Terms & Conditions and Privacy Policy';
      notifyListeners();
      ToastService.showError(context, 'Please accept the terms');
      return;
    }

    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final phone = phoneController.text.trim().isEmpty
        ? ""
        : phoneController.text.trim();

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        phoneNumber: phone,
        gender: _selectedGender,
        role: "CUSTOMER",
      );

      _isLoading = false;
      notifyListeners();

      final message =
          result['message'] ?? 'Registration completed successfully.';

      if (result['success']) {
        clearFields();
        ToastService.showSuccess(context, message);

        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushNamed(context, "/verifyEmail", arguments: email);
      } else {
        ToastService.showError(context, message);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ToastService.showError(context, "Unexpected error: $e");
    }
  }

  // ---------------- RESET FORM ----------------
  void clearFields() {
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();

    _selectedGender = '';
    _genderError = null;
    _termsAccepted = false;
    _termsError = null;

    notifyListeners();
  }

  // ---------------- DISPOSE ----------------
  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
