import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_routes.dart';
import '../../viewmodels/sign_up_viewmodel.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({super.key});

  static String routeName = 'signUp';
  static String routePath = '/signUp';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SignUpViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Sign up",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create a new account",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),

              // Full name
              TextField(
                controller: vm.fullNameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: vm.emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),

              // Password
              TextField(
                controller: vm.passwordController,
                obscureText: !vm.passwordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.deepPurple,
                    ),
                    onPressed: vm.togglePasswordVisibility,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Sign Up Button
              ElevatedButton(
                onPressed: () => vm.signUp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Sign up",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Terms & Conditions
              Text.rich(
                TextSpan(
                  text: "By continuing, you agree to our ",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  children: [
                    TextSpan(
                      text: "Terms & Conditions",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: " without reservation."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Already have an account ? Sign In
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.signIn);

                    },
                    child: Text(
                      "Sign in",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
