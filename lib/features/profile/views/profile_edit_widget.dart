import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:saloony/core/constants/SaloonyColors.dart';
import 'package:saloony/features/profile/view_models/profile_edit_view_model.dart';

class ProfileEditView extends StatelessWidget {
  const ProfileEditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileEditViewModel(context),
      child: const _ProfileEditContent(),
    );
  }
}

class _ProfileEditContent extends StatelessWidget {
  const _ProfileEditContent();

  void _showImageOptions(BuildContext context, ProfileEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Photo de profil',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: SaloonyColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            _ImageOptionTile(
              icon: Icons.photo_library_outlined,
              title: 'Galerie',
              subtitle: 'Choisir depuis la galerie',
              onTap: () {
                Navigator.pop(context);
                viewModel.pickImage();
              },
            ),
            const SizedBox(height: 12),
            _ImageOptionTile(
              icon: Icons.camera_alt_outlined,
              title: 'Appareil photo',
              subtitle: 'Prendre une photo',
              onTap: () {
                Navigator.pop(context);
                viewModel.takePhoto();
              },
            ),
            if (viewModel.profileImageUrl != null) ...[
              const SizedBox(height: 12),
              _ImageOptionTile(
                icon: Icons.delete_outline,
                title: 'Supprimer',
                subtitle: 'Retirer la photo de profil',
                onTap: () {
                  Navigator.pop(context);
                  viewModel.removeProfilePhoto();
                },
                isDestructive: true,
              ),
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProfileEditViewModel>();

    if (viewModel.isLoadingData) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(SaloonyColors.secondary),
              ),
              const SizedBox(height: 16),
              Text(
                'Chargement...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: SaloonyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: SaloonyColors.primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Modifier le profil',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: SaloonyColors.primary,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture Section
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showImageOptions(context, viewModel),
                            child: Stack(
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        SaloonyColors.primary.withOpacity(0.1),
                                        SaloonyColors.secondary.withOpacity(0.1),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: SaloonyColors.primary.withOpacity(0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: _buildProfileImage(viewModel),
                                  ),
                                ),
                                Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          SaloonyColors.secondary,
                                          SaloonyColors.gold,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: SaloonyColors.secondary.withOpacity(0.4),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: viewModel.isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                SaloonyColors.primary,
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: SaloonyColors.primary,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Modifier la photo',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: SaloonyColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Form Section
                    Text(
                      'Informations personnelles',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SaloonyColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // First Name
                    _ModernInputField(
                      label: 'Prénom',
                      value: viewModel.firstName,
                      onChanged: viewModel.setFirstName,
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),

                    // Last Name
                    _ModernInputField(
                      label: 'Nom',
                      value: viewModel.lastName,
                      onChanged: viewModel.setLastName,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 20),

                    // Gender
                    _ModernDropdownField(
                      label: 'Genre',
                      value: _formatGender(viewModel.gender),
                      items: const ['Homme', 'Femme'],
                      onChanged: viewModel.setGender,
                      icon: Icons.wc_outlined,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildSaveButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(ProfileEditViewModel viewModel) {
    if (viewModel.imageFile != null) {
      return Image.file(
        viewModel.imageFile!,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
      );
    } else if (viewModel.profileImageUrl != null) {
      return Image.network(
        viewModel.profileImageUrl!,
        fit: BoxFit.cover,
        width: 140,
        height: 140,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('❌ Error loading image: $error');
          return _buildDefaultAvatar();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              valueColor: const AlwaysStoppedAnimation<Color>(
                SaloonyColors.secondary,
              ),
            ),
          );
        },
      );
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            SaloonyColors.primary.withOpacity(0.1),
            SaloonyColors.secondary.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.person,
        size: 64,
        color: SaloonyColors.textSecondary.withOpacity(0.5),
      ),
    );
  }

  String _formatGender(String gender) {
    switch (gender.toUpperCase()) {
      case 'MEN':
        return 'Homme';
      case 'WOMEN':
        return 'Femme';
      default:
        return gender;
    }
  }

  Widget _buildSaveButton(BuildContext context, ProfileEditViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              SaloonyColors.secondary,
              SaloonyColors.gold,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: SaloonyColors.secondary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: viewModel.isLoading
              ? null
              : () async {
                  final result = await viewModel.saveChanges();
                  if (context.mounted) {
                   
                    if (result['success'] == true) {
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (context.mounted) {
                        Navigator.of(context).pop(true);
                      }
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      SaloonyColors.primary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Enregistrer',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SaloonyColors.primary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: SaloonyColors.primary,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// === Modern Input Field ===
class _ModernInputField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool enabled;

  const _ModernInputField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
    this.keyboardType,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SaloonyColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value)
            ..selection = TextSelection.fromPosition(
              TextPosition(offset: value.length),
            ),
          onChanged: onChanged,
          keyboardType: keyboardType,
          enabled: enabled,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: enabled ? SaloonyColors.textPrimary : SaloonyColors.textSecondary,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: SaloonyColors.secondary.withOpacity(0.7),
              size: 20,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: SaloonyColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

// === Modern Dropdown Field ===
class _ModernDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final IconData icon;

  const _ModernDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: SaloonyColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              dropdownColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: SaloonyColors.secondary.withOpacity(0.7),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        color: SaloonyColors.secondary.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: SaloonyColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) onChanged(val);
              },
            ),
          ),
        ),
      ],
    );
  }
}

// === Image Option Tile ===
class _ImageOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ImageOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive 
              ? SaloonyColors.error.withOpacity(0.05)
              : SaloonyColors.primary.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive
                ? SaloonyColors.error.withOpacity(0.1)
                : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isDestructive
                    ? SaloonyColors.error.withOpacity(0.1)
                    : SaloonyColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isDestructive 
                    ? SaloonyColors.error 
                    : SaloonyColors.secondary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDestructive 
                          ? SaloonyColors.error 
                          : SaloonyColors.primary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: SaloonyColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}