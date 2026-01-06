import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  String _priority = 'Media';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Si recibimos una tarea, llenamos los campos (Modo Edición)
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _priority = widget.task!.priority;
      try { _selectedDate = DateTime.parse(widget.task!.deadline); } catch (_) {}
    }
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF4A00E0))), child: child!);
        }
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      String dateToSend = _selectedDate.toIso8601String().split('T')[0];
      bool success;

      // 👇 AQUÍ ESTÁ LA INTELIGENCIA
      if (widget.task == null) {
        // Si no hay tarea previa, CREAMOS
        success = await TaskService.createTask(_titleController.text, _descController.text, _priority, dateToSend);
      } else {
        // Si YA hay tarea, ACTUALIZAMOS
        success = await TaskService.updateTask(widget.task!.id!, _titleController.text, _descController.text, _priority, dateToSend);
      }

      setState(() => _isLoading = false);

      if (success) {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(widget.task == null ? '¡Tarea creada!' : '¡Tarea actualizada!'),
          backgroundColor: Colors.green,
        ));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nueva Tarea' : 'Editar Tarea'),
        backgroundColor: const Color(0xFF4A00E0), foregroundColor: Colors.white, centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), prefixIcon: const Icon(Icons.title, color: Color(0xFF4A00E0)), filled: true, fillColor: Colors.grey[50]),
                validator: (v) => v!.isEmpty ? 'Ingresa un título' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Descripción', border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)), prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF4A00E0)), filled: true, fillColor: Colors.grey[50]),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              const Text("Prioridad", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildPriorityChip('Alta', Colors.red), _buildPriorityChip('Media', Colors.orange), _buildPriorityChip('Baja', Colors.green),
              ]),
              const SizedBox(height: 30),
              const Text("Fecha Límite", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDate, borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(15), color: Colors.white),
                  child: Row(children: [const Icon(Icons.calendar_today, color: Color(0xFF4A00E0)), const SizedBox(width: 15), Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: const TextStyle(fontSize: 16)), const Spacer(), const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)]),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTask,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A00E0), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 5),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(widget.task == null ? 'GUARDAR TAREA' : 'ACTUALIZAR', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, Color color) {
    bool isSelected = _priority == label;
    return ChoiceChip(
      label: Text(label), selected: isSelected, selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: isSelected ? color : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      checkmarkColor: color, backgroundColor: Colors.grey[100], side: BorderSide(color: isSelected ? color : Colors.transparent),
      onSelected: (selected) { if (selected) setState(() => _priority = label); },
    );
  }
}
