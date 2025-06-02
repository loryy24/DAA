import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../modules/acceuil.dart';
import '../modules/connexion.dart';
import '../modules/oublier.dart';
import '../services/api_service.dart';

class Inscription extends StatefulWidget {
  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController pseudoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();
  final TextEditingController confirmationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();

  Future<void> _ajouterLocalisation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Service de localisation désactivé')));
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission refusée')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Permission refusée de façon permanente')));
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Localisation ajoutée avec succès')));
  }

  void _nextPage() {
    if (_pageIndex < 2) {
      setState(() => _pageIndex++);
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _previousPage() {
    if (_pageIndex > 0) {
      setState(() => _pageIndex--);
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1F8),
      appBar: AppBar(
        backgroundColor: Color(0xFFF4F1F8),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset('assets/logo.png', width: 150, height: 150),
                  SizedBox(height: 10),
                  Text('Inscrivez-vous !',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF7B1FA2))),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: pseudoController,
                            decoration: _inputDecoration("Nom de l'entreprise", Icons.business),
                            validator: (value) => value == null || value.isEmpty ? "Entrez le nom" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: emailController,
                            decoration: _inputDecoration("Adresse mail", Icons.email),
                            validator: (value) => value == null || !value.contains('@') ? "Email invalide" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: whatsappController,
                            keyboardType: TextInputType.phone,
                            decoration: _inputDecoration("Numéro WhatsApp", Icons.phone),
                            validator: (value) => value == null || value.length < 8 ? "Numéro invalide" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: motDePasseController,
                            obscureText: true,
                            decoration: _inputDecoration("Mot de passe", Icons.lock),
                            validator: (value) => value == null || value.length < 6 ? "Mot de passe trop court" : null,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          TextFormField(
                            controller: confirmationController,
                            obscureText: true,
                            decoration: _inputDecoration("Confirmez le mot de passe", Icons.lock_outline),
                            validator: (value) => value != motDePasseController.text ? "Les mots de passe ne correspondent pas" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: descriptionController,
                            decoration: _inputDecoration("Description de l'entreprise", Icons.description),
                            validator: (value) => value == null || value.isEmpty ? "Entrez une description" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: latitudeController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration("Latitude", Icons.my_location),
                            validator: (value) => value == null || value.isEmpty ? "Entrez la latitude" : null,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: longitudeController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration("Longitude", Icons.my_location_outlined),
                            validator: (value) => value == null || value.isEmpty ? "Entrez la longitude" : null,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _ajouterLocalisation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF7B1FA2),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text("Ajouter ma localisation"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("S'enregistrer"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9C27B0),
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  double? lat = double.tryParse(latitudeController.text);
                                  double? long = double.tryParse(longitudeController.text);

                                  if (lat == null || long == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Coordonnées invalides')),
                                    );
                                    return;
                                  }

                                  final entreprise = {
                                    'nom': pseudoController.text,
                                    'email': emailController.text,
                                    'numeroWhatsApp': whatsappController.text,
                                    'motDePasse': motDePasseController.text,
                                    'description': descriptionController.text,
                                    'latitude': lat,
                                    'longitude': long,
                                  };

                                  bool success = await ApiService().inscrireEntreprise(entreprise);

                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Entreprise enregistrée avec succès')),
                                    );
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Accueil()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Échec de l'enregistrement")),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 25),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Connexion())),
                            child: Text("Se connecter", style: TextStyle(color: Color(0xFF7B1FA2))),
                          ),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OublierMotDePasse())),
                            child: Text("Mot de passe oublié ?", style: TextStyle(color: Colors.purple[200])),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (_pageIndex > 0)
                    ElevatedButton(
                      onPressed: _previousPage,
                      child: Text("Précédent"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  SizedBox(width: 10),
                  if (_pageIndex < 2)
                    ElevatedButton(
                      onPressed: _nextPage,
                      child: Text("Suivant"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
