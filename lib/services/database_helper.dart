import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tarea.dart';

class DatabaseHelper {
  final String baseUrl = "https://dummyjson.com/todos";

  /// 🔹 GET - Obtener todas las tareas
  Future<List<Tarea>> getTareas() async {
    print("Solicitando lista de tareas desde la API...");
    final response = await http.get(Uri.parse(baseUrl));
    print("Respuesta recibida: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List tareas = data['todos'];
      print("Se cargaron ${tareas.length} tareas.");
      return tareas.map((e) => Tarea.fromJson(e)).toList();
    } else {
      print("Error al obtener tareas: ${response.body}");
      throw Exception('Error al cargar tareas');
    }
  }

  /// 🔹 POST - Crear nueva tarea
  Future<Tarea> addTarea(String titulo) async {
    print("Enviando nueva tarea: $titulo");
    final response = await http.post(
      Uri.parse('$baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'todo': titulo, 'completed': false, 'userId': 1}),
    );

    print("Código respuesta POST: ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Tarea creada correctamente: ${data['todo']}");
      return Tarea.fromJson(data);
    } else {
      print("Error al crear tarea: ${response.body}");
      throw Exception('Error al agregar tarea');
    }
  }

  /// 🔹 PUT - Actualizar estado
  Future<void> updateTarea(int id, bool completada) async {
    print("Actualizando tarea ID=$id → completada=$completada");
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'completed': completada}),
    );

    print("Código respuesta PUT: ${response.statusCode}");
    if (response.statusCode != 200) {
      print("Error al actualizar tarea: ${response.body}");
      throw Exception('Error al actualizar tarea');
    }
  }

  /// 🔹 DELETE - Eliminar tarea
  Future<void> deleteTarea(int id) async {
    print("Eliminando tarea con ID=$id");
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    print("Código respuesta DELETE: ${response.statusCode}");

    if (response.statusCode != 200) {
      print("Error al eliminar tarea: ${response.body}");
      throw Exception('Error al eliminar tarea');
    }
  }
}
