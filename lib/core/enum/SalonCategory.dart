enum SalonCategory {
  barbershop(
    'BARBERSHOP', 
    'Barbershop', 
    'assets/images/salon_categories/barbershop.png'
  ),
  hairSalon(
    'HAIR_SALON', 
    'Hair Salon', 
    'assets/images/salon_categories/hair_salon.png'
  ),
  beautyInstitute(
    'BEAUTY_INSTITUTE', 
    'Beauty Institute', 
    'assets/images/salon_categories/beauty_institute.png'
  ),
  nailSalon(
    'NAIL_SALON', 
    'Nail Salon', 
    'assets/images/salon_categories/nail_salon.png'
  ),
  spaMassagesCenter(
    'SPA_MASSAGES_CENTER', 
    'Spa & Massages Center', 
    'assets/images/salon_categories/spa_massages_center.png'
  );

  final String value;
  final String displayName;
  final String imagePath;

  const SalonCategory(this.value, this.displayName, this.imagePath);

  static SalonCategory fromString(String value) {
    return SalonCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SalonCategory.barbershop,
    );
  }
}