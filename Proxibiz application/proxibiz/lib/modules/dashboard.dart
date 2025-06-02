import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'api_config.dart';
import 'location_page.dart';

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

    final message = response.statusCode == 200
        ? '✅ Informations mises à jour avec succès'
        : '❌ Échec de la mise à jour';

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false,
        TextInputType keyboardType = TextInputType.text,
        Widget? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entrepriseNom = widget.entreprise['nom'] ?? "Entreprise";

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        backgroundColor: Color(0xFF7B1FA2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    entrepriseNom,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2)),
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updateEntreprise,
                    icon: Icon(Icons.save, color: Colors.black), // Icône noire
                    label: Text(
                      'Enregistrer les modifications',
                      style: TextStyle(color: Colors.black), // Texte noir
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF7B1FA2),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.black, // Important si on veut que les effets (splash, etc.) soient cohérents
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                Center(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.map),
                    label: Text("Voir la position sur la carte"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LocationPage()),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF7B1FA2),
                      side: BorderSide(color: Color(0xFF7B1FA2)),
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
