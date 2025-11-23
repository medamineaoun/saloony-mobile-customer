class User {
  final String userId;
  String userEmail;
  String userFirstName;
  String userLastName;
  String? userPhoneNumber;
  String userStatus;
  String appRole;
  String? profilePhotoPath;
  String? userGender;
  bool userEtat;

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
      userId: json['userId'] as String? ?? '',
      userEmail: json['userEmail'] as String? ?? '',
      userFirstName: json['userFirstName'] as String? ?? '',
      userLastName: json['userLastName'] as String? ?? '',
      userPhoneNumber: json['userPhoneNumber'] as String?,
      userStatus: json['userStatus'] as String? ?? 'ACTIVE',
      appRole: json['appRole'] as String? ?? 'CUSTOMER',
      profilePhotoPath: json['profilePhotoPath'] as String?,
      userGender: json['userGender'] as String?,
      userEtat: json['userEtat'] as bool? ?? true,
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

  /// Update user with new data
  void updateFromJson(Map<String, dynamic> json) {
    userEmail = json['userEmail'] as String? ?? userEmail;
    userFirstName = json['userFirstName'] as String? ?? userFirstName;
    userLastName = json['userLastName'] as String? ?? userLastName;
    userPhoneNumber = json['userPhoneNumber'] as String? ?? userPhoneNumber;
    userStatus = json['userStatus'] as String? ?? userStatus;
    appRole = json['appRole'] as String? ?? appRole;
    profilePhotoPath = json['profilePhotoPath'] as String? ?? profilePhotoPath;
    userGender = json['userGender'] as String? ?? userGender;
    userEtat = json['userEtat'] as bool? ?? userEtat;
  }

  /// Create a copy of the user with optional field updates
  User copyWith({
    String? userId,
    String? userEmail,
    String? userFirstName,
    String? userLastName,
    String? userPhoneNumber,
    String? userStatus,
    String? appRole,
    String? profilePhotoPath,
    String? userGender,
    bool? userEtat,
  }) {
    return User(
      userId: userId ?? this.userId,
      userEmail: userEmail ?? this.userEmail,
      userFirstName: userFirstName ?? this.userFirstName,
      userLastName: userLastName ?? this.userLastName,
      userPhoneNumber: userPhoneNumber ?? this.userPhoneNumber,
      userStatus: userStatus ?? this.userStatus,
      appRole: appRole ?? this.appRole,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      userGender: userGender ?? this.userGender,
      userEtat: userEtat ?? this.userEtat,
    );
  }
}