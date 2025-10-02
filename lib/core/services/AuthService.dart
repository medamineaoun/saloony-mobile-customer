import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static String get baseUrl => Config.authBaseUrl;
  static String get _accessTokenKey => Config.accessTokenKey;
  static String get _refreshTokenKey => Config.refreshTokenKey;

  // ==================== HELPERS ====================

  /// 🔑 Gérer snake_case et camelCase pour les tokens
  Map<String, String?> _parseTokens(Map<String, dynamic> data) {
    return {
      'accessToken': data['access_token'] ?? data['accessToken'],
      'refreshToken': data['refresh_token'] ?? data['refreshToken'],
    };
  }

  Future<void> _saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${token ?? ''}',
    };
  }

  // ==================== INSCRIPTION ====================

  Future<Map<String, dynamic>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender, // "MAN" ou "WOMAN"
    required String role,   // "CUSTOMER", "SPECIALIST", "ADMIN"
  }) async {
    try {
      final url = Uri.parse('$baseUrl/signup');
      final body = jsonEncode({
        'userFirstName': firstName,
        'userLastName': lastName,
        'userEmail': email,
        'password': password,
        'userPhoneNumber': phoneNumber,
        'userGender': gender,
        'appRole': role,
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Inscription réussie ! Vérifiez votre email pour le code de vérification.',
        };
      } else {
        String errorMessage = 'Erreur lors de l\'inscription';
        if (response.body.isNotEmpty) {
          try {
            final error = jsonDecode(response.body);
            errorMessage = error['message'] ?? error.toString();
          } catch (_) {
            errorMessage = response.body;
          }
        }
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
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
        final tokens = _parseTokens(data);

        if (tokens['accessToken'] == null || tokens['refreshToken'] == null) {
          return {'success': false, 'message': 'Tokens manquants dans la réponse du serveur'};
        }

        await _saveTokens(
          accessToken: tokens['accessToken']!,
          refreshToken: tokens['refreshToken']!,
        );

        return {'success': true, ...tokens};
      } else {
        String errorMessage = 'Email ou mot de passe incorrect';
        try {
          final error = jsonDecode(response.body);
          errorMessage = error['message'] ?? errorMessage;
        } catch (_) {}
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== VÉRIFICATION SIGNUP ====================

  Future<Map<String, dynamic>> requestSignupVerification(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-signup-verification?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200
          ? {'success': true, 'message': 'Code envoyé à votre email'}
          : {'success': false, 'message': 'Erreur lors de l\'envoi du code'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  Future<Map<String, dynamic>> verifySignupCode({
    required String email,
    required String code,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/verify-code-signup?email=$email&code=$code');
      final response = await http.post(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tokens = _parseTokens(data);

        if (tokens['accessToken'] == null || tokens['refreshToken'] == null) {
          return {'success': false, 'message': 'Tokens manquants dans la réponse du serveur'};
        }

        await _saveTokens(
          accessToken: tokens['accessToken']!,
          refreshToken: tokens['refreshToken']!,
        );

        return {'success': true, ...tokens};
      } else {
        String errorMsg = 'Code invalide ou expiré';
        try {
          final error = jsonDecode(response.body);
          errorMsg = error['message'] ?? errorMsg;
        } catch (_) {}
        return {'success': false, 'message': errorMsg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== RESET PASSWORD ====================

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/request-reset?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200
          ? {'success': true, 'message': 'Code envoyé à votre email'}
          : {'success': false, 'message': 'Utilisateur non trouvé'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  Future<Map<String, dynamic>> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-code?email=$email&code=$code'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200
          ? {'success': true}
          : {'success': false, 'message': 'Code invalide ou expiré'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password?email=$email&code=$code&newPassword=$newPassword'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200
          ? {'success': true, 'message': 'Mot de passe réinitialisé avec succès'}
          : {'success': false, 'message': 'Erreur lors de la réinitialisation'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== REFRESH TOKEN ====================

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
        final tokens = _parseTokens(data);

        if (tokens['accessToken'] == null || tokens['refreshToken'] == null) {
          return {'success': false, 'message': 'Tokens manquants dans la réponse du serveur'};
        }

        await _saveTokens(
          accessToken: tokens['accessToken']!,
          refreshToken: tokens['refreshToken']!,
        );

        return {'success': true, ...tokens};
      } else {
        return {'success': false, 'message': 'Token invalide ou expiré'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== CURRENT USER ====================

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
        return {'success': false, 'message': 'Impossible de récupérer l\'utilisateur'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion: $e'};
    }
  }

  // ==================== DÉCONNEXION ====================

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
