import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/enum/SalonGenderType.dart';
import 'package:saloony/core/enum/TreatmentCategory.dart';
import 'package:saloony/core/enum/additional_service.dart';

class SalonConstants {
 
  // Limites de validation
  static const int minSalonNameLength = 2;
  static const int maxSalonNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const double minLatitude = -90.0;
  static const double maxLatitude = 90.0;
  static const double minLongitude = -180.0;
  static const double maxLongitude = 180.0;
  
  // Messages d'erreur
  static const String networkError = 'Network error. Please check your connection.';
  static const String authError = 'Authentication required. Please login.';
  static const String serverError = 'Server error. Please try again later.';
  static const String validationError = 'Please fill all required fields.';
}
 