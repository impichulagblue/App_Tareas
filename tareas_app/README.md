La carpeta flutter_app en Android Studio.

Estructura del Frontend (App en Flutter)
La aplicación móvil sigue una arquitectura limpia, separando la interfaz visual de la lógica de negocio.

📂 models/ (Modelado de Datos): Define cómo son los objetos dentro de la app.
📄 task_model.dart: Es el plano o "molde" de una Tarea. Contiene la lógica para convertir los datos JSON 
que vienen del backend en objetos Dart que Flutter puede entender y usar.

📂 services/ (Capa de Comunicación/Lógica): Aquí ocurre la magia de la conexión a internet. Ninguna pantalla 
hace peticiones directas; todas usan estos servicios.
📄 auth_service.dart: Se comunica con routes/auth.js. Maneja el Login, Registro y guarda el Token en la 
memoria del celular (SharedPreferences).
📄 task_service.dart: Se comunica con routes/tasks.js. Envía y recibe las tareas, encargándose de adjuntar el 
Token de seguridad en cada petición.
📄 weather_service.dart: Se conecta a la API externa (Open-Meteo) para descargar la información del clima.

📂 screens/ (Capa de Interfaz de Usuario - UI): Contiene todas las pantallas visuales con las que interactúa el usuario.
📄 login_screen.dart y register_screen.dart: Pantallas de autenticación con validación de formularios y diseño moderno.
📄 dashboard_screen.dart: La pantalla principal. Contiene la navegación, la lista de tareas, la visualización del clima 
y el perfil del usuario.
📄 task_form_screen.dart: Formulario reutilizable que sirve tanto para crear una tarea nueva como para editar una existente.

📄 main.dart: Es la raíz de la aplicación. Configura el tema visual (colores, fuentes) y decide qué pantalla mostrar al iniciar.

📂 lib/
├── 📂 models/
│   └── 📄 task_model.dart       # Clase 'Task'. Define la estructura de datos de una tarea y su conversión a JSON.
│
├── 📂 screens/
│   ├── 📄 login_screen.dart     # Pantalla de inicio de sesión con validación de formularios.
│   ├── 📄 register_screen.dart  # Pantalla de registro de nuevos usuarios.
│   ├── 📄 dashboard_screen.dart # Pantalla principal. Contiene la lista de tareas, el clima y el perfil.
│   └── 📄 task_form_screen.dart # Formulario reutilizable para Crear y Editar tareas.
│
├── 📂 services/
│   ├── 📄 auth_service.dart     # Gestiona la comunicación con el Backend para Login/Registro y persistencia de Token.
│   ├── 📄 task_service.dart     # Realiza las peticiones HTTP (GET, POST, PUT, DELETE) para gestionar tareas.
│   └── 📄 weather_service.dart  # Conecta con la API externa (Open-Meteo) para obtener datos del clima.
│
└── 📄 main.dart                 # Punto de entrada de la aplicación. Configura temas y rutas iniciales.

