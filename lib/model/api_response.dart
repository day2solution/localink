class ApiResponse<T> {
  final String status;
  final String description;
  final String? error;
  final T? data;

  ApiResponse({
    required this.status,
    required this.description,
    this.error,
    this.data,
  });

  // Factory to create an instance from JSON
  // [fromJsonT] is a function that tells Dart how to convert the 'data' part
  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT
      ) {
    return ApiResponse<T>(
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      error: json['error'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}