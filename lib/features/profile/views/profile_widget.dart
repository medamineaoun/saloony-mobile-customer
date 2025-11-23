import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saloony/core/constants/app_routes.dart';
import 'dart:io';

import '../view_models/profile_view_model.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, vm, child) {
          // Loader
          if (vm.isLoading && vm.fullName.isEmpty) {
            return const Scaffold(
              backgroundColor: Color(0xFFF8F9FA),
              body: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF0CD97),
                ),
              ),
            );
          }

          // Erreur
          if (vm.errorMessage != null && vm.fullName.isEmpty) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8F9FA),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        vm.errorMessage!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => vm.loadProfile(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2B3E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          'Réessayer',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Contenu profile
          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  // Header avec avatar et info
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1B2B3E), Color(0xFF243441)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B2B3E).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 32.0,
                        ),
                        child: Column(
                          children: [
                            // Avatar
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFF0CD97),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFF0CD97)
                                            .withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: vm.selectedImageFile != null
                                        ? Image.file(
                                            vm.selectedImageFile!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            vm.avatarUrl,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                width: 100,
                                                height: 100,
                                                color: const Color(0xFFF0CD97)
                                                    .withOpacity(0.2),
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Color(0xFFF0CD97),
                                                ),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () =>
                                        vm.showImageSourceDialog(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0CD97),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF1B2B3E),
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 18,
                                        color: Color(0xFF1B2B3E),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Nom
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    vm.fullName.isNotEmpty
                                        ? vm.fullName
                                        : 'Utilisateur',
                                    style: GoogleFonts.poppins(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0CD97)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                      color: Color(0xFFF0CD97),
                                    ),
                                    onPressed: () =>
                                        vm.goToProfileEdit(context),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Email
                            Text(
                              vm.email.isNotEmpty
                                  ? vm.email
                                  : 'email@example.com',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color:
                                    const Color(0xFFF0CD97).withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Sections
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildSection(
                          title: 'Account',
                          items: [
                            _ProfileMenuItem(
                                icon: Icons.person_outline_rounded,
                                title: 'Modifier le profil',
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AppRoutes.editProfile);
                                }),
                            _ProfileMenuItem(
                                icon: Icons.email_outlined,
                                title: 'Change Email',
                                onTap: () => vm.goToChangeEmail(context)),
                            _ProfileMenuItem(
                                icon: Icons.phone_outlined,
                                title: 'Change Phone Number',
                                onTap: () => vm.goToChangePhoneNumber(context)),
                            _ProfileMenuItem(
                                icon: Icons.lock_outline_rounded,
                                title: 'Change Password',
                                onTap: () => vm.goToChangePassword(context)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildSection(
                          title: 'Support',
                          items: [
                            _ProfileMenuItem(
                                icon: Icons.people_outline_rounded,
                                title: 'Invite Friends',
                                onTap: () => vm.goToInvitesFriends(context)),
                            _ProfileMenuItem(
                                icon: Icons.help_outline_rounded,
                                title: 'FAQs',
                                onTap: () => vm.goToFaq(context)),
                            _ProfileMenuItem(
                                icon: Icons.info_outline_rounded,
                                title: 'About Us',
                                onTap: () => vm.goToAboutUs(context)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Logout
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => vm.logout(context),
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.logout_rounded,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                        'Logout',
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            // Barre de navigation en bas
            bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_ProfileMenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
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
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.vertical(
                        top: index == 0 ? const Radius.circular(16) : Radius.zero,
                        bottom: isLast ? const Radius.circular(16) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1B2B3E).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                item.icon,
                                color: const Color(0xFFF0CD97),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                item.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1B2B3E),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Padding(
                      padding: const EdgeInsets.only(left: 76),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey[200],
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

// ================= BottomNavBar =================
class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const BottomNavBar({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _selectedIndex;
  final List<String> _routes = [
    AppRoutes.home,
    '', // calendrier
    '', // favoris
    AppRoutes.profile,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    final routeName = _routes[index];
    if (routeName.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 0),
              _buildNavItem(Icons.calendar_today_rounded, 1),
              _buildNavItem(Icons.favorite_border_rounded, 2),
              _buildNavItem(Icons.person_outline_rounded, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1B2B3E) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFFF0CD97) : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }
}
