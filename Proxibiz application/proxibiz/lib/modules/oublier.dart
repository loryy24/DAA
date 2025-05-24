import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class OublierMotDePasse extends StatefulWidget {
  @override
  _OublierMotDePasseState createState() => _OublierMotDePasseState();
}

class _OublierMotDePasseState extends State<OublierMotDePasse> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nouveauMdpController = TextEditingController();
  final TextEditingController confirmationMdpController = TextEditingController();

  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() => _isLoading = true);

   final url = Uri.parse('${ApiConfig.baseUrl}/entreprises/resset-passeword');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text.trim(),
        'nouveauMotDePasse': nouveauMdpController.text.trim(),
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mot de passe mis à jour avec succès')),
      );
      Navigator.pop(context); // retourne à la page précédente
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${json.decode(response.body)['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        title: Text("Mot de passe oublié"),
        backgroundColor: Colors.purple,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 30),
                Text(
                  "Réinitialisation du mot de passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Adresse mail",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return "Entrez une adresse mail valide";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                TextFormField(
                  controller: nouveauMdpController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Nouveau mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Mot de passe trop court";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),

                TextFormField(
                  controller: confirmationMdpController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirmez le mot de passe",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value != nouveauMdpController.text) {
                      return "Les mots de passe ne correspondent pas";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _resetPassword();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Réinitialiser", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
