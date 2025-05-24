import 'package:geolocator/geolocator.dart';

class PositionService {
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permission de localisation refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permission de localisation définitivement refusée.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
