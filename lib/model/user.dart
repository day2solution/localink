class User {
  final int? id;
  final String mobileNumber;
  final String? fullName;
  final String? bio;
  final String? profilePictureUrl;
  final String? address;
  final double? latitude;
  final double? longitude;
  final bool isVerified;
  final DateTime? createdAt;

  User({
    this.id,
    required this.mobileNumber,
    this.fullName,
    this.bio,
    this.profilePictureUrl,
    this.address,
    this.latitude,
    this.longitude,
    this.isVerified = false,
    this.createdAt,
  });

  // Convert JSON from Spring Boot to Dart Object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      mobileNumber: json['mobileNumber'] ?? '',
      fullName: json['fullName'],
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
      address: json['address'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  // Convert Dart Object to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'fullName': fullName,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'isVerified': isVerified,
      // createdAt is usually handled by @PrePersist in Spring Boot
    };
  }

  // Helper method to create a copy with updated fields
  User copyWith({
    String? fullName,
    String? bio,
    String? profilePictureUrl,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return User(
      id: id,
      mobileNumber: mobileNumber,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isVerified: isVerified,
      createdAt: createdAt,
    );
  }
}