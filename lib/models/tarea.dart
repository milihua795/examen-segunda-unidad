class Tarea {
  final int id;
  final String titulo;
  bool completada;

  Tarea({
    required this.id,
    required this.titulo,
    this.completada = false,
  });

  factory Tarea.fromJson(Map<String, dynamic> json) {
    return Tarea(
      id: json['id'],
      titulo: json['todo'] ?? '',
      completada: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': titulo,
      'completed': completada,
    };
  }
}
