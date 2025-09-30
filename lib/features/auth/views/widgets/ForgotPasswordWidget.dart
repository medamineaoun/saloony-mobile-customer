import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/ForgotPasswordViewModel.dart';


class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: Consumer<ForgotPasswordViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black87),
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Forgot Password',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please enter your email address to reset your password.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 60),
                    TextFormField(
                      controller: viewModel.emailController,
                      focusNode: viewModel.emailFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                      ),
                      validator: viewModel.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => viewModel.sendResetLink(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Send Link',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
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
