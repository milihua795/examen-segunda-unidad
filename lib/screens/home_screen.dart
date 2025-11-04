import 'package:flutter/material.dart';
import '../models/tarea.dart';
import '../services/database_helper.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper api = DatabaseHelper();
  late Future<List<Tarea>> tareas;

  @override
  void initState() {
    super.initState();
    tareas = api.getTareas();
  }

  void refrescar() {
    setState(() {
      tareas = api.getTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text('🍓 Mis Tareas con API'),
        backgroundColor: const Color(0xFFFF80AB),
      ),
      body: FutureBuilder<List<Tarea>>(
        future: tareas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return const Center(child: Text('🍓 No hay tareas aún.'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, index) {
              final tarea = lista[index];
              return Card(
                color: tarea.completada ? Colors.pink[100] : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  title: Text(
                    tarea.titulo,
                    style: TextStyle(
                      color: tarea.completada ? Colors.grey : Colors.pink[900],
                      decoration: tarea.completada ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    activeColor: Colors.pinkAccent,
                    value: tarea.completada,
                    onChanged: (val) async {
                      await api.updateTarea(tarea.id, val!);
                      refrescar();
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await api.deleteTarea(tarea.id);
                      refrescar();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF80AB),
        onPressed: () async {
          final creada = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TaskFormScreen()),
          );
          if (creada == true) refrescar();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
