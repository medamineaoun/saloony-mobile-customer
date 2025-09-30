import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/profile_edit_view_model.dart';

class ProfileEditViewModel extends ChangeNotifier {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? gender;

  void setGender(String? value) {
    gender = value;
    notifyListeners();
  }

  void saveProfile() {
    // Sauvegarde les données
    print('Full Name: ${fullNameController.text}');
    print('Email: ${emailController.text}');
    print('Address: ${addressController.text}');
    print('Gender: $gender');
  }
}
