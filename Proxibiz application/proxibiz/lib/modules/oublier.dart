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
      Navigator.pop(context); // Retour à la page précédente
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${json.decode(response.body)['message']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                      width: 150, height: 150
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Réinitialisation du mot de passe",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Adresse mail",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
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
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
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
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
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
                    backgroundColor: Color(0xFF8943D5),
                    foregroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
