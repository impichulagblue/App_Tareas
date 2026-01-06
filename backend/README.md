La carpeta /backend en VS Code.

Estructura del Backend (API REST en Node.js)
En esta sección, el código está organizado por funcionalidad para facilitar el mantenimiento y la seguridad.

📂 db/ (Capa de Datos): Aquí vive la conexión directa con la base de datos.
📄 database.js: Es el archivo encargado de iniciar SQLite. Aquí se define la estructura de las tablas 
(users y tasks) y se asegura de que existan al arrancar el servidor.

📂 middleware/ (Capa de Seguridad): Contiene las funciones que se ejecutan antes de llegar a las rutas privadas.
📄 auth.js: Es nuestro "guardia de seguridad". Verifica que el Token JWT que envía la app sea válido. Si no lo 
es, bloquea el acceso; si es correcto, deja pasar la petición e identifica qué usuario es (Pedro, Milka, etc.).

📂 routes/ (Capa de Controladores/Rutas): Aquí se definen los "caminos" o URLs de nuestra API.
📄 auth.js: Maneja todo lo público: Registro (POST /register), Inicio de Sesión (POST /login) y actualización de perfil.
📄 tasks.js: Maneja el CRUD protegido. Aquí está la lógica para Crear, Leer, Actualizar y Borrar tareas, asegurándose 
siempre de filtrar por el user_id del usuario autenticado.

📄 index.js (Punto de Entrada): Es el cerebro del servidor. Configura Express, habilita CORS (para que el celular 
pueda conectarse), procesa los datos JSON entrantes y levanta el servidor en el puerto 3000.

📂 backend/
├── 📂 db/
│   └── 📄 database.js     # Configuración de SQLite. Crea las tablas 'users' y 'tasks' automáticamente.
│
├── 📂 middleware/
│   └── 📄 auth.js         # Middleware de seguridad. Verifica el Token JWT para proteger rutas privadas.
│
├── 📂 routes/
│   ├── 📄 auth.js         # Endpoints de Autenticación: Login, Registro y Actualización de Perfil.
│   └── 📄 tasks.js        # Endpoints del CRUD de Tareas (GET, POST, PUT, DELETE).
│
├── 📄 index.js            # Punto de entrada. Configura Express, CORS y levanta el servidor.
└── 📄 package.json        # Lista de dependencias (express, sqlite3, jsonwebtoken, cors, etc.).
