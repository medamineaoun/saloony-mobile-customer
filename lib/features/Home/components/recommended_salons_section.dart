import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/services/LocationService.dart';
import 'package:saloony/core/Config/Config.dart' as app_config;
import 'package:saloony/features/Home/views/SalonDetailPage.dart';

class RecommendedSalonsSection extends StatelessWidget {
  final List<Salon> salons;
  final LocationService locationService;
  final VoidCallback? onViewAll;

  const RecommendedSalonsSection({
    super.key,
    required this.salons,
    required this.locationService,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (salons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recommended for you',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View all',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFF0CD97),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: List.generate(
                salons.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index < salons.length - 1 ? 12 : 0,
                  ),
                  child: RecommendedSalonCard(
                    salon: salons[index],
                    locationService: locationService,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecommendedSalonCard extends StatefulWidget {
  final Salon salon;
  final LocationService locationService;

  const RecommendedSalonCard({
    super.key,
    required this.salon,
    required this.locationService,
  });

  @override
  State<RecommendedSalonCard> createState() => _RecommendedSalonCardState();
}

class _RecommendedSalonCardState extends State<RecommendedSalonCard> {
  bool _isFavorite = false;

  String? get _distance {
    if (widget.salon.salonLatitude == null || widget.salon.salonLongitude == null) {
      return null;
    }

    final distance = widget.locationService.getDistanceToSalon(
      widget.salon.salonLatitude!,
      widget.salon.salonLongitude!,
    );

    if (distance == null) {
      return null;
    }

    return '${distance.toStringAsFixed(1)}KM';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.salon.salonPhotosPaths?.isNotEmpty == true
        ? '${app_config.Config.salonBaseUrl}/photos/${widget.salon.salonPhotosPaths!.first}'
        : 'https://via.placeholder.com/250x200';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SalonDetailPage(salon: widget.salon),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite button
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.store,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.salon.salonName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B2B3E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 3),
                      if (_distance != null)
                        Text(
                          _distance!,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.grey[600],
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
