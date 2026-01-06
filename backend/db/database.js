const sqlite3 = require('sqlite3').verbose();
const path = require('path');

const dbPath = path.resolve(__dirname, 'tareas.db');
const db = new sqlite3.Database(dbPath, (err) => {
    if (err) console.error('❌ Error BD:', err.message);
    else console.log('✅ Base de datos lista');
});

db.serialize(() => {
    // 1. Tabla USUARIOS (¡Ahora con color!)
    db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        color INTEGER DEFAULT 4283105504 
    )`); // Ese número es el código del color morado

    // 2. Tabla TAREAS
    db.run(`CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        priority TEXT,
        status TEXT DEFAULT 'Pendiente',
        deadline TEXT,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        user_id INTEGER,
        FOREIGN KEY(user_id) REFERENCES users(id)
    )`);
});

module.exports = db;
