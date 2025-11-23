class TeamMember {
  final String id;
  final String fullName;
  final String? email;
  final String? userId;
  final String? profilePhotoPath;  
  final String status;            
  
  TeamMember({
    required this.id,
    required this.fullName,
    this.email,
    this.userId,
    this.profilePhotoPath,
    this.status = 'PENDING',  // Par défaut PENDING
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userId': userId,
      'profilePhotoPath': profilePhotoPath,
      'status': status,
    };
  }
  
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'],
      userId: json['userId'],
      profilePhotoPath: json['profilePhotoPath'],
      status: json['status'] ?? 'PENDING',
    );
  }
}