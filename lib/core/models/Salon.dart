
import 'package:saloony/core/constants/SalonConstants.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/enum/SalonGenderType.dart';
import 'package:saloony/core/enum/SalonStatus.dart';
import 'package:saloony/core/enum/additional_service.dart';
class Salon {
  final String? salonId;
  final String salonName;
  final String? salonDescription;
  final DateTime? salonRegistrationDate;
  final SalonStatus salonStatus;
  final SalonCategory salonCategory;
  final List<AdditionalService> additionalServices;
  final SalonGenderType type;
  final List<String>? salonPhotosPaths;
  final double? salonLongitude;
  final double? salonLatitude;
  final List<String>? salonTreatmentsIds;
  final List<String>? salonSpecialistsIds;
  final String? ownerId;

  Salon({
    this.salonId,
    required this.salonName,
    this.salonDescription,
    this.salonRegistrationDate,
    this.salonStatus = SalonStatus.PENDING,
    required this.salonCategory,
    required this.additionalServices,
    required this.type,
    this.salonPhotosPaths,
    this.salonLongitude,
    this.salonLatitude,
    this.salonTreatmentsIds,
    this.salonSpecialistsIds,
    this.ownerId,
  });

  /// Créer depuis JSON
  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      salonId: json['salonId'],
      salonName: json['salonName'] ?? '',
      salonDescription: json['salonDescription'],
      salonRegistrationDate: json['salonRegistrationDate'] != null
          ? DateTime.parse(json['salonRegistrationDate'])
          : null,
      salonStatus: SalonStatus.fromString(json['salonStatus'] ?? 'PENDING'),
      salonCategory: SalonCategory.fromString(json['salonCategory'] ?? 'BARBERSHOP'),
      additionalServices: (json['additionalService'] as List<dynamic>?)
              ?.map((e) => AdditionalService.fromString(e.toString()))
              .toList() ??
          [],
      type: SalonGenderType.fromString(json['type'] ?? 'UNISEX'),
      salonPhotosPaths: (json['salonPhotosPaths'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      salonLongitude: json['salonLongitude']?.toDouble(),
      salonLatitude: json['salonLatitude']?.toDouble(),
      salonTreatmentsIds: (json['salonTreatmentsIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      salonSpecialistsIds: (json['salonSpecialistsIds'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      ownerId: json['ownerId'],
    );
  }
}