import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/services/LocationService.dart';
import 'package:saloony/core/Config/Config.dart' as app_config;
import 'package:saloony/features/Home/views/SalonDetailPage.dart';

class SalonCard extends StatelessWidget {
  final Salon salon;
  final LocationService locationService;

  const SalonCard({
    required this.salon,
    required this.locationService,
  });

  String? get _distance {
    if (salon.salonLatitude == null || salon.salonLongitude == null) {
      return null;
    }
    
    final distance = locationService.getDistanceToSalon(
      salon.salonLatitude!,
      salon.salonLongitude!,
    );
    
    if (distance == null) {
      return null;
    }
    
    return '${distance.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    // Build complete photo URL
    final imageUrl = salon.salonPhotosPaths?.isNotEmpty == true
        ? '${app_config.Config.salonBaseUrl}/photos/${salon.salonPhotosPaths!.first}'
        : 'https://via.placeholder.com/400x200';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalonDetailPage(salon: salon),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(Icons.store, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          salon.salonName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          salon.salonDescription ?? 'Salon',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (_distance != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0CD97).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _distance!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1B2B3E),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
