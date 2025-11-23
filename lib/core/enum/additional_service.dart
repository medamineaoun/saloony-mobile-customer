// additional_service.dart
import 'package:flutter/material.dart';

enum AdditionalService {
  wifi,
  tv,
  backgroundMusic,
  airConditioning,
  heating,
  coffeeTea,
  drinksSnacks,
  freeParking,
  paidParking,
  publicTransportAccess,
  wheelchairAccessible,
  childFriendly,
  shower,
  lockers,
  creditCardAccepted,
  mobilePayment,
  securityCameras,
  petFriendly,
  noPets,
  smokingAllowed,
  nonSmoking;

  static AdditionalService fromString(String value) {
    final normalized = value.toLowerCase().replaceAll(' ', '').replaceAll('_', '');
    
    switch (normalized) {
      case 'wifi':
        return AdditionalService.wifi;
      case 'tv':
        return AdditionalService.tv;
      case 'backgroundmusic':
        return AdditionalService.backgroundMusic;
      case 'airconditioning':
        return AdditionalService.airConditioning;
      case 'heating':
        return AdditionalService.heating;
      case 'coffeetea':
        return AdditionalService.coffeeTea;
      case 'drinkssnacks':
        return AdditionalService.drinksSnacks;
      case 'freeparking':
        return AdditionalService.freeParking;
      case 'paidparking':
        return AdditionalService.paidParking;
      case 'publictransportaccess':
        return AdditionalService.publicTransportAccess;
      case 'wheelchairaccessible':
        return AdditionalService.wheelchairAccessible;
      case 'childfriendly':
        return AdditionalService.childFriendly;
      case 'shower':
        return AdditionalService.shower;
      case 'lockers':
        return AdditionalService.lockers;
      case 'creditcardaccepted':
        return AdditionalService.creditCardAccepted;
      case 'mobilepayment':
        return AdditionalService.mobilePayment;
      case 'securitycameras':
        return AdditionalService.securityCameras;
      case 'petfriendly':
        return AdditionalService.petFriendly;
      case 'nopets':
        return AdditionalService.noPets;
      case 'smokingallowed':
        return AdditionalService.smokingAllowed;
      case 'nonsmoking':
        return AdditionalService.nonSmoking;
      default:
        throw ArgumentError('Invalid AdditionalService: $value');
    }
  }

  /// Nom d'affichage localisé en français
  String get displayName {
    switch (this) {
      case AdditionalService.wifi:
        return 'WiFi';
      case AdditionalService.tv:
        return 'Télévision';
      case AdditionalService.backgroundMusic:
        return 'Musique d\'ambiance';
      case AdditionalService.airConditioning:
        return 'Climatisation';
      case AdditionalService.heating:
        return 'Chauffage';
      case AdditionalService.coffeeTea:
        return 'Café/Thé';
      case AdditionalService.drinksSnacks:
        return 'Boissons/Snacks';
      case AdditionalService.freeParking:
        return 'Parking gratuit';
      case AdditionalService.paidParking:
        return 'Parking payant';
      case AdditionalService.publicTransportAccess:
        return 'Accès transport public';
      case AdditionalService.wheelchairAccessible:
        return 'Accessible handicapés';
      case AdditionalService.childFriendly:
        return 'Adapté aux enfants';
      case AdditionalService.shower:
        return 'Douche';
      case AdditionalService.lockers:
        return 'Casiers';
      case AdditionalService.creditCardAccepted:
        return 'Carte bancaire acceptée';
      case AdditionalService.mobilePayment:
        return 'Paiement mobile';
      case AdditionalService.securityCameras:
        return 'Caméras de sécurité';
      case AdditionalService.petFriendly:
        return 'Animaux acceptés';
      case AdditionalService.noPets:
        return 'Animaux interdits';
      case AdditionalService.smokingAllowed:
        return 'Fumeur autorisé';
      case AdditionalService.nonSmoking:
        return 'Non-fumeur';
    }
  }

  /// Icône associée au service
  IconData get icon {
    switch (this) {
      case AdditionalService.wifi:
        return Icons.wifi;
      case AdditionalService.tv:
        return Icons.tv;
      case AdditionalService.backgroundMusic:
        return Icons.music_note;
      case AdditionalService.airConditioning:
        return Icons.ac_unit;
      case AdditionalService.heating:
        return Icons.whatshot;
      case AdditionalService.coffeeTea:
        return Icons.local_cafe;
      case AdditionalService.drinksSnacks:
        return Icons.restaurant;
      case AdditionalService.freeParking:
        return Icons.local_parking;
      case AdditionalService.paidParking:
        return Icons.attach_money;
      case AdditionalService.publicTransportAccess:
        return Icons.directions_bus;
      case AdditionalService.wheelchairAccessible:
        return Icons.accessible;
      case AdditionalService.childFriendly:
        return Icons.child_care;
      case AdditionalService.shower:
        return Icons.shower;
      case AdditionalService.lockers:
        return Icons.lock;
      case AdditionalService.creditCardAccepted:
        return Icons.credit_card;
      case AdditionalService.mobilePayment:
        return Icons.phone_android;
      case AdditionalService.securityCameras:
        return Icons.security;
      case AdditionalService.petFriendly:
        return Icons.pets;
      case AdditionalService.noPets:
        return Icons.pets_outlined;
      case AdditionalService.smokingAllowed:
        return Icons.smoking_rooms;
      case AdditionalService.nonSmoking:
        return Icons.smoke_free;
    }
  }

  /// Valeur pour l'API Backend
  String get apiValue {
    switch (this) {
      case AdditionalService.wifi:
        return 'WIFI';
      case AdditionalService.tv:
        return 'TV';
      case AdditionalService.backgroundMusic:
        return 'BACKGROUND_MUSIC';
      case AdditionalService.airConditioning:
        return 'AIR_CONDITIONING';
      case AdditionalService.heating:
        return 'HEATING';
      case AdditionalService.coffeeTea:
        return 'COFFEE_TEA';
      case AdditionalService.drinksSnacks:
        return 'DRINKS_SNACKS';
      case AdditionalService.freeParking:
        return 'FREE_PARKING';
      case AdditionalService.paidParking:
        return 'PAID_PARKING';
      case AdditionalService.publicTransportAccess:
        return 'PUBLIC_TRANSPORT_ACCESS';
      case AdditionalService.wheelchairAccessible:
        return 'WHEELCHAIR_ACCESSIBLE';
      case AdditionalService.childFriendly:
        return 'CHILD_FRIENDLY';
      case AdditionalService.shower:
        return 'SHOWER';
      case AdditionalService.lockers:
        return 'LOCKERS';
      case AdditionalService.creditCardAccepted:
        return 'CREDIT_CARD_ACCEPTED';
      case AdditionalService.mobilePayment:
        return 'MOBILE_PAYMENT';
      case AdditionalService.securityCameras:
        return 'SECURITY_CAMERAS';
      case AdditionalService.petFriendly:
        return 'PET_FRIENDLY';
      case AdditionalService.noPets:
        return 'NO_PETS';
      case AdditionalService.smokingAllowed:
        return 'SMOKING_ALLOWED';
      case AdditionalService.nonSmoking:
        return 'NON_SMOKING';
    }
  }

  /// Pour sérialiser en JSON
  String toJson() => name;
}
