import 'package:flutter/material.dart';

class Task {
  int? id;
  String title;
  String description;
  String priority; // 'Alta', 'Media', 'Baja'
  String status;   // 'Pendiente', 'En progreso', 'Hecha'
  DateTime? createdAt; // Puede ser nulo a veces
  String deadline;     // Lo dejaremos como String para facilitar el manejo

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.createdAt,
    required this.deadline,
  });

  // 👇 AQUÍ ESTÁ LA MAGIA (Adaptado a tu Backend)
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '', // Evita choque si viene vacío
      priority: json['priority'] ?? 'Media',
      status: json['status'] ?? 'Pendiente',
      // El backend manda 'created_at', aquí lo convertimos
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : DateTime.now(),
      deadline: json['deadline'] ?? '',
    );
  }

  // Método para convertir a JSON (para cuando enviamos datos)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'deadline': deadline,
    };
  }

  // --- TUS MÉTODOS VISUALES (¡Están geniales!) ---

  Color getPriorityColor() {
    switch (priority) {
      case 'Alta':   // Ajusté a Mayúscula porque así lo mandamos
        return Colors.red;
      case 'Media':
        return Colors.orange;
      case 'Baja':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case 'Pendiente':
        return Icons.access_time;
      case 'En progreso':
        return Icons.autorenew;
      case 'Hecha':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}
