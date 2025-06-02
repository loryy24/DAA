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
      backgroundColor: Color(0xFFF4F1F8),
      appBar: AppBar(
        title: Text("Contact - $nom"),
        backgroundColor: Colors.purple,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nom,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple[900]),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.grey[800]),
            ),
            const SizedBox(height: 24),
            if (numero.isNotEmpty)
              _buildContactCard(
                context,
                icon: Icons.phone,
                iconColor: Colors.green,
                title: "Appeler",
                subtitle: numero,
                onTap: () => _launchPhone(context, numero),
              ),
            if (numero.isNotEmpty)
              _buildContactCard(
                context,
                icon: Icons.chat,
                iconColor: Colors.teal,
                title: "Envoyer un message WhatsApp",
                subtitle: numero,
                onTap: () => _launchWhatsApp(context, numero),
              ),
            if (email.isNotEmpty)
              _buildContactCard(
                context,
                icon: Icons.email,
                iconColor: Colors.redAccent,
                title: "Envoyer un e-mail",
                subtitle: email,
                onTap: () => _launchEmail(context, email),
              ),
            if (numero.isEmpty && email.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text("Aucun contact disponible.", style: TextStyle(color: Colors.grey)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context,
      {required IconData icon,
        required Color iconColor,
        required String title,
        required String subtitle,
        required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 30),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}
