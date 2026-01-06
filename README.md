# App_Tareas
📱 Aplicacion de tareas - Gestor de Tareas Full Stack
3er Departamental - 2a Oportunidad
Desarrollo de Aplicaciones Móviles

🎯 Objetivo del Proyecto
Desarrollar una aplicación móvil Full Stack que demuestre competencia en:

-Desarrollo móvil con Flutter y arquitectura limpia
-Backend propio con Node.js y Express
-Consumo de APIs tanto propias como externas
-Gestión de estado y persistencia local
-Seguridad con autenticación JWT y validaciones
-Documentación profesional y reproducible

Estructura de Carpetas
📦 2a Oportunidad 3er Departamental
│
├── 📂 backend/                         # API REST con Node.js
│   ├── 📁 controllers/                 # Controladores de lógica
│   │   ├── authController.js          # Registro, Login, Perfil
│   │   └── taskController.js          # CRUD de tareas
│   │
│   ├── 📁 middleware/                  # Middlewares de seguridad
│   │   ├── authMiddleware.js          # Verificación JWT
│   │   └── validationMiddleware.js    # Validación de datos
│   │
│   ├── 📁 models/                      # Modelos de datos
│   │   ├── User.js                    # Esquema Usuario
│   │   └── Task.js                    # Esquema Tarea
│   │
│   ├── 📁 routes/                      # Definición de rutas
│   │   ├── authRoutes.js              # Rutas de autenticación
│   │   └── taskRoutes.js              # Rutas de tareas
│   │
│   ├── 📁 config/                      # Configuración
│   │   ├── database.js                # Conexión SQLite
│   │   └── jwtConfig.js               # Configuración JWT
│   │
│   ├── 📄 server.js                    # Punto de entrada
│   ├── 📄 database.db                  # Base de datos SQLite
│   ├── 📄 package.json                 # Dependencias
│   └── 📄 .env.example                 # Variables de entorno
│
└── 📂 flutter_app/                    # Aplicación móvil Flutter
    ├── 📁 lib/
    │   ├── 📁 screens/                 # Pantallas
    │   │   ├── auth/                  # Login y Registro
    │   │   ├── tasks/                 # CRUD de tareas
    │   │   ├── weather/               # Clima (API externa)
    │   │   └── profile/               # Perfil de usuario
    │   │
    │   ├── 📁 services/                # Servicios API
    │   │   ├── api_service.dart       # Cliente HTTP base
    │   │   ├── auth_service.dart      # Autenticación
    │   │   ├── task_service.dart      # Gestión de tareas
    │   │   └── weather_service.dart   # API Open-Meteo
    │   │
    │   ├── 📁 models/                  # Modelos Dart
    │   │   ├── user_model.dart        # Modelo Usuario
    │   │   ├── task_model.dart        # Modelo Tarea
    │   │   └── weather_model.dart     # Modelo Clima
    │   │
    │   ├── 📁 providers/               # Gestión de estado
    │   │   ├── auth_provider.dart     # Estado de autenticación
    │   │   ├── task_provider.dart     # Estado de tareas
    │   │   └── theme_provider.dart    # Tema claro/oscuro
    │   │
    │   ├── 📁 utils/                   # Utilidades
    │   │   ├── constants.dart         # Constantes globales
    │   │   ├── validators.dart        # Validación formularios
    │   │   └── helpers.dart           # Funciones auxiliares
    │   │
    │   └── 📄 main.dart                # Punto de entrada
    │
    ├── 📁 assets/                      # Recursos estáticos
    ├── 📁 test/                        # Pruebas unitarias
    ├── 📄 pubspec.yaml                 # Dependencias Flutter
    └── 📄 README_FLUTTER.md            # Documentación Flutter

    ⚙️ Stack Tecnológico
Frontend (Flutter)
Componente	Tecnología	Versión	Propósito
Framework	Flutter	3.19+	Desarrollo móvil multiplataforma
Lenguaje	Dart	3.3+	Programación de la aplicación
HTTP Client	http	^1.1.0	Consumo de APIs REST
Persistencia	shared_preferences	^2.2.2	Almacenamiento local
Gestión Estado	provider	^6.1.1	State Management
Formularios	flutter_form_builder	^8.4.0	Validación y manejo
Navegación	go_router	^12.0.0	Navegación declarativa

Backend (Node.js)
Componente	Tecnología	Versión	Propósito
Runtime	Node.js	18+	Ejecución del servidor
Framework	Express	^4.18.2	Servidor web y rutas
Base de Datos	SQLite3	^5.1.6	Almacenamiento persistente
Autenticación	jsonwebtoken	^9.0.2	Tokens JWT
Seguridad	bcryptjs	^2.4.3	Hash de contraseñas
Validación	express-validator	^7.0.1	Validación de datos
CORS	cors	^2.8.5	Seguridad entre dominios

**API Externa
Servicio	URL	Uso en el Proyecto
Open-Meteo	https://open-meteo.com	Clima por ciudad en tiempo real

