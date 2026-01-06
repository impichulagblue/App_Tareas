const express = require('express');
const cors = require('cors');
const app = express();

app.use(express.json());
app.use(cors());

// Importar rutas
const authRoutes = require('./routes/auth');
const taskRoutes = require('./routes/tasks');

// Usar rutas
app.use('/auth', authRoutes);
app.use('/tasks', taskRoutes);

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Servidor listo en http://localhost:${PORT}`);
    console.log(`📱 Conecta tu celular a la IP de tu PC:3000`);
});
