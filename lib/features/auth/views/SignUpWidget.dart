import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/features/auth/viewmodels/sign_up_viewmodel.dart';
import 'package:saloony/core/constants/app_routes.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  static String routeName = 'signUp';
  static String routePath = '/signUp';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignUpViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE1E2E2)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: Color(0xFF1B2B3E),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Form(
                  key: vm.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Image de signup
                      Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'assets/images/bbb.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF1B2B3E).withOpacity(0.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_add_outlined,
                                    size: 70,
                                    color: Color(0xFFF0CD97),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Titre
                      Text(
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign up to get started with Saloony",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // First Name et Last Name sur la même ligne
                      Row(
                        children: [
                          Expanded(
                            child: _buildValidatedTextField(
                              controller: vm.firstNameController,
                              enabled: !vm.isLoading,
                              label: "First Name",
                              hint: "Enter first name",
                              icon: Icons.person_outline_rounded,
                              validator: vm.validateFirstName,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildValidatedTextField(
                              controller: vm.lastNameController,
                              enabled: !vm.isLoading,
                              label: "Last Name",
                              hint: "Enter last name",
                              icon: Icons.person_outline_rounded,
                              validator: vm.validateLastName,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Email avec validation
                      _buildValidatedTextField(
                        controller: vm.emailController,
                        enabled: !vm.isLoading,
                        label: "Email",
                        hint: "Enter your email",
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: vm.validateEmail,
                      ),
                      const SizedBox(height: 20),

                      _buildValidatedTextField(
                        controller: vm.phoneController,
                        enabled: !vm.isLoading,
                        label: "Phone Number",
                        hint: "Enter your phone number",
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: vm.validatePhone,
                      ),
                      const SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Gender",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "*",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GenderOption(
                                  label: "Man",
                                  value: "MEN",
                                  selectedValue: vm.selectedGender,
                                  onTap: () => vm.setGender("MEN"),
                                  isEnabled: !vm.isLoading,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GenderOption(
                                  label: "Woman",
                                  value: "WOMEN",
                                  selectedValue: vm.selectedGender,
                                  onTap: () => vm.setGender("WOMEN"),
                                  isEnabled: !vm.isLoading,
                                ),
                              ),
                            ],
                          ),
                          if (vm.genderError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Text(
                                vm.genderError!,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.red,
                                  height: 1.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Password",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "*",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: vm.passwordController,
                            enabled: !vm.isLoading,
                            obscureText: !vm.passwordVisible,
                            validator: vm.validatePassword,
                            decoration: InputDecoration(
                              hintText: "At least 8 characters",
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.grey[400],
                                fontSize: 15,
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xFFF0CD97),
                                size: 22,
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
                                  color: Color(0xFF1B2B3E),
                                  width: 2,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[200]!),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              errorStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                height: 1.5,
                              ),
                              errorMaxLines: 2,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  vm.passwordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: const Color(0xFFF0CD97),
                                  size: 22,
                                ),
                                onPressed: vm.togglePasswordVisibility,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: vm.termsError != null 
                                ? Colors.red 
                                : Colors.grey[300]!,
                            width: vm.termsError != null ? 2 : 1,
                          ),
                        ),
                        child: Theme(
                          data: ThemeData(
                            unselectedWidgetColor: Colors.grey[400],
                          ),
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            dense: true,
                            title: Text.rich(
                              TextSpan(
                                text: "I agree to the ",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF1B2B3E),
                                ),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF1B2B3E),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: const Color(0xFF1B2B3E),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            value: vm.termsAccepted,
                            onChanged: vm.isLoading 
                                ? null 
                                : (value) => vm.setTermsAccepted(value ?? false),
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: const Color(0xFF1B2B3E),
                            checkColor: const Color(0xFFF0CD97),
                          ),
                        ),
                      ),
                      if (vm.termsError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            vm.termsError!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.red,
                              height: 1.5,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Sign Up Button
                      Container(
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: vm.isLoading
                                ? [Colors.grey[400]!, Colors.grey[400]!]
                                : [const Color(0xFF1B2B3E), const Color(0xFF243441)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: vm.isLoading
                              ? []
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF1B2B3E).withOpacity(0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                        ),
                        child: ElevatedButton(
                          onPressed: vm.isLoading ? null : () => vm.signUp(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: vm.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF0CD97)),
                                  ),
                                )
                              : Text(
                                  "Sign Up",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFF0CD97),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: InkWell(
                          onTap: vm.isLoading
                              ? null
                              : () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.signIn,
                                  );
                                },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: "Sign In",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: vm.isLoading
                                        ? Colors.grey
                                        : const Color(0xFF1B2B3E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildValidatedTextField({
    required TextEditingController controller,
    required bool enabled,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1B2B3E),
              ),
            ),
            // Ajouter * seulement si pas "Optional" dans le label
            if (!label.contains("Optional")) ...[
              const SizedBox(width: 4),
              Text(
                "*",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFFF0CD97),
              size: 22,
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
                color: Color(0xFF1B2B3E),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            errorStyle: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget pour la sélection du genre avec images
class GenderOption extends StatelessWidget {
  final String label;
  final String value;
  final String selectedValue;
  final VoidCallback onTap;
  final bool isEnabled;

  const GenderOption({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF1B2B3E).withOpacity(0.08) 
              : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Utilisation d'images au lieu d'icônes
            Container(
              width: 24,
              height: 24,
              child: Image.asset(
                value == "MEN" 
                    ? 'images/iconss/homme.png'
                    : 'images/iconss/woman.png',
                color: isSelected ? const Color(0xFFF0CD97) : Colors.grey[600],
                errorBuilder: (context, error, stackTrace) {
                  // Fallback si l'image n'est pas trouvée
                  return Icon(
                    value == "MEN" ? Icons.boy : Icons.girl,
                    color: isSelected ? const Color(0xFFF0CD97) : Colors.grey[600],
                    size: 30,
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? const Color(0xFF1B2B3E) : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}