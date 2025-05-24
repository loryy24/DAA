import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';
import 'package:proxibiz/modules/acceuil.dart';
import 'package:proxibiz/modules/contact.dart';
import 'package:proxibiz/services/position_service.dart';
import 'package:proxibiz/modules/login.dart';
import 'package:proxibiz/modules/connexion.dart';

class Entreprise {
  final int id;
  final String nom;
  final String description;
  final double latitude;
  final double longitude;
  final List<String> keywords;
  final String? numeroWhatsApp;
  final String? email;

  Entreprise({
    required this.id,
    required this.nom,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.keywords,
    this.email,
    this.numeroWhatsApp,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) {
    String description = json['description'];
    return Entreprise(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      description: description,
      latitude: json['latitude'],
      longitude: json['longitude'],
      keywords: extraireMotsCles(description),
      numeroWhatsApp: json['numeroWhatsApp'],
    );
  }
}

// Fonction pour extraire les mots-clés
List<String> extraireMotsCles(String description) {
  final stopwords = [
    'le', 'la', 'les', 'un', 'une', 'des', 'et', 'ou', 'à', 'de', 'du', 'dans', 'pour',
    'avec', 'sur', 'en', 'par', 'au', 'aux', 'ce', 'cet', 'cette', 'nos', 'vos', 'est',
    'qui', 'que', 'ne', 'pas', 'plus', 'moins', 'nous', 'vous', 'ils', 'elles', 'se'
  ];

  final cleaned = description
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(' ');

  final keywords = cleaned.where((mot) =>
  mot.length > 2 &&
      !stopwords.contains(mot)
  ).toSet();

  return keywords.toList();
}

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  List<Entreprise> _entreprises = [];
  List<Entreprise> _filteredEntreprises = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadEntreprises();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await PositionService.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _mapController.move(_currentPosition!, 15);
    } catch (e) {
      print("Erreur localisation : $e");
    }
  }

  Future<void> _loadEntreprises() async {
    try {
      final response = await http.get(Uri.parse("${ApiConfig.baseUrl}/entreprises"));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Entreprise> entreprises = data.map((e) => Entreprise.fromJson(e)).toList();
        setState(() {
          _entreprises = entreprises;
          _filteredEntreprises = entreprises;
        });
      } else {
        print("Erreur chargement entreprises : ${response.statusCode}");
      }
    } catch (e) {
      print("Exception chargement entreprises : $e");
    }
  }

  void _filterEntreprises(String query) {
    final lowerQuery = query.toLowerCase().trim();

    setState(() {
      _filteredEntreprises = _entreprises.where((e) {
        final nomMatch = e.nom.toLowerCase().contains(lowerQuery);
        final keywordMatch = e.keywords.any((kw) => kw.contains(lowerQuery));
        return nomMatch || keywordMatch;
      }).toList();
    });

    if (_filteredEntreprises.length == 1) {
      final entreprise = _filteredEntreprises.first;
      _mapController.move(
        LatLng(entreprise.latitude, entreprise.longitude),
        15,
      );
    }
  }

  void _showEntrepriseDetails(Entreprise entreprise) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              entreprise.nom,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              entreprise.description.length > 80
                  ? entreprise.description.substring(0, 80) + '...'
                  : entreprise.description,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Text(
              entreprise.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigue vers une page itinéraire
                      Navigator.pushNamed(
                        context,
                        '/itineraire',
                        arguments: entreprise,
                      );
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Itinéraire"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le bottom sheet
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactPage(entreprise: entreprise),
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text("Contactez-nous"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte des entreprises"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterEntreprises,
              decoration: InputDecoration(
                hintText: "Rechercher une entreprise...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _filterEntreprises('');
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_business),
              title: const Text("Inscrire mon entreprise"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Inscription()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Voir mon entreprise"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Connexion()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text("Voir toute les  entreprises "),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Accueil()),
                );
              },
            ),
          ],
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _currentPosition ?? const LatLng(6.3703, 2.3912),
          initialZoom: 13,
          minZoom: 5,
          maxZoom: 18,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          if (_currentPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
                ),
              ],
            ),
          MarkerLayer(
            markers: _filteredEntreprises.map((entreprise) {
              return Marker(
                point: LatLng(entreprise.latitude, entreprise.longitude),
                child: GestureDetector(
                  onTap: () => _showEntrepriseDetails(entreprise),
                  child: const Icon(Icons.business, color: Colors.red, size: 30),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
