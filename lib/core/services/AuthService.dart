import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/TokenHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String get baseUrl => Config.authBaseUrl;

  static String get _accessTokenKey => Config.accessTokenKey;
  static String get _refreshTokenKey => Config.refreshTokenKey;

  // ==================== inscription ====================

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userFirstName': firstName,
          'userLastName': lastName,
          'userEmail': email,
          'password': password,
          'userPhoneNumber': phoneNumber,
          'userGender': gender,
          'appRole': role,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de l\'inscription',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== CONNEXION ====================

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/authenticate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userEmail': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Sauvegarde des tokens
        await _saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );

        return {
          'success': true,
          'accessToken': data['access_token'],
          'refreshToken': data['refresh_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Email ou mot de passe incorrect',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== VÉRIFICATION SIGNUP ====================

  Future<Map<String, dynamic>> requestSignupVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-signup-verification?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': 'Erreur lors de l\'envoi du code'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Vérifier le code et activer le compte
  Future<Map<String, dynamic>> verifySignupCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-code-signup?email=$email&code=$code'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        await _saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );

        return {
          'success': true,
          'accessToken': data['access_token'],
          'refreshToken': data['refresh_token'],
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Code invalide ou expiré',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== RÉINITIALISATION MOT DE PASSE ====================

  /// Étape 1 : Demander un code de réinitialisation
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-reset?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': 'Utilisateur non trouvé'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Étape 2 : Vérifier le code
  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-code?email=$email&code=$code'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': 'Code invalide ou expiré'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Étape 3 : Réinitialiser le mot de passe
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/reset-password?email=$email&code=$code&newPassword=$newPassword',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la réinitialisation',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== MISE À JOUR EMAIL ====================

  /// Demander la mise à jour de l'email
  Future<Map<String, dynamic>> requestEmailUpdate({
    required String userId,
    required String newEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-update?userId=$userId&newEmail=$newEmail'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': 'Email déjà utilisé'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Mettre à jour l'email avec le code
  Future<Map<String, dynamic>> updateEmail({
    required String userId,
    required String code,
    required String newEmail,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/update-email?userId=$userId&code=$code&newEmail=$newEmail',
        ),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.body};
      } else {
        return {'success': false, 'message': 'Code invalide ou expiré'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== TOKENS & USER ====================

  /// Rafraîchir le token d'accès
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return {'success': false, 'message': 'Aucun refresh token disponible'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/refreshToken'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
        );

        return {'success': true, 'accessToken': data['access_token']};
      } else {
        return {'success': false, 'message': 'Token invalide ou expiré'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  /// Récupérer l'utilisateur actuel
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/currentUser'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return {'success': true, 'user': userData};
      } else {
        return {
          'success': false,
          'message': 'Impossible de récupérer l\'utilisateur',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Erreur de connexion: ${e.toString()}',
      };
    }
  }

  // ==================== DÉCONNEXION ====================

  /// Déconnecter l'utilisateur
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  // ==================== HELPERS PRIVÉS ====================

  /// Sauvegarder les tokens
  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Récupérer le token d'accès
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Vérifier si l'utilisateur est authentifié
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Obtenir les headers d'authentification
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  Future<Map<String, dynamic>?> getUserFromToken() async {
    final token = await getAccessToken();
    if (token == null) return null;

    final payload = TokenHelper.decodeToken(token);
    if (payload == null) return null;

    return {
      "id": payload["userId"] ?? payload["sub"], // selon ton backend
      "email": payload["userEmail"],
      "role": payload["role"] ?? payload["appRole"],
      "exp": payload["exp"],
    };
  }
}
