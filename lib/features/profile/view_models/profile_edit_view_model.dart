import 'package:flutter/material.dart';

class ProfileEditViewModel extends ChangeNotifier {
  // Controllers pour les TextFields
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // Choice chips pour le genre
  String? gender;

  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  void saveProfile() {
    // ici tu appelles ton API ou sauvegarde local
    print('Saved profile: ${fullNameController.text}, $gender');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
