import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/features/Home/views/BottomNavBar.dart';
import 'package:saloony/features/Home/views/SalonsByServicePage.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  late TreatmentService _treatmentService;
  List<Treatment> _treatments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _treatmentService = TreatmentService();
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

  void _navigateToSalons(Treatment treatment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonsByServicePage(treatment: treatment),
      ),
    );
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
          : _buildServicesList(),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildServicesList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: _treatments.length,
        itemBuilder: (context, index) {
          final treatment = _treatments[index];
          return _buildServiceCard(treatment);
        },
      ),
    );
  }

  Widget _buildServiceCard(Treatment treatment) {
    return GestureDetector(
      onTap: () => _navigateToSalons(treatment),
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: SaloonyColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.spa_rounded,
                color: SaloonyColors.secondary,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                treatment.treatmentName,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
