import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/enum/SalonCategory.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/features/Home/views/BottomNavBar.dart';
import 'package:saloony/features/Home/views/SalonsByCategoryPage.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    final categories = SalonCategory.values;

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
          'All Categories',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: SaloonyColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildCategoriesList(categories),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildCategoriesList(List<SalonCategory> categories) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _navigateToSalons(category),
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
                    child: Image.asset(
                      category.imagePath,
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.store,
                          color: SaloonyColors.secondary,
                          size: 40,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SaloonyColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to view salons',
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

  void _navigateToSalons(SalonCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SalonsByCategoryPage(category: category),
      ),
    );
  }
}
