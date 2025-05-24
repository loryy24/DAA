import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_config.dart';
import 'location_page.dart'; // Assure-toi que cette page existe

class Dashboard extends StatefulWidget {
  final Map<String, dynamic> entreprise;

  Dashboard({required this.entreprise});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late TextEditingController nomController;
  late TextEditingController emailController;
  late TextEditingController motDePasseController;
  late TextEditingController descriptionController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController numeroWhatsAppController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    nomController = TextEditingController(text: widget.entreprise['nom']);
    emailController = TextEditingController(text: widget.entreprise['email']);
    motDePasseController = TextEditingController(text: widget.entreprise['motDePasse']);
    descriptionController = TextEditingController(text: widget.entreprise['description']);
    latitudeController = TextEditingController(text: widget.entreprise['latitude'].toString());
    longitudeController = TextEditingController(text: widget.entreprise['longitude'].toString());
    numeroWhatsAppController = TextEditingController(text: widget.entreprise['numeroWhatsApp']);
  }

  Future<void> _updateEntreprise() async {
    final url = Uri.parse('${ApiConfig.baseUrl}/entreprises/${widget.entreprise['id']}');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nom': nomController.text.trim(),
        'email': emailController.text.trim(),
        'motDePasse': motDePasseController.text.trim(),
        'description': descriptionController.text.trim(),
        'latitude': double.tryParse(latitudeController.text.trim()) ?? 0.0,
        'longitude': double.tryParse(longitudeController.text.trim()) ?? 0.0,
        'numeroWhatsApp': numeroWhatsAppController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Informations mises à jour avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la mise à jour')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false, TextInputType keyboardType = TextInputType.text, Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard - ${widget.entreprise['nom']}'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField("Nom de l'entreprise", nomController),
            _buildTextField("Email", emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField(
              "Mot de passe",
              motDePasseController,
              obscure: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            _buildTextField("Description", descriptionController),
            _buildTextField("Latitude", latitudeController, keyboardType: TextInputType.number),
            _buildTextField("Longitude", longitudeController, keyboardType: TextInputType.number),
            _buildTextField("Numéro WhatsApp", numeroWhatsAppController, keyboardType: TextInputType.phone),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEntreprise,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text('Mettre à jour', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 15),
            OutlinedButton.icon(
              onPressed: () {
                final lat = double.tryParse(latitudeController.text.trim()) ?? 0.0;
                final lng = double.tryParse(longitudeController.text.trim()) ?? 0.0;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPage(),
                  ),
                );
              },
              icon: Icon(Icons.map),
              label: Text("Voir sur la carte"),
            ),
          ],
        ),
      ),
    );
  }
}
