import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'login.dart'; // Tu avais mis login.dart par erreur ici

class Accueil extends StatefulWidget {
  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  List<dynamic> entreprises = [];
  bool isLoading = true;
  String? errorMessage; // Pour stocker une erreur

  @override
  void initState() {
    super.initState();
    fetchEntreprises();
  }

  Future<void> fetchEntreprises() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/entreprises'),
      );

      if (response.statusCode == 200) {
        setState(() {
          entreprises = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Erreur lors de la récupération des données (${response.statusCode})");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur : ${e.toString()}';
      });

      // Affiche le snackBar seulement après le build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (errorMessage != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage!)),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Entreprises'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchEntreprises(); // Recharge les données
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : entreprises.isEmpty
              ? Center(child: Text("Aucune entreprise enregistrée"))
              : ListView.builder(
                  itemCount: entreprises.length,
                  itemBuilder: (context, index) {
                    final e = entreprises[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      elevation: 3,
                      child: ListTile(
                        title: Text(e['nom'] ?? 'Nom inconnu'),
                        subtitle: Text(
                          'Email : ${e['email'] ?? '-'}\n'
                          'WhatsApp : ${e['numeroWhatsApp'] ?? '-'}\n'
                          'Description : ${e['description'] ?? '-'}\n'
                          'Latitude : ${e['latitude'] ?? '-'}, '
                          'Longitude : ${e['longitude'] ?? '-'}',
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
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
