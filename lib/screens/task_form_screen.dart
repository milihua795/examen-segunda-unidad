import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseHelper api = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Captura cuando el usuario presiona "back"
      onWillPop: () async {
        Navigator.pop(context, true); // Devuelve true para refrescar la lista
        return false; // Evita cerrar sin devolver valor
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF0F5),
        appBar: AppBar(
          title: const Text('🍓 Nueva Tarea'),
          backgroundColor: const Color(0xFFFF80AB),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Título',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.favorite, color: Colors.pinkAccent),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF80AB),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () async {
                  if (_controller.text.isNotEmpty) {
                    await api.addTarea(_controller.text);
                    if (mounted) Navigator.pop(context, true); // Devuelve true al HomeScreen
                  }
                },
                child: const Text('Guardar 🍓'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
