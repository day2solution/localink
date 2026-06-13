class AuthResponse {
  final String accessToken;
  final String mobileNumber;
  final String message;
  final bool userFound;

  AuthResponse({
    required this.accessToken,
    required this.mobileNumber,
    required this.message,
    this.userFound = false,
  });

  // Factory method to create an AuthResponse from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      message: json['message'] ?? '',
      userFound: json['userFound'] ?? true,
    );
  }

  // Method to convert the object back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'mobileNumber': mobileNumber,
      'message': message,
      'userFound': userFound,
    };
  }
}