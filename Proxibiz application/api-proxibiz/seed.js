const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./proxibiz.db');

const entreprises = [
  {
    nom: "MTN Bénin",
    description: "Opérateur de télécommunications offrant des services mobiles, internet et financiers.",
    latitude: 6.3625,
    longitude: 2.4396,
    numeroWhatsApp: "+22912345678" // Ajout du numéro WhatsApp
  },
  {
    nom: "Moov Africa Bénin",
    description: "Opérateur de télécommunications proposant des offres mobiles, internet et fibre optique.",
    latitude: 6.3675,
    longitude: 2.4255,
    numeroWhatsApp: "+22923456789" // Ajout du numéro WhatsApp
  },
  {
    nom: "SOBEBRA",
    description: "Société béninoise de brasserie produisant des boissons alcoolisées et non alcoolisées.",
    latitude: 6.3573,
    longitude: 2.3998,
    numeroWhatsApp: "+22934567890" // Ajout du numéro WhatsApp
  },
  {
    nom: "Supermarché Erevan",
    description: "Grande surface proposant divers produits alimentaires et électroménagers.",
    latitude: 6.3687,
    longitude: 2.4154,
    numeroWhatsApp: "+22945678901" // Ajout du numéro WhatsApp
  },
  {
    nom: "ORABANK Bénin",
    description: "Banque offrant des services financiers aux particuliers et aux entreprises.",
    latitude: 6.3499,
    longitude: 2.4287,
    numeroWhatsApp: "+22956789012" // Ajout du numéro WhatsApp
  },
  {
    nom: "JNP Technologies",
    description: "Entreprise spécialisée dans le développement logiciel et la cybersécurité.",
    latitude: 6.3652,
    longitude: 2.4431,
    numeroWhatsApp: "+22967890123" // Ajout du numéro WhatsApp
  },
  {
    nom: "Cotonou Mall",
    description: "Centre commercial moderne avec divers magasins et restaurants.",
    latitude: 6.3640,
    longitude: 2.4262,
    numeroWhatsApp: "+22978901234" // Ajout du numéro WhatsApp
  },
  {
    nom: "Canal+ Bénin",
    description: "Entreprise spécialisée dans la télévision par abonnement et la distribution de contenus audiovisuels.",
    latitude: 6.3564,
    longitude: 2.4183,
    numeroWhatsApp: "+22989012345" // Ajout du numéro WhatsApp
  },
  {
    nom: "Ecobank Bénin",
    description: "Banque panafricaine offrant des services financiers aux entreprises et aux particuliers.",
    latitude: 6.3482,
    longitude: 2.4305,
    numeroWhatsApp: "+22990123456" // Ajout du numéro WhatsApp
  },
  {
    nom: "Golden Tulip Le Diplomate",
    description: "Hôtel 4 étoiles proposant des services d'hébergement et de restauration de luxe.",
    latitude: 6.3659,
    longitude: 2.4187,
    numeroWhatsApp: "+22901234567" // Ajout du numéro WhatsApp
  },
];

// ⚠️ Données par défaut pour tous les emails et mots de passe
const defaultEmail = "contact@entreprise.bj";
const defaultPassword = "123456";

entreprises.forEach((e) => {
  db.run(
    `INSERT INTO entreprises (nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [
      e.nom,
      `${e.nom.toLowerCase().replace(/ /g, '')}@entreprise.bj`, // email généré automatiquement
      defaultPassword,
      e.description,
      e.latitude,
      e.longitude,
      e.numeroWhatsApp, // ajout du numéro WhatsApp
    ],
    function (err) {
      if (err) {
        console.error("❌ Erreur insertion :", err.message);
      } else {
        console.log(`✅ Entreprise insérée avec l'ID ${this.lastID}`);
      }
    }
  );
});

db.close(() => console.log("✔️ Insertion terminée et base fermée"));
