import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Importez votre ViewModel
// import '../view_models/change_password_view_model.dart';

class ChangePasswordWidget extends StatelessWidget {
  const ChangePasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Remplacez par votre ViewModel
    // return ChangeNotifierProvider(
    //   create: (_) => ChangePasswordViewModel(),
    //   child: Consumer<ChangePasswordViewModel>(
    //     builder: (context, vm, child) {
    
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
        title: Text(
          'Change Password',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
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
                      Icons.lock_reset_rounded,
                      size: 70,
                      color: Color(0xFFF0CD97),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Secure Your Account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a strong password to protect your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 40),

                // Current Password
                _buildPasswordField(
                  label: 'Current Password',
                  hint: 'Enter current password',
                  // controller: vm.currentPasswordController,
                  // obscureText: !vm.currentPasswordVisible,
                  // onToggle: vm.toggleCurrentPassword,
                ),
                
                const SizedBox(height: 20),

                // New Password
                _buildPasswordField(
                  label: 'New Password',
                  hint: 'Enter new password',
                  // controller: vm.newPasswordController,
                  // obscureText: !vm.newPasswordVisible,
                  // onToggle: vm.toggleNewPassword,
                ),
                
                const SizedBox(height: 20),

                // Confirm Password
                _buildPasswordField(
                  label: 'Confirm Password',
                  hint: 'Confirm new password',
                  // controller: vm.confirmPasswordController,
                  // obscureText: !vm.confirmPasswordVisible,
                  // onToggle: vm.toggleConfirmPassword,
                ),
                
                const SizedBox(height: 12),

                // Password requirements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0CD97).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFF0CD97).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password must contain:',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1B2B3E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement('At least 8 characters'),
                      _buildRequirement('One uppercase letter'),
                      _buildRequirement('One lowercase letter'),
                      _buildRequirement('One number'),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Update button
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1B2B3E).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // vm.changePassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Update Password',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFF0CD97),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    //     },
    //   ),
    // );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    // TextEditingController? controller,
    // bool obscureText = true,
    // VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B2B3E),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          // controller: controller,
          obscureText: true, // obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.lock_outline_rounded,
              color: Color(0xFFF0CD97),
              size: 22,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.visibility_off_outlined,
                color: Color(0xFFF0CD97),
                size: 22,
              ),
              onPressed: () {}, // onToggle,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: Color(0xFF1B2B3E),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}