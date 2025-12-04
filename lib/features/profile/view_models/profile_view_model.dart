import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/TokenHelper.dart';
import 'package:saloony/core/services/UserService.dart';

class ProfileViewModel extends ChangeNotifier {
    final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Loading state
  bool isLoading = false;
  String? errorMessage;
  
  // Selected local image
  File? selectedImageFile;

  // User data
  String fullName = "";
  String email = "";
  String phoneNumber = "";
  String gender = "";
  String avatarUrl = "assets/images/man-user.png";
  
  // Full user data
  Map<String, dynamic>? userData;

  // Controllers (useful for the edit page)
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  ProfileViewModel() {
    loadProfile();
  }

  // ==================== IMAGE MANAGEMENT ====================

  /// Choose an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImageFile = File(image.path);
        notifyListeners();
        
        // TODO: Upload the image to the server
        // await _uploadProfileImage(selectedImageFile!);
      }
    } catch (e) {
      errorMessage = 'Error selecting image: $e';
      notifyListeners();
    }
  }

  /// Take a photo with the camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedImageFile = File(image.path);
        notifyListeners();
        
        // TODO: Upload l'image vers le serveur
        // await _uploadProfileImage(selectedImageFile!);
      }
    } catch (e) {
      errorMessage = 'Erreur lors de la prise de photo: $e';
      notifyListeners();
    }
  }

  /// Afficher le dialog pour choisir la source de l'image
  void showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Color(0xFF1B2B3E)),
                  title: const Text('Galerie'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImageFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Color(0xFF1B2B3E)),
                  title: const Text('Appareil photo'),
                  onTap: () {
                    Navigator.pop(context);
                    pickImageFromCamera();
                  },
                ),
                if (selectedImageFile != null || avatarUrl.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Supprimer la photo'),
                    onTap: () {
                      Navigator.pop(context);
                      removeProfileImage();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Supprimer l'image de profil
  void removeProfileImage() {
    selectedImageFile = null;
    avatarUrl = "assets/images/man-user.png";
    notifyListeners();
    
    // TODO: Appeler l'API pour supprimer l'image sur le serveur
  }

  /// Upload l'image vers le serveur (à implémenter)
  Future<void> _uploadProfileImage(File imageFile) async {
    try {
      isLoading = true;
      notifyListeners();

      // TODO: Implémenter l'upload vers votre API
      // Exemple avec http multipart:
      /*
      import 'package:http/http.dart' as http;
      import 'dart:convert';
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${AuthService.baseUrl}/upload-avatar'),
      );
      
      final token = await _authService.getAccessToken();
      request.headers['Authorization'] = 'Bearer $token';
      
      request.files.add(
        await http.MultipartFile.fromPath('avatar', imageFile.path),
      );
      
      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        avatarUrl = data['avatarUrl'];
        selectedImageFile = null;
      }
      */

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Erreur lors de l\'upload de l\'image: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  // ==================== GESTION DU PROFIL ====================

  /// Charger les données du profil utilisateur
  Future<void> loadProfile() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Vérifier d'abord si l'utilisateur est authentifié
      final isAuth = await _authService.isAuthenticated();
      if (!isAuth) {
        errorMessage = "Utilisateur non authentifié";
        isLoading = false;
        notifyListeners();
        return;
      }

      // Récupérer les informations de l'utilisateur
      final response = await _authService.getCurrentUser();

      if (response['success'] == true && response['user'] != null) {
        userData = response['user'];
        
        // Extraire et formater les données
        final user = userData!;
        
        // Construire le nom complet
        final firstName = user['userFirstName'] ?? '';
        final lastName = user['userLastName'] ?? '';
        fullName = '$firstName $lastName'.trim();
        
        // Email
        email = user['userEmail'] ?? '';
        
        // Téléphone
        phoneNumber = user['userPhoneNumber'] ?? '';
        
        // Genre (convertir en français si nécessaire)
        final userGender = user['userGender'] ?? '';
        gender = userGender == 'MAN' ? 'Homme' : 
                 userGender == 'WOMAN' ? 'Femme' : userGender;
        
        // Avatar (si disponible dans l'API)
        if (user['userAvatar'] != null && user['userAvatar'].toString().isNotEmpty) {
          avatarUrl = user['userAvatar'];
        }

        // Pré-remplir les controllers pour l'édition
        fullNameController.text = fullName;
        emailController.text = email;
        phoneController.text = phoneNumber;

        errorMessage = null;
      } else {
        errorMessage = response['message'] ?? 'Impossible de charger le profil';
        
        // Si le token est expiré, essayer de le rafraîchir
        if (errorMessage!.contains('Token') || errorMessage!.contains('401')) {
          await _handleTokenRefresh();
        }
      }
    } catch (e) {
      errorMessage = 'Erreur lors du chargement du profil: $e';
      print('Error loading profile: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Gérer le rafraîchissement du token
  Future<void> _handleTokenRefresh() async {
    try {
      final refreshResponse = await _authService.refreshToken();
      
      if (refreshResponse['success'] == true) {
        // Réessayer de charger le profil
        await loadProfile();
      } else {
        errorMessage = 'Session expirée. Veuillez vous reconnecter.';
      }
    } catch (e) {
      errorMessage = 'Session expirée. Veuillez vous reconnecter.';
    }
  }

  /// Sauvegarde des modifications du profil
  Future<void> saveProfile() async {
    fullName = fullNameController.text;
    email = emailController.text;
    phoneNumber = phoneController.text;

    // TODO : Implémenter l'appel API pour mettre à jour le profil
    // Exemple : await _authService.updateProfile(...)
    
    print("Profil sauvegardé : $fullName, $email, $phoneNumber, $gender");

    notifyListeners();
  }

  /// Choix du genre
  void setGender(String value) {
    gender = value;
    notifyListeners();
  }

  /// Récupérer des informations depuis le token JWT
  Future<Map<String, dynamic>?> getTokenInfo() async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      return TokenHelper.decodeToken(token);
    }
    return null;
  }

  /// Vérifier si le token est expiré
  Future<bool> isTokenExpired() async {
    final token = await _authService.getAccessToken();
    return TokenHelper.isTokenExpired(token);
  }

  // ==================== NAVIGATION ====================

  void goToProfileEdit(BuildContext context) {
    Navigator.pushNamed(context, '/profileEdit');
  }

  void goToPaymentMethods(BuildContext context) {
    Navigator.pushNamed(context, '/paymentMethods');
  }

  void goToOrdersHistory(BuildContext context) {
    Navigator.pushNamed(context, '/edit_profile');
  }

  void goToChangePassword(BuildContext context) {
    Navigator.pushNamed(context, '/reset_password_profile');
  }
  void goToChangePhoneNumber(BuildContext context) {
    Navigator.pushNamed(context, '/phoneChange');
  }
void goToChangeEmail(BuildContext context) {
    Navigator.pushNamed(context, '/VerifyEmailChange');
  }


  void goToInvitesFriends(BuildContext context) {
    Navigator.pushNamed(context, '/InviteFriendsView');
  }

  void goToFaq(BuildContext context) {
    Navigator.pushNamed(context, '/faq');
  }

  void goToAboutUs(BuildContext context) {
    Navigator.pushNamed(context, '/aboutUs');
  }

  /// Déconnexion
  Future<void> logout(BuildContext context) async {
    try {
      await _authService.signOut();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
      }
    } catch (e) {
      print('Error during logout: $e');
      // Forcer la déconnexion même en cas d'erreur
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/sign_in', (route) => false);
      }
    }
  }

 Future<void> deactivateAccount(BuildContext context) async {
  try {
    final result = await _userService.deactivateAccount();

    if (result['success'] == true) {
      if (context.mounted) {
        await _authService.signOut();

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/splash',
          (route) => false,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Compte désactivé avec succès')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
  } catch (e) {
    print('Error during deactivateAccount: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la désactivation du compte')),
      );
    }
  }
}

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}