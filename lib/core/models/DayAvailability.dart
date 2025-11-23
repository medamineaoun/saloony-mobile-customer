import 'package:flutter/material.dart';

/// Modèle pour la disponibilité d'un jour simple (sans horaires)
class DayAvailability {
  final String day;
  bool isAvailable;

  DayAvailability({
    required this.day,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'isAvailable': isAvailable,
    };
  }

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  DayAvailability copyWith({
    String? day,
    bool? isAvailable,
  }) {
    return DayAvailability(
      day: day ?? this.day,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}

/// Modèle pour la disponibilité avec plages horaires
class DayAvailabilityWithSlots {
  final String day;
  bool isAvailable;
  TimeRange? timeRange;

  DayAvailabilityWithSlots({
    required this.day,
    this.isAvailable = true,
    this.timeRange,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'isAvailable': isAvailable,
      'startTime': timeRange != null
          ? '${timeRange!.startTime.hour.toString().padLeft(2, '0')}:${timeRange!.startTime.minute.toString().padLeft(2, '0')}'
          : null,
      'endTime': timeRange != null
          ? '${timeRange!.endTime.hour.toString().padLeft(2, '0')}:${timeRange!.endTime.minute.toString().padLeft(2, '0')}'
          : null,
    };
  }

  factory DayAvailabilityWithSlots.fromJson(Map<String, dynamic> json) {
    TimeRange? range;

    if (json['startTime'] != null && json['endTime'] != null) {
      try {
        final startParts = json['startTime'].toString().split(':');
        final endParts = json['endTime'].toString().split(':');

        range = TimeRange(
          startTime: TimeOfDay(
            hour: int.parse(startParts[0]),
            minute: int.parse(startParts[1]),
          ),
          endTime: TimeOfDay(
            hour: int.parse(endParts[0]),
            minute: int.parse(endParts[1]),
          ),
        );
      } catch (e) {
        debugPrint('Erreur parsing time range: $e');
      }
    }

    return DayAvailabilityWithSlots(
      day: json['day'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      timeRange: range,
    );
  }

  DayAvailabilityWithSlots copyWith({
    String? day,
    bool? isAvailable,
    TimeRange? timeRange,
  }) {
    return DayAvailabilityWithSlots(
      day: day ?? this.day,
      isAvailable: isAvailable ?? this.isAvailable,
      timeRange: timeRange ?? this.timeRange,
    );
  }
}

/// Modèle pour une plage horaire (08:00 - 18:00 par exemple)
class TimeRange {
  TimeOfDay startTime;
  TimeOfDay endTime;

  TimeRange({
    required this.startTime,
    required this.endTime,
  });

  /// Retourne une représentation lisible, ex: "08:00 - 18:00"
  String format() {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}
