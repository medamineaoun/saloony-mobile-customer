import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/UserService.dart';
import 'package:saloony/core/services/ToastService.dart';
import 'package:saloony/core/models/User.dart';

class VerifyEmailChangeView extends StatefulWidget {
  const VerifyEmailChangeView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailChangeView> createState() => _VerifyEmailChangeViewState();
}

class _VerifyEmailChangeViewState extends State<VerifyEmailChangeView> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _newEmailController = TextEditingController();
  
  // 6 controllers pour les 6 cases du code PIN
  final List<TextEditingController> _pinControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _pinFocusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  
  bool _isLoading = false;
  bool _codeSent = false;
  String _currentEmail = '';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _authService.getCurrentUser();
      if (result['success'] == true && result['user'] != null) {
        setState(() {
          _currentUser = User.fromJson(result['user']);
          _currentEmail = _currentUser!.userEmail;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Erreur lors du chargement de l\'utilisateur');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ToastService.showError(context, 'Erreur de connexion');
    }
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    for (var controller in _pinControllers) {
      controller.dispose();
    }
    for (var node in _pinFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getPinCode() {
    return _pinControllers.map((c) => c.text).join();
  }

  void _clearPinCode() {
    for (var controller in _pinControllers) {
      controller.clear();
    }
    _pinFocusNodes[0].requestFocus();
  }

  Future<void> _sendVerificationCode() async {
    if (_currentEmail.isEmpty) {
      ToastService.showError(context, 'Email actuel non disponible');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.requestPasswordReset(_currentEmail);

      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          setState(() => _codeSent = true);
          ToastService.showSuccess(context, 'Code envoyé à $_currentEmail');
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _pinFocusNodes[0].requestFocus();
          });
        } else {
          ToastService.showError(
            context,
            result['message'] ?? 'Erreur lors de l\'envoi du code',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Erreur de connexion');
      }
    }
  }

  Future<void> _verifyAndUpdateEmail() async {
    final code = _getPinCode();
    final newEmail = _newEmailController.text.trim();

    if (code.length != 6) {
      ToastService.showError(context, 'Veuillez entrer le code complet');
      return;
    }

    if (newEmail.isEmpty) {
      ToastService.showError(context, 'Veuillez entrer le nouvel email');
      return;
    }

    if (!_isValidEmail(newEmail)) {
      ToastService.showError(context, 'Format d\'email invalide');
      return;
    }

    if (newEmail == _currentEmail) {
      ToastService.showError(context, 'Le nouvel email doit être différent');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final verifyResult = await _authService.verifyResetCode(
        email: _currentEmail,
        code: code,
      );

      if (verifyResult['success'] != true) {
        if (mounted) {
          setState(() => _isLoading = false);
          ToastService.showError(
            context,
            verifyResult['message'] ?? 'Code invalide ou expiré',
          );
          _clearPinCode();
        }
        return;
      }

      final updateResult = await _userService.updateEmail(
        code: code,
        newEmail: newEmail,
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (updateResult['success'] == true) {
          ToastService.showSuccess(
            context,
            'Email mis à jour avec succès ! Reconnexion requise',
          );

          await _authService.signOut();

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/signIn', 
                (route) => false,
              );
            }
          });
        } else {
          ToastService.showError(
            context,
            updateResult['message'] ?? 'Erreur lors de la mise à jour',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Erreur de connexion');
      }
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _resendCode() async {
    if (_currentEmail.isEmpty) {
      ToastService.showError(context, 'Email actuel non disponible');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.requestPasswordReset(_currentEmail);

      if (mounted) {
        setState(() => _isLoading = false);
        
        if (result['success'] == true) {
          ToastService.showSuccess(context, 'Code renvoyé avec succès');
          _clearPinCode();
        } else {
          ToastService.showError(
            context,
            result['message'] ?? 'Erreur lors de l\'envoi',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ToastService.showError(context, 'Erreur de connexion');
      }
    }
  }

  Widget _buildPinBox(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _pinControllers[index].text.isNotEmpty
              ? SaloonyColors.primary
              : Colors.grey[300]!,
          width: _pinControllers[index].text.isNotEmpty ? 2 : 1,
        ),
        boxShadow: _pinControllers[index].text.isNotEmpty
            ? [
                BoxShadow(
                  color: SaloonyColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: TextField(
        controller: _pinControllers[index],
        focusNode: _pinFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: SaloonyColors.primary,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          setState(() {});
          
          if (value.isNotEmpty && index < 5) {
            _pinFocusNodes[index + 1].requestFocus();
          }
          
          if (value.isEmpty && index > 0) {
            _pinFocusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SaloonyColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Changer l\'email',
          style: GoogleFonts.poppins(
            color: SaloonyColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  
                  // Logo
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SaloonyColors.primary,
                            SaloonyColors.navy,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: SaloonyColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 56,
                        color: SaloonyColors.secondary,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Titre
                  Text(
                    'Changez votre\nadresse e-mail',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.primary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Email actuel
                  if (_currentEmail.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: SaloonyColors.primary.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email actuel',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _currentEmail,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: SaloonyColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Description
                  Text(
                    _codeSent 
                      ? 'Entrez le code reçu sur votre email actuel et votre nouvel email'
                      : 'Un code de vérification sera envoyé à votre email actuel',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: SaloonyColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bouton envoyer le code (si pas encore envoyé)
                  if (!_codeSent) ...[
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SaloonyColors.primary,
                            SaloonyColors.navy,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: SaloonyColors.primary.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading || _currentEmail.isEmpty ? null : _sendVerificationCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.send_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Envoyer le code',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                  
                  // Formulaire (si code envoyé)
                  if (_codeSent) ...[
                    // Code PIN avec 6 cases
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Code de vérification',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: SaloonyColors.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            6,
                            (index) => _buildPinBox(index),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Champ nouvel email
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nouvel email',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: SaloonyColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _newEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: 'nouveau@email.com',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey[400],
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: SaloonyColors.secondary,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: SaloonyColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Bouton "Renvoyer le code"
                    Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _resendCode,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: SaloonyColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Renvoyer le code',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: SaloonyColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Bouton Vérifier
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            SaloonyColors.secondary,
                            SaloonyColors.gold,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: SaloonyColors.secondary.withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyAndUpdateEmail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    SaloonyColors.primary,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Mettre à jour l\'email',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: SaloonyColors.primary,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.check_circle_outline_rounded,
                                    size: 20,
                                    color: SaloonyColors.primary,
                                  ),
                                ],
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Info de sécurité
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: SaloonyColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: SaloonyColors.primary.withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 20,
                            color: SaloonyColors.primary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Le code expire dans 15 minutes',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: SaloonyColors.primary.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}