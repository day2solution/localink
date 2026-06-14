import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localink/model/location_data.dart';
import 'package:logging/logging.dart';

class LocationUtil {
  static final Logger _log = Logger('LocationUtil');

  /// Fetches the current location and address.
  /// Returns a [LocationData] object if successful, or null if permissions are denied or service is disabled.
  static Future<LocationData?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _log.warning("Location services are disabled.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _log.warning("Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _log.warning("Location permissions are permanently denied.");
      return null;
    }

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = "Unknown Address";
      String? street, locality, country;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        street = place.street;
        locality = place.locality;
        country = place.country;
        final components = [place.subLocality, place.locality, place.country]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        address = components.isNotEmpty ? components.join(", ") : "Unknown Address";
      }

      final locationData = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        street: street,
        locality: locality,
        country: country,
      );

      _log.info("Fetched Location: $locationData");
      return locationData;
    } catch (e) {
      _log.severe("Error getting current location: $e");
      return null;
    }
  }
}
