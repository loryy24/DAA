import 'dart:io';

class ApiConfig {
  static String get baseUrl {
    // Pour Android Emulator, on utilise 10.0.2.2
    if (Platform.isAndroid) {
      return 'http://192.168.100.205:3000';
    }

    // Sinon (Web, iOS, Android physique...), on utilise l'IP locale du PC
    return 'http://192.168.100.205:3000'; // remplace cette IP si elle change
  }
}
