import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:url_launcher/url_launcher.dart';

class SaloonyColors {
  static const Color primary = Color(0xFF1B2B3E);
  static const Color secondary = Color(0xFFF0CD97);
  static const Color tertiary = Color(0xFFE1E2E2);
  static const Color navy = Color(0xFF243441);
  static const Color gold = Color(0xFFEDC087);
  static const Color lightGray = Color(0xFFD4D4D4);
  static const Color textPrimary = Color(0xFF1B2B3E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
}

class HelpCenterScreenP extends StatelessWidget {
  const HelpCenterScreenP({Key? key}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d ouvrir : $url';
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri uri = Uri.parse('https://wa.me/$phone');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible douvrir WhatsApp avec le numéro $phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaloonyColors.tertiary,
      appBar: AppBar(
        backgroundColor: SaloonyColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Service client",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    SaloonyColors.primary,
                    SaloonyColors.navy,
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: SaloonyColors.secondary.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: SaloonyColors.secondary,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      size: 40,
                      color: SaloonyColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Comment pouvons-nous vous aider ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Notre équipe est à votre écoute',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: SaloonyColors.tertiary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // FAQ Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      SaloonyColors.secondary,
                      SaloonyColors.gold,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: SaloonyColors.secondary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _launchURL('https://www.saloony.tn/'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.quiz_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               
                                const SizedBox(height: 4),
                              
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Section Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Contactez-nous',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Contact Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    _buildModernContactTile(
                      icon: Icons.phone_outlined,
                      iconColor: SaloonyColors.primary,
                      title: 'Téléphone',
                      subtitle: 'Appelez-nous directement',
                      onTap: () => _launchURL('tel:+21612345678'),
                      isFirst: true,
                    ),
                    _buildModernContactTile(
                      icon: Icons.language_outlined,
                      iconColor: SaloonyColors.primary,
                      title: 'Site web',
                      subtitle: 'Visitez notre site',
                      onTap: () => _launchURL('https://www.saloony.tn/'),
                    ),
                    _buildModernContactTile(
                      icon: FontAwesomeIcons.whatsapp,
                      iconColor: const Color(0xFF25D366),
                      title: 'WhatsApp',
                      subtitle: 'Message instantané',
                      onTap: () => _launchWhatsApp('21612345678'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Social Media Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Suivez-nous',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SaloonyColors.textPrimary,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    _buildModernContactTile(
                      icon: Icons.facebook,
                      iconColor: const Color(0xFF1877F2),
                      title: 'Facebook',
                      subtitle: '@saloonyfacebook',
                      onTap: () => _launchURL('https://www.facebook.com/saloonyfacebook'),
                      isFirst: true,
                    ),
                    _buildModernContactTile(
                      icon: Icons.music_note,
                      iconColor: Colors.black,
                      title: 'TikTok',
                      subtitle: '@saloonytiktok',
                      onTap: () => _launchURL('https://www.tiktok.com/@saloonytiktok'),
                    ),
                    _buildModernContactTile(
                      icon: Icons.camera_alt,
                      iconColor: const Color(0xFFE4405F),
                      title: 'Instagram',
                      subtitle: '@saloonyinsta',
                      onTap: () => _launchURL('https://www.instagram.com/saloonyinsta'),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildModernContactTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: !isLast
                ? const Border(
                    bottom: BorderSide(
                      color: SaloonyColors.tertiary,
                      width: 1,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: SaloonyColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: SaloonyColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: SaloonyColors.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: SaloonyColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}