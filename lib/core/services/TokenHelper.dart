import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHelper {
  /// Décoder un JWT token
  static Map<String, dynamic>? decodeToken(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Vérifier si le token est expiré
  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  /// Récupérer la date d'expiration du token
  static DateTime? getExpirationDate(String? token) {
    if (token == null || token.isEmpty) return null;
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Récupérer une claim spécifique du token
  static String? getClaim(String? token, String claimKey) {
    final decoded = decodeToken(token);
    return decoded != null ? decoded[claimKey]?.toString() : null;
  }

  /// Récupérer l'ID utilisateur depuis le token
  static String? getUserId(String? token) {
    return getClaim(token, 'userId') ?? getClaim(token, 'sub');
  }

  /// Récupérer l'email depuis le token
  static String? getEmail(String? token) {
    return getClaim(token, 'email');
  }

  /// Récupérer le rôle depuis le token
  static String? getRole(String? token) {
    return getClaim(token, 'role') ?? getClaim(token, 'appRole');
  }

  /// Vérifier si le token est valide (existe et non expiré)
  static bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) return false;
    return !isTokenExpired(token);
  }

  /// Calculer le temps restant avant expiration (en minutes)
  static int? getTimeUntilExpiration(String? token) {
    final expirationDate = getExpirationDate(token);
    if (expirationDate == null) return null;
    
    final now = DateTime.now();
    final difference = expirationDate.difference(now);
    
    return difference.inMinutes;
  }

  /// Vérifier si le token expire bientôt (dans moins de 5 minutes)
  static bool isTokenExpiringSoon(String? token) {
    final minutesLeft = getTimeUntilExpiration(token);
    if (minutesLeft == null) return true;
    
    return minutesLeft <= 5;
  }
}