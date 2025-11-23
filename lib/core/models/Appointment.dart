class Appointment {
  final String id;
  final String clientName;
  final String clientImage;
  final String date;
  final String time;
  final int servicesCount;
  final double price;

  Appointment({
    required this.id,
    required this.clientName,
    required this.clientImage,
    required this.date,
    required this.time,
    required this.servicesCount,
    required this.price,
  });

  Appointment copyWith({
    String? id,
    String? clientName,
    String? clientImage,
    String? date,
    String? time,
    int? servicesCount,
    double? price,
  }) {
    return Appointment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientImage: clientImage ?? this.clientImage,
      date: date ?? this.date,
      time: time ?? this.time,
      servicesCount: servicesCount ?? this.servicesCount,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'clientImage': clientImage,
      'date': date,
      'time': time,
      'servicesCount': servicesCount,
      'price': price,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      clientImage: json['clientImage'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      servicesCount: json['servicesCount'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }
}
