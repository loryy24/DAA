import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'api_config.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('${ApiConfig.baseUrl}/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text.trim(),
        'motDePasse': motDePasseController.text.trim(),
      }),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['nom'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenue ${data['nom']}')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(entreprise: data)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réponse inattendue du serveur.')),
        );
      }
    } else {
      final body = json.decode(response.body);
      final message = body['message'] ?? 'Échec de la connexion.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
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
                    'assets/logo.png', width: 150, height: 150
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email de l'entreprise",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: motDePasseController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Mot de passe",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Color(0xFFFFFFFF),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Mot de passe invalide';
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
                      _login();
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
                      : Text('Se connecter', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/oublier');
                    },
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(color: Colors.purple),
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
