const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const db = require('../db/database');

const SECRET_KEY = 'super_secreto_123';

// REGISTRO
router.post('/register', (req, res) => {
    const { name, email, password } = req.body;
    // Guardamos con el color morado por defecto
    const sql = 'INSERT INTO users (name, email, password, color) VALUES (?, ?, ?, 4283105504)';
    db.run(sql, [name || 'Usuario', email, password], function(err) {
        if (err) return res.status(400).json({ error: 'El correo ya existe' });
        res.status(201).json({ id: this.lastID, message: 'Creado' });
    });
});

// LOGIN
router.post('/login', (req, res) => {
    const { email, password } = req.body;
    db.get('SELECT * FROM users WHERE email = ? AND password = ?', [email, password], (err, user) => {
        if (err || !user) return res.status(401).json({ error: 'Credenciales mal' });
        
        const token = jwt.sign({ id: user.id }, SECRET_KEY);
        // Enviamos el color y el nombre al entrar
        res.json({ token, user: { name: user.name, color: user.color } });
    });
});

// ACTUALIZAR PERFIL
router.put('/update', (req, res) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.sendStatus(401);

    jwt.verify(token, SECRET_KEY, (err, userDecoded) => {
        if (err) return res.sendStatus(403);
        
        const { name, color } = req.body;
        db.run('UPDATE users SET name = ?, color = ? WHERE id = ?', [name, color, userDecoded.id], function(err) {
            if (err) return res.status(500).json({ error: err.message });
            res.json({ message: 'Perfil actualizado' });
        });
    });
});

module.exports = router;
