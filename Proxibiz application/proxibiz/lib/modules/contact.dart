import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  final dynamic entreprise;

  const ContactPage({super.key, required this.entreprise});

  Future<void> _launchPhone(BuildContext context, String numero) async {
    try {
      if (numero.isEmpty) throw 'Numéro vide';
      final Uri url = Uri(scheme: 'tel', path: numero);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Impossible de lancer $url';
      }
    } catch (e) {
      _showError(context, 'Erreur lors de l\'appel : $e');
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String numero) async {
    try {
      if (numero.isEmpty) throw 'Numéro vide';
      final Uri url = Uri.parse("https://wa.me/$numero");
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Impossible de lancer WhatsApp';
      }
    } catch (e) {
      _showError(context, 'Erreur WhatsApp : $e');
    }
  }

  Future<void> _launchEmail(BuildContext context, String email) async {
    try {
      if (email.isEmpty) throw 'Email vide';
      final Uri url = Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=Contact depuis Proxibiz',
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Impossible d’envoyer un e-mail à $email';
      }
    } catch (e) {
      _showError(context, 'Erreur email : $e');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nom = entreprise.nom ?? "Entreprise";
    final description = entreprise.description ?? "";
    final numero = entreprise.numeroWhatsApp ?? "";
    final email = entreprise.email ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Contact - $nom"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nom,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
            const Divider(height: 30),
            if (numero.isNotEmpty)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: const Text("Appeler / WhatsApp"),
                  subtitle: Text(numero),
                  onTap: () => _launchPhone(context, numero),
                  trailing: IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () => _launchWhatsApp(context, numero),
                  ),
                ),
              ),
            if (email.isNotEmpty)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.email, color: Colors.red),
                  title: const Text("Envoyer un e-mail"),
                  subtitle: Text(email),
                  onTap: () => _launchEmail(context, email),
                ),
              ),
            if (numero.isEmpty && email.isEmpty)
              const Center(child: Text("Aucun contact disponible.")),
          ],
        ),
      ),
    );
  }
}
