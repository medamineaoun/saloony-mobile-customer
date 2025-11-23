// salon_gender_type.dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SalonGenderType {
  man,
  woman,
  mixed;

  static SalonGenderType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'man':
      case 'men':
        return SalonGenderType.man;
      case 'woman':
      case 'women':
        return SalonGenderType.woman;
      case 'mixed':
      case 'unisex':
        return SalonGenderType.mixed;
      default:
        throw ArgumentError('Invalid SalonGenderType: $value');
    }
  }

  /// Nom d'affichage localisé
  String get displayName {
    switch (this) {
      case SalonGenderType.man:
        return 'Hommes';
      case SalonGenderType.woman:
        return 'Femmes';
      case SalonGenderType.mixed:
        return 'Mixte';
    }
  }

  /// Valeur pour l'API Backend
  String get apiValue {
    switch (this) {
      case SalonGenderType.man:
        return 'MEN';
      case SalonGenderType.woman:
        return 'WOMEN';
      case SalonGenderType.mixed:
        return 'MIXED';
    }
  }

  /// Pour sérialiser en JSON
  String toJson() => name;
}


