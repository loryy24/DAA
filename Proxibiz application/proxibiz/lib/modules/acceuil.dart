import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'login.dart'; // Assure-toi que ce fichier est bien importé

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<dynamic> entreprises = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchEntreprises();
  }

  Future<void> fetchEntreprises() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/entreprises'));

      if (response.statusCode == 200) {
        setState(() {
          entreprises = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Erreur (${response.statusCode}) lors de la récupération.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur : ${e.toString()}';
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage!)),
          );
        }
      });
    }
  }

  Widget buildEntrepriseCard(Map<String, dynamic> e) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.business, color: Colors.purple[700], size: 40),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e['nom'] ?? 'Nom inconnu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple[800]),
                  ),
                  SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 5),
                    Expanded(child: Text(e['email'] ?? '-', style: TextStyle(color: Colors.grey[800]))),
                  ]),
                  Row(children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 5),
                    Text(e['numeroWhatsApp'] ?? '-', style: TextStyle(color: Colors.grey[800])),
                  ]),
                  SizedBox(height: 6),
                  Text(
                    e['description'] ?? '-',
                    style: TextStyle(color: Colors.black87),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.location_pin, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 5),
                      Text(
                        "(${e['latitude'] ?? '-'}, ${e['longitude'] ?? '-'})",
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1F8),
      appBar: AppBar(
        title: Text('Entreprises'),
        backgroundColor: Color(0xFF7B1FA2),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              fetchEntreprises();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.purple))
          : entreprises.isEmpty
          ? Center(child: Text("Aucune entreprise enregistrée", style: TextStyle(color: Colors.grey[700])))
          : ListView.builder(
        itemCount: entreprises.length,
        itemBuilder: (context, index) => buildEntrepriseCard(entreprises[index]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF9C27B0),
        icon: Icon(Icons.add),
        label: Text("Ajouter"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Inscription()),
          );
        },
      ),
    );
  }
}
