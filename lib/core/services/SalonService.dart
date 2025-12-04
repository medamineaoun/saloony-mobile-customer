import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:saloony/core/Config/Config.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/Salon.dart';

class SalonService {
  final AuthService _authService = AuthService();

  Future<String?> _getAuthToken() async {
    final token = await _authService.getAccessToken();
    return token;
  }

  Future<String?> _getCurrentUserId() async {
    try {
      final userResult = await _authService.getCurrentUser();
      if (userResult['success'] == true && userResult['user'] != null) {
        final user = userResult['user'];
        return user['userId'] ?? user['id'];
      }
      return null;
    } catch (e) {
      debugPrint('❌ Erreur récupération userId: $e');
      return null;
    }
  }

  /// ✅ CORRIGÉ: Obtenir tous les salons - endpoint correct
  Future<Map<String, dynamic>> getAllSalons() async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}retrieve-all-salons'), // ✅ CORRECT
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération tous les salons: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> salons = jsonDecode(response.body);
        return {
          'success': true,
          'salons': salons
              .map((s) => Salon.fromJson(s as Map<String, dynamic>))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des salons',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salons: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// ✅ NOUVEAU: Obtenir tous les salons actifs avec pagination
  Future<Map<String, dynamic>> getActiveSalons({
    int page = 0,
    int size = 10,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/active?page=$page&size=$size'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération salons actifs: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salons': data['content'],
          'totalPages': data['totalPages'],
          'totalElements': data['totalElements'],
          'currentPage': data['number'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des salons actifs',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salons actifs: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// ✅ NOUVEAU: Obtenir les salons actifs par catégorie
  Future<Map<String, dynamic>> getActiveSalonsByCategory({
    required String category,
    int page = 0,
    int size = 10,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/active/category/$category?page=$page&size=$size'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération salons par catégorie: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salons': data['content'],
          'totalPages': data['totalPages'],
          'totalElements': data['totalElements'],
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Récupérer le salon d'un spécialiste par son userId
  Future<Map<String, dynamic>> getSpecialistSalon(String userId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/get-salon-by-specialist/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération salon spécialiste: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else if (response.statusCode == 404) {
        return {
          'success': false,
          'message': 'Aucun salon trouvé pour ce spécialiste',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salon: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  /// ✅ NOUVEAU: Assigner un propriétaire au salon
  Future<Map<String, dynamic>> assignSalonOwner({
    required String specialistId,
    required String salonId,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.put(
        Uri.parse('${Config.apisalon}/assign-owner?specialistId=$specialistId&salonId=$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('👤 Assignation propriétaire: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'assignation',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur assignation: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// ✅ NOUVEAU: Activer un salon
  Future<Map<String, dynamic>> activateSalon(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.put(
        Uri.parse('${Config.apisalon}/admin/$salonId/activate'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('✅ Activation salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'activation',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur activation: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// ✅ NOUVEAU: Bloquer un salon
  Future<Map<String, dynamic>> blockSalon(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.put(
        Uri.parse('${Config.apisalon}/admin/$salonId/block'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🚫 Blocage salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors du blocage',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur blocage: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> verifySpecialistEmail(String email) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/verify-specialist-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📧 Vérification email: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Erreur serveur: ${response.statusCode}',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur vérification email: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getAllTreatments() async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/retrieve-all-treatments'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('💆 Récupération traitements: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> treatments = jsonDecode(response.body);
        return {
          'success': true,
          'treatments': treatments,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des traitements',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération traitements: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> createSalon({
    required String salonName,
    required String salonDescription,
    required String salonCategory,
    required List<String> additionalServices,
    required String genderType,
    required double latitude,
    required double longitude,
    required List<String> treatmentIds,
    required List<String> specialistIds,
    required Map<String, dynamic> availability,
    String? salonOwnerId,
  }) async {
    try {
      final token = await _getAuthToken();
      final String ownerId = salonOwnerId ?? await _getCurrentUserId() ?? specialistIds.first;

      final salonData = {
        "salonName": salonName,
        "salonDescription": salonDescription,
        "salonCategory": salonCategory,
        "additionalService": additionalServices,
        "salonGenderType": genderType,
        "salonLatitude": latitude,
        "salonLongitude": longitude,
        "salonTreatmentsIds": treatmentIds,
        "salonSpecialistsIds": specialistIds,
        "salonAvailabilities": _formatAvailabilitiesForApi(availability),
        "salonOwnerId": ownerId,
      };

      debugPrint('📤 Données salon: ${jsonEncode(salonData)}');

      final response = await http.post(
        Uri.parse('${Config.apisalon}/add-salon'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(salonData),
      );

      debugPrint('🏢 Création salon: ${response.statusCode}');
      debugPrint('🏢 Réponse: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Erreur lors de la création du salon',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur création salon: $e');
      return {
        'success': false,
        'message': 'Erreur de connexion: $e',
      };
    }
  }

  List<Map<String, dynamic>> _formatAvailabilitiesForApi(Map<String, dynamic>? availability) {
    if (availability == null) return [];
    
    final List<Map<String, dynamic>> availabilities = [];
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    for (final day in days) {
      final dayData = availability[day];
      
      if (dayData != null && dayData is Map<String, dynamic>) {
        final availabilityEntry = {
          'dayOfWeek': dayData['dayOfWeek'],
          'available': dayData['available'],
        };
        
        if (dayData['available'] == true) {
          availabilityEntry['fromHour'] = dayData['fromHour'];
          availabilityEntry['toHour'] = dayData['toHour'];
        } else {
          availabilityEntry['fromHour'] = null;
          availabilityEntry['toHour'] = null;
        }
        
        availabilities.add(availabilityEntry);
      }
    }
    
    return availabilities;
  }

  Future<Map<String, dynamic>> addSalonPhoto({
    required String salonId,
    required String imagePath,
  }) async {
    try {
      final token = await _getAuthToken();
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.apisalon}/$salonId/photos'),
      );

      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      debugPrint('📷 Upload photo salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Photo uploadée avec succès',
          'data': jsonDecode(responseBody),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'upload de la photo',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur upload photo salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getSalonDetails(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.get(
        Uri.parse('${Config.apisalon}/retrieve-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🏢 Récupération détails salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Salon non trouvé',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updateSalon({
    required String salonId,
    Map<String, dynamic>? updateData,
  }) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.put(
        Uri.parse('${Config.apisalon}/modify-salon'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      debugPrint('✏️ Mise à jour salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'salon': data,
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la mise à jour',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur mise à jour salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  Future<Map<String, dynamic>> deleteSalon(String salonId) async {
    try {
      final token = await _getAuthToken();
      
      final response = await http.delete(
        Uri.parse('${Config.apisalon}/remove-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('🗑️ Suppression salon: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Salon supprimé avec succès',
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la suppression',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur suppression salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
}