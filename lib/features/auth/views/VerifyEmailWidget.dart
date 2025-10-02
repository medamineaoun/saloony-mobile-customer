import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'package:saloony/features/auth/viewmodels/VerifyEmailViewModel.dart';


class VerifyEmailWidget extends StatelessWidget {
  const VerifyEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;

    return ChangeNotifierProvider(
      create: (_) => VerifyEmailViewModel(email),
      child: Consumer<VerifyEmailViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Vérification Email"),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Un code de vérification a été envoyé à :",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 30),

                  // Champ code
                  TextField(
                    controller: vm.codeController,
                    decoration: const InputDecoration(
                      labelText: "Code de vérification",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Bouton vérifier
                  ElevatedButton(
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final success = await vm.verifyCode();
                            if (success && context.mounted) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.home);
                            } else if (!success && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Code invalide ou expiré")),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: vm.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Vérifier"),
                  ),

                  const SizedBox(height: 15),

                  // Bouton renvoyer
                // Dans VerifyEmailWidget, modifiez le bouton renvoyer :
TextButton(
  onPressed: vm.isLoading 
    ? null 
    : () async {
        final success = await vm.resendCode();
        if (success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Nouveau code envoyé !"),
              backgroundColor: Colors.green,
            ),
          );
          // Effacer l'ancien code
          vm.codeController.clear();
        } else if (!success && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Erreur lors de l'envoi du code"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
  child: const Text("Renvoyer le code"),
)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
