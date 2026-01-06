import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../services/weather_service.dart';
import '../models/task_model.dart';
import 'login_screen.dart';
import 'task_form_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // DATOS
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoadingTasks = true;
  final TextEditingController _taskSearchController = TextEditingController();

  Map<String, dynamic> _weatherData = {'temp': '--', 'city': 'Cargando...', 'valid': false};
  String _searchCity = 'Ciudad de México';
  bool _isLoadingWeather = true;
  final TextEditingController _weatherSearchController = TextEditingController();

  // PERFIL Y CONFIGURACIÓN
  String _userName = 'Cargando...';
  int _avatarColor = 0xFF4A00E0;
  bool _isDarkMode = false; // 🌑 Variable para el modo oscuro

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Aquí cargamos también el modo oscuro guardado
    _loadTasks();
    _loadWeather();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'Usuario';
      _avatarColor = prefs.getInt('avatarColor') ?? 0xFF4A00E0;
      // 👇 RECUPERAMOS SI DEJASTE EL MODO OSCURO PRENDIDO
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Guardar la preferencia de modo oscuro
  void _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  void _loadTasks() async {
    setState(() => _isLoadingTasks = true);
    _allTasks.clear(); _filteredTasks.clear();
    final tasks = await TaskService.getTasks();
    if (mounted) setState(() { _allTasks = tasks; _filteredTasks = tasks; _isLoadingTasks = false; });
  }

  void _loadWeather() async {
    setState(() => _isLoadingWeather = true);
    final data = await WeatherService.getWeather(_searchCity);
    if (mounted) setState(() { _weatherData = data['valid'] == true ? data : {'city': 'No encontrada', 'valid': false}; _isLoadingWeather = false; });
  }

  void _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    int tempColor = _avatarColor;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white, // Adaptable
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Editar Perfil', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 40, backgroundColor: Color(tempColor), child: Text(nameController.text.isNotEmpty ? nameController.text[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 30, color: Colors.white))),
                const SizedBox(height: 20),
                TextField(
                    controller: nameController,
                    style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: _isDarkMode ? Colors.grey : Colors.black54),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _isDarkMode ? Colors.grey : Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue)),
                    ),
                    onChanged: (val) => setDialogState(() {})
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  _colorOption(0xFFE53935, tempColor, (c) => setDialogState(() => tempColor = c)),
                  _colorOption(0xFF4A00E0, tempColor, (c) => setDialogState(() => tempColor = c)),
                  _colorOption(0xFF43A047, tempColor, (c) => setDialogState(() => tempColor = c)),
                  _colorOption(0xFFFB8C00, tempColor, (c) => setDialogState(() => tempColor = c)),
                  _colorOption(0xFF00ACC1, tempColor, (c) => setDialogState(() => tempColor = c)),
                ]),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(tempColor), foregroundColor: Colors.white),
                onPressed: () async {
                  await AuthService.updateProfile(nameController.text, tempColor);
                  setState(() { _userName = nameController.text; _avatarColor = tempColor; });
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        });
      },
    );
  }

  Widget _colorOption(int color, int selected, Function(int) onTap) {
    return GestureDetector(
      onTap: () => onTap(color),
      child: Container(width: 35, height: 35, decoration: BoxDecoration(color: Color(color), shape: BoxShape.circle, border: color == selected ? Border.all(color: _isDarkMode ? Colors.white : Colors.black, width: 2) : null)),
    );
  }

  // --- VISTAS ---

  // 1. TAREAS (Adaptado a Modo Oscuro)
  Widget _buildTasksTab() {
    return Column(children: [
      Container(
        padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: _isDarkMode ? [Colors.black, Colors.grey.shade900] : [Color(_avatarColor), Color(_avatarColor).withOpacity(0.7)]),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30))
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Hola,", style: TextStyle(color: Colors.white70, fontSize: 18)), Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold))]),
            GestureDetector(onTap: () => setState(() => _currentIndex = 2), child: CircleAvatar(radius: 25, backgroundColor: Colors.white24, child: Text(_userName.isNotEmpty ? _userName[0] : "U", style: const TextStyle(color: Colors.white))))
          ]),
          const SizedBox(height: 20),
          TextField(
              controller: _taskSearchController,
              style: const TextStyle(color: Colors.black87), // Texto negro siempre en el buscador blanco
              decoration: InputDecoration(hintText: 'Buscar...', prefixIcon: const Icon(Icons.search, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
              onChanged: (val) => setState(() => _filteredTasks = val.isEmpty ? _allTasks : _allTasks.where((t) => t.title.toLowerCase().contains(val.toLowerCase())).toList())
          )
        ]),
      ),
      Expanded(
          child: _isLoadingTasks
              ? const Center(child: CircularProgressIndicator())
              : _filteredTasks.isEmpty
              ? Center(child: Text("Sin tareas", style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54)))
              : ListView.builder(
              padding: const EdgeInsets.all(20), itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                final task = _filteredTasks[index];
                return Card(
                    color: _isDarkMode ? Colors.grey[850] : Colors.white, // 🌑 Color de tarjeta
                    elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => TaskFormScreen(task: task))).then((_) => _loadTasks()),
                      leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: task.getPriorityColor().withOpacity(0.1), shape: BoxShape.circle), child: Icon(task.getStatusIcon(), color: task.getPriorityColor())),
                      title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black)), // 🌑 Texto
                      subtitle: Text(task.deadline, style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.grey)),
                      trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () async { await TaskService.deleteTask(task.id!); _loadTasks(); }),
                    ));
              })
      )
    ]);
  }

  // 2. CLIMA
  Widget _buildWeatherTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25.0),
      child: Column(children: [
        const SizedBox(height: 20),
        TextField(
            controller: _weatherSearchController,
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'Buscar Ciudad',
              labelStyle: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.grey),
              suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: () { setState(() { _searchCity = _weatherSearchController.text; _loadWeather(); }); }),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: _isDarkMode ? Colors.grey : Colors.black54)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.blue)),
            )
        ),
        const SizedBox(height: 30),
        if (_isLoadingWeather) const CircularProgressIndicator()
        else if (_weatherData['valid'] == false) Text("Ciudad no encontrada 😢", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black))
        else Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)]), borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
            child: Column(children: [
              Text(_weatherData['city'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Icon(Icons.cloud, color: Colors.white, size: 80),
              Text(_weatherData['temp'], style: const TextStyle(color: Colors.white, fontSize: 55, fontWeight: FontWeight.bold)),
              const Text("Temperatura Actual", style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 25), const Divider(color: Colors.white24), const SizedBox(height: 15),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _weatherDetail(Icons.water_drop, "Humedad", _weatherData['humidity'] ?? '--%'),
                _weatherDetail(Icons.air, "Viento", _weatherData['wind'] ?? '-- km/h'),
                _weatherDetail(Icons.thermostat, "Sensación", _weatherData['feels_like'] ?? '--°'),
              ])
            ]),
          )
      ]),
    );
  }

  Widget _weatherDetail(IconData icon, String label, String value) {
    return Column(children: [Icon(icon, color: Colors.white70), const SizedBox(height: 5), Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12))]);
  }

  // 3. PERFIL (¡CON EL SWITCH DE MODO OSCURO!)
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          CircleAvatar(radius: 60, backgroundColor: Color(_avatarColor), child: Text(_userName.isNotEmpty ? _userName[0].toUpperCase() : "U", style: const TextStyle(fontSize: 50, color: Colors.white))),
          const SizedBox(height: 20),
          Text(_userName, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: _isDarkMode ? Colors.white : Colors.black)),
          Text("Desarrolladora Flutter", style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.grey)),
          const SizedBox(height: 40),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[850] : Colors.white, // 🌑 Fondo de tarjeta
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: Text("Editar Perfil", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: _showEditProfileDialog,
                ),
                Divider(height: 1, color: _isDarkMode ? Colors.grey[700] : Colors.grey[300]),

                // 👇 AQUÍ ESTÁ EL SWITCH MÁGICO
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode, color: _isDarkMode ? Colors.purpleAccent : Colors.grey),
                  title: Text("Modo Oscuro", style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black)),
                  value: _isDarkMode,
                  activeColor: Colors.purpleAccent,
                  onChanged: _toggleDarkMode, // Llama a la función que guarda la preferencia
                ),

                Divider(height: 1, color: _isDarkMode ? Colors.grey[700] : Colors.grey[300]),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5), // 🌑 Fondo de la pantalla
      body: SafeArea(child: IndexedStack(index: _currentIndex, children: [_buildTasksTab(), _buildWeatherTab(), _buildProfileTab()])),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TaskFormScreen())).then((_) => _loadTasks()), backgroundColor: Color(_avatarColor), child: const Icon(Icons.add, color: Colors.white)) : null,
      bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex, onDestinationSelected: (i) => setState(() => _currentIndex = i),
          backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white, // 🌑 Barra de abajo
          indicatorColor: _isDarkMode ? Colors.purpleAccent.withOpacity(0.2) : null,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.list), label: 'Tareas'),
            NavigationDestination(icon: Icon(Icons.cloud), label: 'Clima'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Perfil')
          ]
      ),
    );
  }
}
