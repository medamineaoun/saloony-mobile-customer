import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/Config/Config.dart' as app_config;
import 'package:saloony/core/constants/SaloonyColors.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  late TreatmentService _treatmentService;
  late SalonService _salonService;
  
  List<Treatment> _treatments = [];
  List<Salon> _filteredSalons = [];
  bool _loading = true;
  String? _selectedTreatmentId;
  String? _selectedTreatmentName;

  @override
  void initState() {
    super.initState();
    _treatmentService = TreatmentService();
    _salonService = SalonService();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    try {
      final result = await _treatmentService.getAllTreatments();
      if (result['success']) {
        final treatments = (result['treatments'] as List)
            .map((t) => Treatment.fromJson(t as Map<String, dynamic>))
            .toList();
        setState(() {
          _treatments = treatments;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('Error loading treatments: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _filterSalonsByTreatment(String treatmentId) async {
    try {
      final result = await _salonService.getAllSalons();
      if (result['success']) {
        final salons = result['salons'];
        if (salons is List) {
          final filtered = List<Salon>.from(salons)
              .where((salon) =>
                  (salon.salonTreatmentsIds?.contains(treatmentId) ?? false))
              .toList();
          
          setState(() {
            _filteredSalons = filtered;
            _selectedTreatmentId = treatmentId;
            _selectedTreatmentName = _treatments
                .firstWhere((t) => t.treatmentId == treatmentId)
                .treatmentName;
          });
        }
      }
    } catch (e) {
      debugPrint('Error filtering salons: $e');
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
          'All Services',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SaloonyColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _selectedTreatmentId == null
              ? _buildServicesList()
              : _buildSalonsByService(),
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _treatments.length,
      itemBuilder: (context, index) {
        final treatment = _treatments[index];
        return GestureDetector(
          onTap: () => _filterSalonsByTreatment(treatment.treatmentId),
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: SaloonyColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: SaloonyColors.secondary,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          treatment.treatmentName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SaloonyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          treatment.treatmentDescription,
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
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: SaloonyColors.secondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSalonsByService() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: SaloonyColors.primary),
                    onPressed: () =>
                        setState(() => _selectedTreatmentId = null),
                  ),
                  Expanded(
                    child: Text(
                      'Salons offering $_selectedTreatmentName',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: SaloonyColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                '${_filteredSalons.length} salons found',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: SaloonyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredSalons.isEmpty
              ? Center(
                  child: Text(
                    'No salons offering this service',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredSalons.length,
                  itemBuilder: (context, index) {
                    final salon = _filteredSalons[index];
                    return _buildSalonCard(salon);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSalonCard(Salon salon) {
    final imageUrl = salon.salonPhotosPaths?.isNotEmpty == true
        ? '${app_config.Config.salonBaseUrl}/photos/${salon.salonPhotosPaths!.first}'
        : 'https://via.placeholder.com/400x200';

    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child:
                      const Icon(Icons.store, size: 40, color: Colors.grey),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salon.salonName,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: SaloonyColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: SaloonyColors.secondary),
                      const SizedBox(width: 4),
                      Text(
                        '5.0',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: SaloonyColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    salon.salonDescription ?? 'Salon',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: SaloonyColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
