import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';

class TreatmentService {
  final AuthService _authService = AuthService();

  Future<String?> _getAuthToken() async {
    final token = await _authService.getAccessToken();
    return token;
  }

  /// Obtenir tous les traitements disponibles
  Future<Map<String, dynamic>> getAllTreatments() async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.treatmentBaseUrl}/retrieve-all-treatments'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('💆 Récupération tous les traitements: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> treatments = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': treatments,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des traitements: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération traitements: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  /// Créer un nouveau traitement
  Future<Map<String, dynamic>> addTreatment({
    required String name,
    required String description,
    required double price,
    required double duration,
    required String category,
    String? photoPath,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final treatmentData = {
        'treatmentName': name,
        'treatmentDescription': description,
        'treatmentPrice': price,
        'treatmentTime': duration,
        'treatmentCategory': category,
      };

      debugPrint('📤 Données traitement: ${jsonEncode(treatmentData)}');

      final response = await http.post(
        Uri.parse('${Config.treatmentBaseUrl}/add-treatment'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(treatmentData),
      );

      debugPrint('➕ Ajout traitement: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Upload de la photo si fournie
        if (photoPath != null && data['treatmentId'] != null) {
          await uploadTreatmentPhoto(
            data['treatmentId'] ?? data['id'], 
            photoPath
          );
        }
        
        return {
          'success': true,
          'treatment': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de l\'ajout du traitement',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur ajout traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Upload photo de traitement
  Future<Map<String, dynamic>> uploadTreatmentPhoto(String treatmentId, String imagePath) async {
    try {
      final token = await _getAuthToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.treatmentBaseUrl}/$treatmentId/photos'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('📷 Upload photo traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return {
          'success': true,
          'message': 'Photo uploadée avec succès',
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'upload de la photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur upload photo traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Obtenir les détails d'un traitement par ID
  Future<Map<String, dynamic>> getTreatmentDetails(String treatmentId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.treatmentBaseUrl}/retrieve-treatment/$treatmentId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('💆 Récupération détails traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'treatment': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Traitement non trouvé',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Mettre à jour un traitement
  Future<Map<String, dynamic>> updateTreatment({
    required String treatmentId,
    required String name,
    required String description,
    required double price,
    required double duration,
    required String category,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final treatmentData = {
        'treatmentId': treatmentId,
        'treatmentName': name,
        'treatmentDescription': description,
        'treatmentPrice': price,
        'treatmentTime': duration,
        'treatmentCategory': category,
      };

      final response = await http.put(
        Uri.parse('${Config.treatmentBaseUrl}/modify-treatment'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(treatmentData),
      );

      debugPrint('✏️ Mise à jour traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour du traitement',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur mise à jour traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Supprimer un traitement
  Future<Map<String, dynamic>> deleteTreatment(String treatmentId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.delete(
        Uri.parse('${Config.treatmentBaseUrl}/remove-treatment/$treatmentId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🗑️ Suppression traitement: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Traitement supprimé avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression du traitement',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur suppression traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Obtenir les traitements d'un salon
  Future<Map<String, dynamic>> getTreatmentsBySalon(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.treatmentBaseUrl}/get-treatments-by-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération traitements par salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> treatments = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': treatments,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des traitements du salon',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération traitements par salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Mettre à jour la photo d'un traitement
  Future<Map<String, dynamic>> updateTreatmentPhoto({
    required String treatmentId,
    required int index,
    required String imagePath,
  }) async {
    try {
      final token = await _getAuthToken();
      
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${Config.treatmentBaseUrl}/$treatmentId/photos/$index'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('📷 Mise à jour photo traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return {
          'success': true,
          'message': 'Photo mise à jour avec succès',
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour de la photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur mise à jour photo traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Supprimer une photo spécifique d'un traitement
  Future<Map<String, dynamic>> deleteTreatmentPhoto({
    required String treatmentId,
    required int index,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.delete(
        Uri.parse('${Config.treatmentBaseUrl}/$treatmentId/photos/$index'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🗑️ Suppression photo traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Photo supprimée avec succès',
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression de la photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur suppression photo traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Supprimer toutes les photos d'un traitement
  Future<Map<String, dynamic>> deleteAllTreatmentPhotos(String treatmentId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.delete(
        Uri.parse('${Config.treatmentBaseUrl}/$treatmentId/photos'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🗑️ Suppression toutes les photos traitement: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': 'Toutes les photos supprimées avec succès',
          'treatment': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression des photos',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur suppression toutes les photos traitement: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Rechercher des traitements par nom ou catégorie
  Future<Map<String, dynamic>> searchTreatments(String query) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.treatmentBaseUrl}/search?query=$query'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🔍 Recherche traitements: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> treatments = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': treatments,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la recherche des traitements',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur recherche traitements: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
}