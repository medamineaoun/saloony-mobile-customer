import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/ResetPasswordViewModel.dart';


class ResetPasswordWidget extends StatelessWidget {
  const ResetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordViewModel(),
      child: Consumer<ResetPasswordViewModel>(
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text("Reset Password"),
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.black),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Enter your new password",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Password
                    TextFormField(
                      controller: vm.passwordController,
                      obscureText: !vm.passwordVisible1,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(vm.passwordVisible1
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: vm.togglePasswordVisibility1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    TextFormField(
                      controller: vm.confirmPasswordController,
                      obscureText: !vm.passwordVisible2,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(vm.passwordVisible2
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: vm.togglePasswordVisibility2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => vm.changePassword(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
