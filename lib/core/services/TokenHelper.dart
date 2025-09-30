import 'package:jwt_decoder/jwt_decoder.dart';

class TokenHelper {
  /// Extraire le payload décodé
  static Map<String, dynamic>? decodeToken(String? token) {
    if (token == null || token.isEmpty) return null;
    return JwtDecoder.decode(token);
  }

  /// Vérifier si le token est expiré
  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) return true;
    return JwtDecoder.isExpired(token);
  }

  /// Obtenir la date d’expiration
  static DateTime? getExpirationDate(String? token) {
    if (token == null || token.isEmpty) return null;
    return JwtDecoder.getExpirationDate(token);
  }

  /// Récupérer un claim spécifique
  static String? getClaim(String? token, String claimKey) {
    final decoded = decodeToken(token);
    return decoded != null ? decoded[claimKey]?.toString() : null;
  }
}
