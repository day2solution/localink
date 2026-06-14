class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final String? street;
  final String? locality;
  final String? country;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.street,
    this.locality,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'street': street,
      'locality': locality,
      'country': country,
    };
  }

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      street: json['street'],
      locality: json['locality'],
      country: json['country'],
    );
  }

  @override
  String toString() {
    return 'LocationData(latitude: $latitude, longitude: $longitude, address: $address, street: $street, locality: $locality, country: $country)';
  }
}
