import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  // Données utilisateur
  String fullName = "";
  String email = "";
  String address = "";
  String avatarUrl =
      "https://images.unsplash.com/photo-1566492031773-4f4e44671857?w=500&auto=format&fit=crop&q=60";

  String? gender;

  // Controllers (utile pour la page d’édition)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Charger les données (exemple : depuis API ou SharedPreferences)
  Future<void> loadProfile() async {
    // TODO : remplacer par appel backend
    fullName = "Anil Kumar";
    email = "anil29creative@gmail.com";
    address = "Tunis, Tunisie";
    gender = "Homme";

    // Pré-remplir les champs pour l’édition
    fullNameController.text = fullName;
    emailController.text = email;
    addressController.text = address;

    notifyListeners();
  }

  // Sauvegarde des modifications
  Future<void> saveProfile() async {
    fullName = fullNameController.text;
    email = emailController.text;
    address = addressController.text;

    // TODO : envoyer au backend
    print("Profil sauvegardé : $fullName, $email, $address, $gender");

    notifyListeners();
  }

  // Choix du genre
  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  // Navigation
  void goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/profileEdit');
  }

  void goToPaymentMethods(BuildContext context) {
    Navigator.pushNamed(context, '/paymentMethods');
  }

  void goToOrdersHistory(BuildContext context) {
    Navigator.pushNamed(context, '/ordersHistory');
  }

  void goToChangePassword(BuildContext context) {
    Navigator.pushNamed(context, '/changePassword');
  }

  void goToInvitesFriends(BuildContext context) {
    Navigator.pushNamed(context, '/invitesFriends');
  }

  void goToFaq(BuildContext context) {
    Navigator.pushNamed(context, '/faq');
  }

  void goToAboutUs(BuildContext context) {
    Navigator.pushNamed(context, '/aboutUs');
  }

  void logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/splash', (route) => false);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
