import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/features/profile/views/NewPasswordView.dart';

class VerifyResetCodeView extends StatefulWidget {
  final String email;
  
  const VerifyResetCodeView({Key? key, required this.email}) : super(key: key);

  @override
  State<VerifyResetCodeView> createState() => _VerifyResetCodeViewState();
}

class _VerifyResetCodeViewState extends State<VerifyResetCodeView> {
  final AuthService _authService = AuthService();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 6) {
      _showSnackBar('Veuillez entrer le code complet', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.verifyResetCode(
        email: widget.email,
        code: code,
      );
      
      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPasswordView(
                email: widget.email,
                code: code,
              ),
            ),
          );
        } else {
          _showSnackBar(
            result['message'] ?? 'Code invalide ou expiré',
            isError: true,
          );
          _clearFields();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Erreur de connexion', isError: true);
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);

    try {
      final result = await _authService.requestPasswordReset(widget.email);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _resendTimer = 60;
        });
        _startTimer();
        
        _showSnackBar(
          result['message'] ?? 'Code renvoyé',
          isError: result['success'] != true,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Erreur de connexion', isError: true);
      }
    }
  }

  void _clearFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? SaloonyColors.error : SaloonyColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: SaloonyColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SaloonyColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Réinitialiser le mot de passe',
          style: TextStyle(
            color: SaloonyColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: SaloonyColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 48,
                  color: SaloonyColors.secondary,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Le code de vérification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                'Saisissez le code de vérification à 6 chiffres envoyé à votre adresse e-mail pour confirmer votre identité.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: SaloonyColors.textSecondary,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Code Input Fields - 6 chiffres
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: SaloonyColors.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: SaloonyColors.tertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: SaloonyColors.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        
                        // Auto-submit when all fields are filled
                        if (index == 5 && value.isNotEmpty) {
                          _verifyCode();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: 24),
              
              // Resend Code Timer
              TextButton(
                onPressed: _resendTimer == 0 && !_isLoading ? _resendCode : null,
                child: Text(
                  _resendTimer > 0
                      ? 'Renvoyer le code dans ${_resendTimer}s'
                      : 'Renvoyer le code',
                  style: TextStyle(
                    color: _resendTimer == 0
                        ? SaloonyColors.secondary
                        : SaloonyColors.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SaloonyColors.secondary,
                    foregroundColor: SaloonyColors.primary,
                    elevation: 0,
                    disabledBackgroundColor: SaloonyColors.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              SaloonyColors.primary,
                            ),
                          ),
                        )
                      : const Text(
                          'Continuer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}