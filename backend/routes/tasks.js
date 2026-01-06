const express = require('express');
const router = express.Router();
const db = require('../db/database');
const jwt = require('jsonwebtoken');

const SECRET_KEY = 'super_secreto_123';

// MIDDLEWARE DE SEGURIDAD (El cadenero)
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) return res.status(401).json({ error: 'Acceso denegado' });

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.status(403).json({ error: 'Token inválido' });
        req.user = user;
        next();
    });
};

// 1. OBTENER TODAS (GET /tasks)
router.get('/', authenticateToken, (req, res) => {
    const sql = 'SELECT * FROM tasks WHERE user_id = ?';
    db.all(sql, [req.user.id], (err, rows) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(rows);
    });
});

// 2. OBTENER UNA SOLA (GET /tasks/:id) -> ¡ESTE ES EL NUEVO REQUISITO! ✅
router.get('/:id', authenticateToken, (req, res) => {
    const sql = 'SELECT * FROM tasks WHERE id = ? AND user_id = ?';
    db.get(sql, [req.params.id, req.user.id], (err, row) => {
        if (err) return res.status(500).json({ error: err.message });
        if (!row) return res.status(404).json({ error: 'Tarea no encontrada' });
        res.json(row);
    });
});

// 3. CREAR (POST /tasks)
router.post('/', authenticateToken, (req, res) => {
    const { title, description, priority, deadline } = req.body;
    const sql = 'INSERT INTO tasks (title, description, priority, deadline, user_id) VALUES (?, ?, ?, ?, ?)';
    db.run(sql, [title, description, priority, deadline, req.user.id], function(err) {
        if (err) return res.status(400).json({ error: err.message });
        res.status(201).json({ id: this.lastID, message: 'Tarea creada' });
    });
});

// 4. ACTUALIZAR (PUT /tasks/:id)
router.put('/:id', authenticateToken, (req, res) => {
    const { title, description, priority, deadline } = req.body;
    const sql = 'UPDATE tasks SET title = ?, description = ?, priority = ?, deadline = ? WHERE id = ? AND user_id = ?';
    db.run(sql, [title, description, priority, deadline, req.params.id, req.user.id], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Tarea actualizada correctamente' });
    });
});

// 5. BORRAR (DELETE /tasks/:id)
router.delete('/:id', authenticateToken, (req, res) => {
    const sql = 'DELETE FROM tasks WHERE id = ? AND user_id = ?';
    db.run(sql, [req.params.id, req.user.id], function(err) {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Tarea eliminada' });
    });
});

module.exports = router;
