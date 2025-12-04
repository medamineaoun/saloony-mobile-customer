import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/features/Home/views/BottomNavBar.dart';
import 'package:saloony/features/Home/views/SalonListPage.dart';
import 'package:saloony/features/Home/views/ServiceListPage.dart';
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/core/services/AppointmentService.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/services/LocationService.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/constants/saloony_colors.dart';
import 'package:saloony/features/Home/components/appointment_card.dart';
import 'package:saloony/features/Home/components/services_section.dart';
import 'package:saloony/features/Home/components/salon_card.dart';
import 'package:saloony/features/Home/components/search_filters_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TreatmentService _treatmentService;
  late SalonService _salonService;
  late AppointmentService _appointmentService;
  late AuthService _authService;
  late LocationService _locationService;
  
  List<Treatment> _treatments = [];
  List<Salon> _salons = [];
  List<AppointmentDTO> _appointments = [];
  
  bool _loadingSalons = true;
  bool _loadingAppointments = true;
  String _selectedCategory = 'HAIRCUT';
  String? _userName = 'User';
  String? _userProfilePhoto;

  @override
  void initState() {
    super.initState();
    _treatmentService = TreatmentService();
    _salonService = SalonService();
    _appointmentService = AppointmentService();
    _authService = AuthService();
    _locationService = LocationService();
    
    _loadTreatments();
    _loadSalons();
    _loadAppointments();
    _loadUserData();
    
    // Show location modal after page render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showLocationPermissionModal();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final result = await _authService.getCurrentUser();
      if (result['success'] && result['user'] != null) {
        final Map<String, dynamic> userData = result['user'];
        setState(() {
          _userName = userData['userFirstName'] ?? 'User';
          _userProfilePhoto = userData['profilePhotoPath'];
        });
      }
    } catch (e) {
      debugPrint('Error loading user: $e');
    }
  }

  void _showLocationPermissionModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titre
                Text(
                  'Enable Location',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0CD97).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.location_on_rounded,
                    size: 60,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Description
                Text(
                  _locationService.isWebPlatform
                      ? 'We need to know your location in order to suggest nearby services'
                      : 'We need to know your location in order to suggest nearby services',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Bouton Enable Location
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      if (!_locationService.isWebPlatform) {
                        await _requestLocationPermission();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Enable Location',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Bouton Later (optionnel)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Maybe Later',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    try {
      final position = await _locationService.getCurrentLocation();
      if (position != null) {
        debugPrint('Location obtained: ${position.latitude}, ${position.longitude}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location enabled successfully'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please enable location in settings'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error obtaining location: $e');
    }
  }

  Future<void> _loadTreatments() async {
    try {
      final result = await _treatmentService.getAllTreatments();
      if (result['success']) {
        final List<Treatment> treatments = (result['treatments'] as List)
            .map((t) => Treatment.fromJson(t as Map<String, dynamic>))
            .toList();
        setState(() {
          _treatments = treatments;
        });
      }
    } catch (e) {
      debugPrint('Erreur chargement traitements: $e');
    }
  }

  Future<void> _loadSalons() async {
    try {
      final result = await _salonService.getAllSalons();
      if (result['success']) {
        final salons = result['salons'];
        if (salons is List) {
          setState(() {
            _salons = List<Salon>.from(salons);
            _loadingSalons = false;
          });
        } else {
          setState(() => _loadingSalons = false);
          debugPrint('Invalid salon format');
        }
      } else {
        setState(() => _loadingSalons = false);
        debugPrint('Erreur: ${result['message']}');
      }
    } catch (e) {
      debugPrint('Erreur chargement salons: $e');
      setState(() => _loadingSalons = false);
    }
  }

  Future<void> _loadAppointments() async {
    try {
      final result = await _appointmentService.getAppointmentsByUserId();
      if (result['success']) {
        setState(() {
          _appointments = result['appointments'] ?? [];
          _loadingAppointments = false;
        });
      } else {
        setState(() => _loadingAppointments = false);
      }
    } catch (e) {
      debugPrint('Error loading appointments: $e');
      setState(() => _loadingAppointments = false);
    }
  }

  List<Treatment> get _filteredTreatments {
    return _treatments
        .where((t) => t.treatmentCategory == _selectedCategory)
        .toList();
  }

  List<AppointmentDTO> get _upcomingAppointments {
    return _appointments
        .where((a) =>
            a.appointmentStatus == 'CONFIRMED' ||
            a.appointmentStatus == 'PENDING')
        .toList();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B2B3E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.person,
        color: Color(0xFFF0CD97),
        size: 30,
      ),
    );
  }

  void _showSearchModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SearchFiltersModal(
        salons: _salons,
        treatments: _treatments,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeader(),
            _buildAppointmentCard(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildServicesSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            _buildNearestSalonHeader(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            _buildSalonsList(),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
        bottomNavigationBar: BottomNavBar(), // déjà présent
    );
  }

  /// Build header section with avatar and buttons
  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildUserAvatar(),
                const Spacer(),
                _buildNotificationButton(),
                const SizedBox(width: 12),
                _buildSearchButton(),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Hi, $_userName',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B2B3E),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build user avatar with profile photo
  Widget _buildUserAvatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF0CD97),
          width: 2,
        ),
      ),
      child: _userProfilePhoto != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _userProfilePhoto!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultAvatar();
                },
              ),
            )
          : _buildDefaultAvatar(),
    );
  }

  /// Build notification button
  Widget _buildNotificationButton() {
    return Container(
      padding: const EdgeInsets.all(10),
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
      child: const Icon(
        Icons.notifications_outlined,
        color: Color(0xFF1B2B3E),
        size: 22,
      ),
    );
  }

  /// Build search button
  Widget _buildSearchButton() {
    return GestureDetector(
      onTap: () => _showSearchModal(context),
      child: Container(
        padding: const EdgeInsets.all(10),
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
        child: const Icon(
          Icons.search,
          color: Color(0xFF1B2B3E),
          size: 22,
        ),
      ),
    );
  }

  /// Build appointment card section
  Widget _buildAppointmentCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: _loadingAppointments
            ? Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : _upcomingAppointments.isNotEmpty
                ? AppointmentCard(
                    appointment: _upcomingAppointments.first,
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        'No appointments scheduled',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  /// Build services section
  Widget _buildServicesSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Services',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: SaloonyColors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ServiceListPage(),
                      ),
                    );
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SaloonyColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ServicesSection(
            treatments: _filteredTreatments,
            onCategorySelected: (category) {
              setState(() => _selectedCategory = category);
            },
            selectedCategory: _selectedCategory,
          ),
        ],
      ),
    );
  }

  /// Build nearest salon section header
  Widget _buildNearestSalonHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nearest salon',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1B2B3E),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalonListPage(),
                  ),
                );
              },
              child: Text(
                'View All',
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
    );
  }

  /// Build salons list
  Widget _buildSalonsList() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      sliver: _loadingSalons
          ? const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _salons.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'No salon available',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SalonCard(
                        salon: _salons[index],
                        locationService: _locationService,
                      ),
                    ),
                    childCount: _salons.length,
                  ),
                ),
    );
  }
}
