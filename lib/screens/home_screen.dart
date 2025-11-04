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

  Future<void> _actualizarTarea(Tarea tarea, bool valor) async {
    try {
      await api.updateTarea(tarea.id, valor);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Tarea "${tarea.titulo}" actualizada'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      refrescar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Error al actualizar: $e'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Seguro que quieres eliminar "${tarea.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await api.deleteTarea(tarea.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(' Tarea "${tarea.titulo}" eliminada'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        refrescar();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: const Text('🍓 TO DO - Task'),
        backgroundColor: const Color(0xFFFF80AB),
      ),
      body: FutureBuilder<List<Tarea>>(
        future: tareas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
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
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: tarea.completada ? Colors.pink[100] : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
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
                    onChanged: (val) {
                      _actualizarTarea(tarea, val!);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _eliminarTarea(tarea),
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
