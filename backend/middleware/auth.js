const jwt = require('jsonwebtoken');
const SECRET_KEY = 'super_secreto_123'; // 🔐 CLAVE MAESTRA

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Acceso denegado (No hay token)' });
    }

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) {
            return res.status(403).json({ error: 'Token inválido' });
        }
        req.user = user; // ✅ Aquí guardamos al usuario para usarlo después
        next();
    });
};

module.exports = authenticateToken;
