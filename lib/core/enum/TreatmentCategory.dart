enum TreatmentCategory {
  HAIRCUT(
    'HAIRCUT', 
    'Haircut', 
    'images/treatment_categories/haircut.png'
  ),
  COLORING(
    'COLORING', 
    'Coloring', 
    'images/treatment_categories/coloring.png'
  ),
  BEARD(
    'BEARD', 
    'Beard', 
    'images/treatment_categories/beard.png'
  ),
  FACIAL(
    'FACIAL', 
    'Facial', 
    'images/treatment_categories/facial.png'
  ),
  MASSAGE(
    'MASSAGE', 
    'Massage', 
    'images/treatment_categories/massage.png'
  ),
  NAILS(
    'NAILS', 
    'Nails', 
    'images/treatment_categories/nails.png'
  ),
  WAXING(
    'WAXING', 
    'Waxing', 
    'images/treatment_categories/waxing.png'
  ),
  MAKEUP(
    'MAKEUP', 
    'Makeup', 
    'images/treatment_categories/makeup.png'
  );

  final String value;
  final String displayName;
  final String imagePath;

  const TreatmentCategory(this.value, this.displayName, this.imagePath);

  static TreatmentCategory fromString(String value) {
    return TreatmentCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TreatmentCategory.HAIRCUT,
    );
  }
}