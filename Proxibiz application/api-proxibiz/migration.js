// migrate.js
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./proxibiz.db');

db.run(`ALTER TABLE entreprises ADD COLUMN numeroWhatsApp TEXT`, (err) => {
  if (err) {
    console.error("Erreur lors de la modification :", err.message);
  } else {
    console.log("✅ Colonne numeroWhatsApp ajoutée avec succès !");
  }
  db.close();
});
