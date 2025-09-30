import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_routes.dart';
import '../../viewmodels/SignInViewModel.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInViewModel(),
      child: Consumer<SignInViewModel>(
        builder: (context, model, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Welcome!',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),

                        // Email input
                        const SizedBox(height: 60),
                        TextFormField(
                          controller: model.emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                          ),
                        ),

                        // Password input
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: model.passwordController,
                          obscureText: !model.passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'Enter Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                model.passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.purple,
                              ),
                              onPressed: model.togglePasswordVisibility,
                            ),
                          ),
                        ),

                        // Sign In button
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => model.signIn(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Divider - social login
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),

                        // Social buttons
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: Icons.facebook,
                              color: Colors.blue,
                              onTap: () {
                                // TODO: Implémenter login Facebook
                              },
                            ),
                            const SizedBox(width: 32),
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.red,
                              onTap: () {
                                // TODO: Implémenter login Google
                              },
                            ),
                          ],
                        ),

                        // Forgot password
                        const SizedBox(height: 30),
                        Center(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.forgotPassword,
                            ),
                            child: Text(
                              'Forgot your password?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),

                        // Sign up
                        const SizedBox(height: 30),
                        Center(
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.signUp,
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don’t have an account? ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Sign up",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: color,
          ),
        ),
      ),
    );
  }
}
