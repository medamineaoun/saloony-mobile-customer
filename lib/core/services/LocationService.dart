import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  Position? _currentPosition;
  bool _isWebPlatform = false;

  Position? get currentPosition => _currentPosition;

  /// Vérifie si la plateforme supporte la localisation
  bool _isSupportedPlatform() {
    try {
      return io.Platform.isAndroid || io.Platform.isIOS;
    } catch (e) {
      // Si Platform n'est pas supporté (web), attraper l'exception
      return false;
    }
  }

  /// Demande la permission et obtient la localisation actuelle
  Future<Position?> getCurrentLocation() async {
    try {
      // Vérifier si c'est une plateforme supportée (web n'est pas supporté par geolocator)
      if (!_isSupportedPlatform()) {
        debugPrint('Localisation non disponible sur cette plateforme');
        _isWebPlatform = true;
        return null;
      }

      // Vérifier si la localisation est activée
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Service de localisation désactivé');
        return null;
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Demander la permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Permission de localisation refusée');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint(
            'Permission de localisation refusée définitivement. Ouvrez les paramètres.');
        return null;
      }

      // Obtenir la position actuelle
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return _currentPosition;
    } catch (e) {
      debugPrint('Erreur lors de l\'obtention de la localisation: $e');
      // Détecter les erreurs web
      if (e.toString().contains('MissingPluginException') ||
          e.toString().contains('Unsupported operation')) {
        _isWebPlatform = true;
      }
      return null;
    }
  }

  /// Calcule la distance entre deux points en kilomètres
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Obtient la distance entre la position actuelle et un salon
  double? getDistanceToSalon(double salonLat, double salonLon) {
    if (_currentPosition == null) return null;
    try {
      return calculateDistance(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        salonLat,
        salonLon,
      );
    } catch (e) {
      debugPrint('Erreur lors du calcul de la distance: $e');
      return null;
    }
  }

  /// Vérifie si la plateforme est web
  bool get isWebPlatform => _isWebPlatform;
}