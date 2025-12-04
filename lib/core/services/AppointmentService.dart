import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:saloony/core/Config/ProviderSetup.dart';
import 'package:saloony/core/services/AuthService.dart';

class AppointmentDTO {
  final String? appointmentId;
  final String? userId;
  final String? salonId;
  final String? treatmentId;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final String? appointmentStatus;
  final String? salonName;
  final String? treatmentName;
  final double? treatmentPrice;
  final String? userName;
  final String? userProfilePhoto;

  AppointmentDTO({
    this.appointmentId,
    this.userId,
    this.salonId,
    this.treatmentId,
    this.appointmentDate,
    this.appointmentTime,
    this.appointmentStatus,
    this.salonName,
    this.treatmentName,
    this.treatmentPrice,
    this.userName,
    this.userProfilePhoto,
  });

  factory AppointmentDTO.fromJson(Map<String, dynamic> json) {
    return AppointmentDTO(
      appointmentId: json['appointmentId']?.toString(),
      userId: json['userId']?.toString(),
      salonId: json['salonId']?.toString(),
      treatmentId: json['treatmentId']?.toString(),
      appointmentDate: json['appointmentDate'] != null
          ? DateTime.parse(json['appointmentDate'].toString())
          : null,
      appointmentTime: json['appointmentTime']?.toString(),
      appointmentStatus: json['appointmentStatus']?.toString(),
      salonName: json['salonName']?.toString(),
      treatmentName: json['treatmentName']?.toString(),
      treatmentPrice: AppointmentDTO._parseDouble(json['treatmentPrice']),
      userName: json['userName']?.toString(),
      userProfilePhoto: json['userProfilePhoto']?.toString(),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'userId': userId,
      'salonId': salonId,
      'treatmentId': treatmentId,
      'appointmentDate': appointmentDate?.toIso8601String(),
      'appointmentTime': appointmentTime,
      'appointmentStatus': appointmentStatus,
      'salonName': salonName,
      'treatmentName': treatmentName,
      'treatmentPrice': treatmentPrice,
      'userName': userName,
      'userProfilePhoto': userProfilePhoto,
    };
  }
}

class AppointmentService {
  final AuthService _authService = AuthService();

  Future<String?> _getAuthToken() async {
    final token = await _authService.getAccessToken();
    return token;
  }

  Future<String?> _getUserId() async {
    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        return userData['userId']?.toString();
      }
    } catch (e) {
      debugPrint('Erreur récupération userId: $e');
    }
    return null;
  }

  /// Récupérer tous les rendez-vous
  Future<Map<String, dynamic>> getAllAppointments() async {
    try {
      final token = await _getAuthToken();

      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/appointment/retrieve-all-appointments'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📅 Récupération tous les rendez-vous: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> appointments = jsonDecode(response.body);
        return {
          'success': true,
          'appointments': appointments
              .map((a) => AppointmentDTO.fromJson(a as Map<String, dynamic>))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération des rendez-vous',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération rendez-vous: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Récupérer les rendez-vous de l'utilisateur connecté
  Future<Map<String, dynamic>> getAppointmentsByUserId() async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return {
          'success': false,
          'message': 'Utilisateur non authentifié',
        };
      }

      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/appointment/get-appointments-by-userId/$userId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint(
          '📅 Récupération rendez-vous par utilisateur: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> appointments = jsonDecode(response.body);
        return {
          'success': true,
          'appointments': appointments
              .map((a) => AppointmentDTO.fromJson(a as Map<String, dynamic>))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Aucun rendez-vous trouvé',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération rendez-vous utilisateur: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Récupérer les rendez-vous d'un salon
  Future<Map<String, dynamic>> getAppointmentsBySalon(String salonId) async {
    try {
      final token = await _getAuthToken();

      final response = await http.get(
        Uri.parse('${Config.salonBaseUrl}/appointment/get-appointments-by-salon/$salonId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📅 Récupération rendez-vous par salon: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> appointments = jsonDecode(response.body);
        return {
          'success': true,
          'appointments': appointments
              .map((a) => AppointmentDTO.fromJson(a as Map<String, dynamic>))
              .toList(),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la récupération',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération rendez-vous salon: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Récupérer un rendez-vous spécifique
  Future<Map<String, dynamic>> getAppointmentDetails(String appointmentId) async {
    try {
      final token = await _getAuthToken();

      final response = await http.get(
        Uri.parse(
            '${Config.salonBaseUrl}/appointment/retrieve-appointment/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📅 Récupération détails rendez-vous: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'appointment': AppointmentDTO.fromJson(data as Map<String, dynamic>),
        };
      } else {
        return {
          'success': false,
          'message': 'Rendez-vous non trouvé',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur récupération détails rendez-vous: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Réserver un rendez-vous
  Future<Map<String, dynamic>> bookAppointment({
    required String salonId,
    required String treatmentId,
    required DateTime appointmentDate,
    required String appointmentTime,
  }) async {
    try {
      final token = await _getAuthToken();
      final userId = await _getUserId();

      if (userId == null) {
        return {
          'success': false,
          'message': 'Utilisateur non authentifié',
        };
      }

      final appointmentData = {
        'userId': userId,
        'salonId': salonId,
        'treatmentId': treatmentId,
        'appointmentDate': appointmentDate.toIso8601String(),
        'appointmentTime': appointmentTime,
      };

      final response = await http.post(
        Uri.parse('${Config.salonBaseUrl}/appointment/bookAppointment'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(appointmentData),
      );

      debugPrint('📅 Réservation rendez-vous: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'appointment': AppointmentDTO.fromJson(data as Map<String, dynamic>),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de la réservation',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur réservation rendez-vous: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }

  /// Annuler un rendez-vous par le client
  Future<Map<String, dynamic>> cancelAppointment(String appointmentId) async {
    try {
      final token = await _getAuthToken();

      final response = await http.put(
        Uri.parse(
            '${Config.salonBaseUrl}/appointment/cancelAppointmentByCustomer/$appointmentId'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      debugPrint('📅 Annulation rendez-vous: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'appointment': AppointmentDTO.fromJson(data as Map<String, dynamic>),
        };
      } else {
        return {
          'success': false,
          'message': 'Erreur lors de l\'annulation',
        };
      }
    } catch (e) {
      debugPrint('❌ Erreur annulation rendez-vous: $e');
      return {
        'success': false,
        'message': 'Erreur: $e',
      };
    }
  }
}
