import 'package:flutter/material.dart';

/// Énumération du statut d'un salon
enum SalonStatus {
  PENDING,
  ACTIVE,
  INACTIVE,
  SUSPENDED,
  CLOSED;

  /// Convertir en chaîne pour l'API
  String toJson() {
    return name;
  }

  /// Créer depuis une chaîne
  static SalonStatus fromString(String value) {
    try {
      return SalonStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () => SalonStatus.PENDING,
      );
    } catch (e) {
      return SalonStatus.PENDING;
    }
  }

  /// Obtenir le nom formaté pour l'affichage
  String get displayName {
    switch (this) {
      case SalonStatus.PENDING:
        return 'En attente';
      case SalonStatus.ACTIVE:
        return 'Actif';
      case SalonStatus.INACTIVE:
        return 'Inactif';
      case SalonStatus.SUSPENDED:
        return 'Suspendu';
      case SalonStatus.CLOSED:
        return 'Fermé';
    }
  }

  /// Obtenir le nom en anglais
  String get displayNameEn {
    switch (this) {
      case SalonStatus.PENDING:
        return 'Pending';
      case SalonStatus.ACTIVE:
        return 'Active';
      case SalonStatus.INACTIVE:
        return 'Inactive';
      case SalonStatus.SUSPENDED:
        return 'Suspended';
      case SalonStatus.CLOSED:
        return 'Closed';
    }
  }

  /// Obtenir la couleur associée
  Color get color {
    switch (this) {
      case SalonStatus.PENDING:
        return Colors.orange;
      case SalonStatus.ACTIVE:
        return Colors.green;
      case SalonStatus.INACTIVE:
        return Colors.grey;
      case SalonStatus.SUSPENDED:
        return Colors.red;
      case SalonStatus.CLOSED:
        return Colors.black;
    }
  }

  /// Obtenir l'icône associée
  IconData get icon {
    switch (this) {
      case SalonStatus.PENDING:
        return Icons.pending;
      case SalonStatus.ACTIVE:
        return Icons.check_circle;
      case SalonStatus.INACTIVE:
        return Icons.pause_circle;
      case SalonStatus.SUSPENDED:
        return Icons.block;
      case SalonStatus.CLOSED:
        return Icons.cancel;
    }
  }

  /// Est-ce que le salon peut accepter des réservations?
  bool get canAcceptBookings {
    return this == SalonStatus.ACTIVE;
  }

  /// Est-ce que le salon est visible dans les recherches?
  bool get isVisibleInSearch {
    return this == SalonStatus.ACTIVE || this == SalonStatus.INACTIVE;
  }
}