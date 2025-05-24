const express = require('express');
const sqlite3 = require('sqlite3').verbose();
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const db = new sqlite3.Database('./proxibiz.db');

// 🔓 Autoriser les requêtes CORS (y compris options plus complètes si besoin)
app.use(cors({
  origin: '*', // autorise tous les domaines — à restreindre en prod
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));

app.use(bodyParser.json());

// Créer la table si elle n'existe pas (ajout de numéroWhatsApp)
db.run(`CREATE TABLE IF NOT EXISTS entreprises (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nom TEXT,
  email TEXT,
  motDePasse TEXT,
  description TEXT,
  latitude REAL,
  longitude REAL,
  numeroWhatsApp TEXT
)`);

// Ajouter une entreprise (avec numéroWhatsApp)
app.post('/entreprises', (req, res) => {
  const { nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp } = req.body;
  db.run(
    `INSERT INTO entreprises (nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp)
     VALUES (?, ?, ?, ?, ?, ?, ?)`,
    [nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp],
    function (err) {
      if (err) {
        return res.status(500).json({ error: err.message });
      }
      res.status(201).json({ id: this.lastID });
    }
  );
});

// Récupérer toutes les entreprises (avec numéroWhatsApp)
app.get('/entreprises', (req, res) => {
  db.all(`SELECT * FROM entreprises`, [], (err, rows) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(rows);
  });
});

// Connexion
app.post('/login', (req, res) => {
  const { email, motDePasse } = req.body;
  db.get(
    `SELECT * FROM entreprises WHERE email = ? AND motDePasse = ?`,
    [email, motDePasse],
    (err, row) => {
      if (err) return res.status(500).json({ error: err.message });
      if (!row) return res.status(401).json({ message: "Identifiants invalides" });
      res.json(row);
    }
  );
});

app.put('/entreprises/:id', (req, res) => {
  const { id } = req.params;
  const { nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp } = req.body;
  db.run(
    `UPDATE entreprises SET nom = ?, email = ?, motDePasse = ?, description = ?, latitude = ?, longitude = ?, numeroWhatsApp = ? WHERE id = ?`,
    [nom, email, motDePasse, description, latitude, longitude, numeroWhatsApp, id],
    function (err) {
      if (err) return res.status(500).json({ error: err.message });
      res.json({ message: 'Entreprise mise à jour' });
    }
  );
});


// 🌐 Écoute sur toutes les interfaces réseau
const PORT = 3000;
app.listen(PORT, () => console.log(`API en cours sur http://0.0.0.0:${PORT}`));
