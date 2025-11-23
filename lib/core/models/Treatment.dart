class Treatment {
  final String treatmentId;
  final String treatmentName;
  final String treatmentDescription;
  final String treatmentCategory;
  final double? treatmentTime; // en heures
  final double? duration; // en minutes (ajouté)
  final double? treatmentPrice;
  final List<String>? treatmentPhotosPaths;

  Treatment({
    required this.treatmentId,
    required this.treatmentName,
    required this.treatmentDescription,
    required this.treatmentCategory,
    this.treatmentTime,
    this.duration,
    this.treatmentPrice,
    this.treatmentPhotosPaths,
  });

  factory Treatment.fromJson(Map<String, dynamic> json) {
    final treatmentTime = _parseDouble(json['treatmentTime']);
    return Treatment(
      treatmentId: json['treatmentId']?.toString() ?? '',
      treatmentName: json['treatmentName'] ?? '',
      treatmentDescription: json['treatmentDescription'] ?? '',
      treatmentCategory: json['treatmentCategory'] ?? '',
      treatmentTime: treatmentTime,
      duration: treatmentTime != null ? treatmentTime * 60 : null, // convertit en minutes
      treatmentPrice: _parseDouble(json['treatmentPrice']),
      treatmentPhotosPaths: json['treatmentPhotosPaths'] != null
          ? List<String>.from(json['treatmentPhotosPaths'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'treatmentId': treatmentId,
      'treatmentName': treatmentName,
      'treatmentDescription': treatmentDescription,
      'treatmentCategory': treatmentCategory,
      'treatmentTime': treatmentTime,
      'duration': duration,
      'treatmentPrice': treatmentPrice,
      'treatmentPhotosPaths': treatmentPhotosPaths,
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Treatment copyWith({
    String? treatmentId,
    String? treatmentName,
    String? treatmentDescription,
    String? treatmentCategory,
    double? treatmentTime,
    double? duration,
    double? treatmentPrice,
    List<String>? treatmentPhotosPaths,
  }) {
    return Treatment(
      treatmentId: treatmentId ?? this.treatmentId,
      treatmentName: treatmentName ?? this.treatmentName,
      treatmentDescription: treatmentDescription ?? this.treatmentDescription,
      treatmentCategory: treatmentCategory ?? this.treatmentCategory,
      treatmentTime: treatmentTime ?? this.treatmentTime,
      duration: duration ?? this.duration,
      treatmentPrice: treatmentPrice ?? this.treatmentPrice,
      treatmentPhotosPaths: treatmentPhotosPaths ?? this.treatmentPhotosPaths,
    );
  }

  @override
  String toString() {
    return 'Treatment(id: $treatmentId, name: $treatmentName, time: $treatmentTime h, duration: $duration min, price: $treatmentPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Treatment && other.treatmentId == treatmentId;
  }

  @override
  int get hashCode => treatmentId.hashCode;
}
