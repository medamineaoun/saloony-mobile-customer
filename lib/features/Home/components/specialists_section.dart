import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/models/TeamMember.dart';

class SpecialistsSection extends StatelessWidget {
  final List<TeamMember> specialists;
  final VoidCallback? onViewAll;

  const SpecialistsSection({
    super.key,
    required this.specialists,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
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
                'Our specialist',
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
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: List.generate(
                specialists.length,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index < specialists.length - 1 ? 16 : 0,
                  ),
                  child: SpecialistCard(specialist: specialists[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SpecialistCard extends StatelessWidget {
  final TeamMember specialist;

  const SpecialistCard({
    super.key,
    required this.specialist,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Avatar circulaire
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getAvatarColor(specialist.fullName),
              border: Border.all(
                color: Colors.grey[200] ?? Colors.grey,
                width: 2,
              ),
            ),
            child: specialist.profilePhotoPath != null &&
                    specialist.profilePhotoPath!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(
                      specialist.profilePhotoPath!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildDefaultAvatar();
                      },
                    ),
                  )
                : _buildDefaultAvatar(),
          ),
          const SizedBox(height: 12),
          // Nom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              specialist.fullName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1B2B3E),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Spécialité (placeholder - peut être modifié)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Specialist',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getAvatarColor(specialist.fullName),
      ),
      child: Center(
        child: Text(
          _getInitials(specialist.fullName),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFFFFB366), // Orange
      const Color(0xFFFFAAAAAA), // Rose clair
      const Color(0xFF9B7EBD), // Violet
      const Color(0xFF87CEEB), // Bleu ciel
      const Color(0xFF98D8C8), // Turquoise
    ];

    int hash = name.hashCode % colors.length;
    return colors[hash.abs()];
  }
}
