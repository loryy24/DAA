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
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service de localisation désactivé')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permission refusée')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission refusée de façon permanente')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitudeController.text = position.latitude.toStringAsFixed(6);
      longitudeController.text = position.longitude.toStringAsFixed(6);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Localisation ajoutée avec succès')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              SizedBox(height: 40),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Inscription Entreprise',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple[800]),
                ),
              ),
              SizedBox(height: 30),

              TextFormField(
                controller: pseudoController,
                decoration: InputDecoration(labelText: "Nom de l'entreprise"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez le nom de l'entreprise";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Adresse mail"),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return "Entrez une adresse mail valide";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: whatsappController,
                decoration: InputDecoration(labelText: "Numéro WhatsApp (ex: 22912345678)"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return "Entrez un numéro WhatsApp valide";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),


              TextFormField(
                controller: motDePasseController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Mot de passe"),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Mot de passe trop court";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: confirmationController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirmez le mot de passe"),
                validator: (value) {
                  if (value != motDePasseController.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Description de l'entreprise"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez une description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: latitudeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Latitude"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez la latitude";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              TextFormField(
                controller: longitudeController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: "Longitude"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Entrez la longitude";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: _ajouterLocalisation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: Text("Ajouter ma localisation"),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                child: Text("S'enregistrer"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (latitudeController.text.isEmpty || longitudeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Remplissez latitude et longitude')),
                      );
                      return;
                    }

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

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Accueil()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Échec de l'enregistrement")),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
                },
                child: Text("Se connecter", style: TextStyle(color: Colors.purple)),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OublierMotDePasse()));
                },
                child: Text("Mot de passe oublié ?", style: TextStyle(color: Colors.purple[200])),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
