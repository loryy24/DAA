import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:proxibiz/modules/api_config.dart';

class ApiService {
  String get baseUrl {
    if (kIsWeb) {
      return 'http://192.168.100.205:3000'; // ✅ Remplace par l’IP locale de ton PC
    } else if (Platform.isAndroid) {
      return 'http://192.168.100.205:3000'; // ✅ Android Emulator
    } else {
      return 'http://localhost:3000'; // ✅ iOS, desktop, etc.
    }
  }
  

  Future<bool> inscrireEntreprise(Map<String, dynamic> entreprise) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/entreprises'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(entreprise),
    );

    return response.statusCode == 201;
  }

  // D'autres méthodes à venir ici (connexion, mot de passe, etc.)
}
