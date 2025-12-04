import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/features/Home/views/BottomNavBar.dart';
import 'package:saloony/core/services/TreatmentService.dart';
import 'package:saloony/core/services/SalonService.dart';
import 'package:saloony/core/services/AppointmentService.dart';
import 'package:saloony/core/services/AuthService.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/models/User.dart';
import 'package:saloony/core/enum/TreatmentCategory.dart';

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
  
  List<Treatment> _treatments = [];
  List<Salon> _salons = [];
  List<AppointmentDTO> _appointments = [];
  bool _loadingSalons = true;
  bool _loadingAppointments = true;
  String _selectedCategory = 'HAIRCUT';
  
  User? _currentUser;
  String? _userName = 'User';
  String? _userProfilePhoto;

  @override
  void initState() {
    super.initState();
    _treatmentService = TreatmentService();
    _salonService = SalonService();
    _appointmentService = AppointmentService();
    _authService = AuthService();
    
    _loadTreatments();
    _loadSalons();
    _loadAppointments();
    _loadUserData();
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
      debugPrint('Erreur chargement utilisateur: $e');
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
          debugPrint('Format de salons invalide');
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
      debugPrint('Erreur chargement rendez-vous: $e');
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
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar with user profile photo
                        Container(
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
                        ),
                        const Spacer(),
                        // Notification
                        Container(
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
                        ),
                        const SizedBox(width: 12),
                        // Search
                        GestureDetector(
                          onTap: () {
                            _showSearchModal(context);
                          },
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Welcome text
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
                        Text(
                          '5391 Elgin St. Celina, Delaware 10299',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Appointment Card
            SliverToBoxAdapter(
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
                                'Aucun rendez-vous prévu',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Services Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Services',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: ServicesSection(
                treatments: _filteredTreatments,
                onCategorySelected: (category) {
                  setState(() => _selectedCategory = category);
                },
                selectedCategory: _selectedCategory,
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Nearest Salon Section
            SliverToBoxAdapter(
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
                      onPressed: () {},
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
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: _loadingSalons
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _salons.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'Aucun salon disponible',
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
                              child: SalonCard(salon: _salons[index]),
                            ),
                            childCount: _salons.length,
                          ),
                        ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

// Appointment Card Component
class AppointmentCard extends StatelessWidget {
  final AppointmentDTO appointment;

  const AppointmentCard({required this.appointment});

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B2B3E).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointment',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD97),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_formatDate(appointment.appointmentDate)}, ${appointment.appointmentTime ?? ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1B2B3E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD97).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.content_cut_rounded,
                  color: Color(0xFFF0CD97),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.salonName ?? 'Salon',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      appointment.treatmentName ?? 'Service',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFF0CD97).withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Services Section Component
class ServicesSection extends StatelessWidget {
  final List<Treatment> treatments;
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const ServicesSection({
    required this.treatments,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categories = TreatmentCategory.values;
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.value;
          final treatmentCount = treatments
              .where((t) => t.treatmentCategory == category.value)
              .length;
          
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ServiceCard(
              category: category,
              isSelected: isSelected,
              treatmentCount: treatmentCount,
              onTap: () => onCategorySelected(category.value),
            ),
          );
        },
      ),
    );
  }
}

// Service Card Component
class ServiceCard extends StatelessWidget {
  final TreatmentCategory category;
  final bool isSelected;
  final int treatmentCount;
  final VoidCallback onTap;

  const ServiceCard({
    required this.category,
    required this.isSelected,
    required this.treatmentCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0CD97) : Colors.white,
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
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : const Color(0xFF1B2B3E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                category.imagePath,
                width: 28,
                height: 28,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.spa_rounded,
                    color: isSelected ? const Color(0xFFF0CD97) : const Color(0xFFF0CD97),
                    size: 28,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.displayName,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF1B2B3E),
              ),
              textAlign: TextAlign.center,
            ),
            if (treatmentCount > 0)
              Text(
                '($treatmentCount)',
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                  color: isSelected ? Colors.white70 : Colors.grey,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Salon Card Component
class SalonCard extends StatelessWidget {
  final Salon salon;

  const SalonCard({
    required this.salon,
  });

  String get _distance {
    if (salon.salonLatitude == null || salon.salonLongitude == null) {
      return 'N/A';
    }
    // TODO: Calculer la distance réelle en fonction de la localisation de l'utilisateur
    return '${(salon.salonLatitude! * 2).toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    // Construire l'URL complète de la photo
    final baseUrl = 'http://localhost:8081/api/salon/photos/';
    final imageUrl = salon.salonPhotosPaths?.isNotEmpty == true
        ? '$baseUrl${salon.salonPhotosPaths!.first}'
        : 'https://via.placeholder.com/400x200';

    return Container(
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
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFF0CD97),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1B2B3E),
                          ),
                        ),
                      ],
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0CD97).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _distance,
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
    );
  }
}

// Search Filters Modal
class SearchFiltersModal extends StatefulWidget {
  final List<Salon> salons;
  final List<Treatment> treatments;

  const SearchFiltersModal({
    required this.salons,
    required this.treatments,
  });

  @override
  State<SearchFiltersModal> createState() => _SearchFiltersModalState();
}

class _SearchFiltersModalState extends State<SearchFiltersModal> {
  String _searchQuery = '';
  String? _selectedService;
  double _selectedRating = 0;
  String? _selectedGender;
  double _selectedDistance = 25;

  @override
  void initState() {
    super.initState();
  }

  void _applyFilters() {
    final filtered = widget.salons.where((salon) {
      // Search query filter
      if (_searchQuery.isNotEmpty &&
          !salon.salonName.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // Rating filter
      if (_selectedRating > 0) {
        // Assume rating is 4.5 for all salons for now
        if (4.5 < _selectedRating) return false;
      }

      // Gender filter
      if (_selectedGender != null &&
          salon.type.apiValue != _selectedGender) {
        return false;
      }

      return true;
    }).toList();

    // Return filtered salons to parent
    Navigator.pop(context, filtered);
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedService = null;
      _selectedRating = 0;
      _selectedGender = null;
      _selectedDistance = 25;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select filters',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Search Input
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search salons...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Services Filter
              Text(
                'Services',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: TreatmentCategory.values.map((category) {
                  final isSelected = _selectedService == category.value;
                  return FilterChip(
                    label: Text(category.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedService =
                            selected ? category.value : null;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFF7C3AED),
                    labelStyle: GoogleFonts.poppins(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Rating Filter
              Text(
                'Rating',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => GestureDetector(
                      onTap: () => setState(
                          () => _selectedRating = (index + 1).toDouble()),
                      child: Icon(
                        Icons.star,
                        color: index < _selectedRating
                            ? const Color(0xFFF0CD97)
                            : Colors.grey[300],
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_selectedRating.toInt()}.0 Stars',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Gender Filter
              Text(
                'Gender',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: ['MEN', 'WOMEN', 'MIXED']
                    .map((gender) {
                      final isSelected = _selectedGender == gender;
                      final displayName = gender == 'MEN'
                          ? 'Male'
                          : gender == 'WOMEN'
                              ? 'Female'
                              : 'Unisex';
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(displayName),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedGender = selected ? gender : null;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: const Color(0xFF7C3AED),
                          labelStyle: GoogleFonts.poppins(
                            color:
                                isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 24),

              // Distance Filter
              Text(
                'Distance',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B2B3E),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [5, 10, 15, 20, 25]
                    .map((distance) {
                      final isSelected = _selectedDistance == distance.toDouble();
                      return FilterChip(
                        label: Text('${distance}km'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedDistance = selected
                                ? distance.toDouble()
                                : 25;
                          });
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color(0xFF7C3AED),
                        labelStyle: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    })
                    .toList(),
              ),
              const SizedBox(height: 32),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Clear Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B2B3E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}