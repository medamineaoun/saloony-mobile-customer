import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/Config/Config.dart' as app_config;
import 'package:saloony/core/constants/SaloonyColors.dart';

class SalonsByServicePage extends StatefulWidget {
  final Treatment treatment;

  const SalonsByServicePage({super.key, required this.treatment});

  @override
  State<SalonsByServicePage> createState() => _SalonsByServicePageState();
}

class _SalonsByServicePageState extends State<SalonsByServicePage> {
  late SalonService _salonService;
  late Future<List<Salon>> _salonsFuture;

  @override
  void initState() {
    super.initState();
    _salonService = SalonService();
    _salonsFuture = _loadSalonsByTreatment();
  }

  Future<List<Salon>> _loadSalonsByTreatment() async {
    try {
      final result = await _salonService.getAllSalons();
      if (result['success']) {
        final salons = result['salons'];
        if (salons is List) {
          final filtered = List<Salon>.from(salons)
              .where((salon) =>
                  (salon.salonTreatmentsIds?.contains(widget.treatment.treatmentId) ?? false))
              .toList();
          return filtered;
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error loading salons: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SaloonyColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.treatment.treatmentName,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SaloonyColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Salon>>(
        future: _salonsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final salons = snapshot.data ?? [];
          return _buildSalonsList(salons);
        },
      ),
    );
  }

  Widget _buildSalonsList(List<Salon> salons) {
    if (salons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.store,
              size: 60,
              color: SaloonyColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No salons offering this service',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${salons.length} salons found',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SaloonyColors.primary,
            ),
          ),
        ),
        ...salons.map((salon) => _buildSalonCard(salon)).toList(),
      ],
    );
  }

  Widget _buildSalonCard(Salon salon) {
    final imageUrl = salon.salonPhotosPaths?.isNotEmpty == true
        ? '${app_config.Config.salonBaseUrl}/photos/${salon.salonPhotosPaths!.first}'
        : 'https://via.placeholder.com/400x200';

    return GestureDetector(
      onTap: () {
        debugPrint('Tapped on salon: ${salon.salonName}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.store,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.salonName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: SaloonyColors.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '5.0',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: SaloonyColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          salon.salonCategory.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: SaloonyColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    salon.salonDescription ?? 'Salon de beauté',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: SaloonyColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
