import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/Treatment.dart';
import 'package:saloony/core/enum/TreatmentCategory.dart';

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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
          border: isSelected 
              ? Border.all(
                  color: const Color(0xFF7C3AED),
                  width: 2,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : const Color(0xFF1B2B3E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                category.imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.spa_rounded,
                    color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFF0CD97),
                    size: 40,
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.displayName,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1B2B3E),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (treatmentCount > 0)
              Text(
                '($treatmentCount)',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white70 : Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
