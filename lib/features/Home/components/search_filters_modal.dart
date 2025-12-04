import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/Salon.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/enum/TreatmentCategory.dart';

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
