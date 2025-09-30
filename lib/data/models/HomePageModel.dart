import 'package:flutter/material.dart';

class HomePageModel extends ChangeNotifier {
  // Liste des services
  List<ServiceModel> services = [
    ServiceModel(label: 'Haircut', image: null),
    ServiceModel(label: 'Makeup', image: 'https://plus.unsplash.com/...'),
    ServiceModel(label: 'Manicure', image: 'https://images.unsplash.com/...'),
    ServiceModel(label: 'Massage', image: 'https://images.unsplash.com/...'),
  ];

  // Liste des salons proches
  List<SalonModel> salons = [
    SalonModel(
      name: 'Unisex Salon',
      location: 'Dwarka New Delhi, India',
      away: '5 km',
      rating: '4.5',
      image: 'https://images.unsplash.com/photo-1633681926035-ec1ac984418a',
    ),
    SalonModel(
      name: 'Tanishk unisex salon',
      location: 'Dwarka New Delhi, India',
      away: '5 km',
      rating: '4.5',
      image: 'https://images.unsplash.com/photo-1595944024804-733665a112db',
    ),
    SalonModel(
      name: 'Amara Beauty salon',
      location: 'Dwarka New Delhi, India',
      away: '5 km',
      rating: '4.5',
      image: 'https://images.unsplash.com/photo-1580618662966-832a2dcea59f',
    ),
  ];
}

class ServiceModel {
  final String label;
  final String? image;

  ServiceModel({required this.label, this.image});
}

class SalonModel {
  final String name;
  final String location;
  final String away;
  final String rating;
  final String image;

  SalonModel({
    required this.name,
    required this.location,
    required this.away,
    required this.rating,
    required this.image,
  });
}
