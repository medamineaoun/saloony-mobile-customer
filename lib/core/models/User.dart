class User {
  final String userId;
  final String userEmail;
  final String userFirstName;
  final String userLastName;
  final String? userPhoneNumber;
  final String userStatus;
  final String appRole;
  final String? profilePhotoPath;
  final String? userGender;
  final bool userEtat;

  User({
    required this.userId,
    required this.userEmail,
    required this.userFirstName,
    required this.userLastName,
    this.userPhoneNumber,
    required this.userStatus,
    required this.appRole,
    this.profilePhotoPath,
    this.userGender,
    required this.userEtat,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userEmail: json['userEmail'],
      userFirstName: json['userFirstName'],
      userLastName: json['userLastName'],
      userPhoneNumber: json['userPhoneNumber'],
      userStatus: json['userStatus'],
      appRole: json['appRole'],
      profilePhotoPath: json['profilePhotoPath'],
      userGender: json['userGender'],
      userEtat: json['userEtat'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'userFirstName': userFirstName,
      'userLastName': userLastName,
      'userPhoneNumber': userPhoneNumber,
      'userStatus': userStatus,
      'appRole': appRole,
      'profilePhotoPath': profilePhotoPath,
      'userGender': userGender,
      'userEtat': userEtat,
    };
  }

  String get fullName => '$userFirstName $userLastName'.trim();
}