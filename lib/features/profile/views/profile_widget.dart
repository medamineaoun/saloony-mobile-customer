import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/profile_view_model.dart';
import 'ProfileNavcardWidget.dart';


class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Avatar + nom + email
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              vm.avatarUrl,
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                vm.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 24),
                                onPressed: () => vm.goToProfileEdit(context),
                              ),
                            ],
                          ),
                          Text(
                            vm.email,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Navigation cards
                    Expanded(
                      child: ListView(
                        children: [
                          ProfileNavcardWidget(
                            navName: 'Payment Methods',
                            navIcon: const Icon(Icons.credit_card),
                            onTap: () => vm.goToPaymentMethods(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'Orders History',
                            navIcon: const Icon(Icons.history),
                            onTap: () => vm.goToOrdersHistory(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'Change Password',
                            navIcon: const Icon(Icons.lock_outline),
                            onTap: () => vm.goToChangePassword(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'Invites Friends',
                            navIcon: const Icon(Icons.people_alt_outlined),
                            onTap: () => vm.goToInvitesFriends(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'FAQs',
                            navIcon: const Icon(Icons.question_answer),
                            onTap: () => vm.goToFaq(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'About us',
                            navIcon: const Icon(Icons.info_outline),
                            onTap: () => vm.goToAboutUs(context),
                          ),
                          ProfileNavcardWidget(
                            navName: 'Logout',
                            navIcon: const Icon(Icons.logout),
                            onTap: () => vm.logout(context),
                          ),
                        ],
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
