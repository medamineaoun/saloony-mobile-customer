import 'package:flutter/material.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/core/services/AuthService.dart';

class NewPasswordView extends StatefulWidget {
  final String email;
  final String code;
 
  const NewPasswordView({
    Key? key,
    required this.email,
    required this.code,
  }) : super(key: key);
  
  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final AuthService _authService = AuthService();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
 
  bool _isLoading = false;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  
  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  Future<void> _resetPassword() async {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    // Validation
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs', isError: true);
      return;
    }
    
    if (newPassword != confirmPassword) {
      _showSnackBar('Les mots de passe ne correspondent pas', isError: true);
      return;
    }
    
    if (newPassword.length < 8) {
      _showSnackBar('Le mot de passe doit contenir au moins 8 caractères', isError: true);
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await _authService.resetPassword(
        email: widget.email,
        code: widget.code,
        newPassword: newPassword,
      );
     
      if (mounted) {
        setState(() => _isLoading = false);
       
        if (result['success'] == true) {
          _showSnackBar('Mot de passe modifié avec succès');
         
          // Retour à la page de connexion après 2 secondes
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.profile,
        (route) => false, // supprime toutes les routes précédentes
      );
            }
          });
        } else {
          _showSnackBar(
            result['message'] ?? 'Erreur lors de la réinitialisation',
            isError: true,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSnackBar('Erreur de connexion', isError: true);
      }
    }
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
        backgroundColor: SaloonyColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Nouveau mot de passe',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              
              // Icône
              Icon(
                Icons.lock_reset,
                size: 80,
                color: SaloonyColors.primary,
              ),
              
              const SizedBox(height: 24),
              
              // Titre
              Text(
                'Créer un nouveau mot de passe',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                'Votre nouveau mot de passe doit être différent des mots de passe précédents',
                style: TextStyle(
                  fontSize: 14,
                  color: SaloonyColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Champ nouveau mot de passe
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  hintText: 'Entrez votre nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline, color: SaloonyColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                      color: SaloonyColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SaloonyColors.primary, width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Champ confirmation mot de passe
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  hintText: 'Confirmez votre nouveau mot de passe',
                  prefixIcon: Icon(Icons.lock_outline, color: SaloonyColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      color: SaloonyColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: SaloonyColors.primary, width: 2),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Indication de sécurité
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: SaloonyColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: SaloonyColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Le mot de passe doit contenir au moins 8 caractères',
                        style: TextStyle(
                          fontSize: 12,
                          color: SaloonyColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Bouton de réinitialisation
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: SaloonyColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Réinitialiser le mot de passe',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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