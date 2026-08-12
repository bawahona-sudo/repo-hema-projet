import 'dart:convert';
import 'dart:io';

import '../exceptions/task_exceptions.dart';
import '../models/task.dart';
import 'repository.dart';

/// Implémentation concrète de [Repository] pour les [Task], avec
/// persistance dans un fichier JSON local.
///
/// Le fichier est relu à la construction et réécrit intégralement après
/// chaque opération d'écriture (add/update/delete) : c'est volontairement
/// simple, adapté à une application CLI mono-utilisateur.
class JsonTaskRepository implements Repository<Task> {
  final String filePath;
  final List<Task> _tasks = [];

  JsonTaskRepository(this.filePath) {
    _load();
  }

  void _load() {
    final file = File(filePath);
    if (!file.existsSync()) {
      return; // premier lancement : aucune tâche encore persistée
    }
    try {
      final content = file.readAsStringSync();
      if (content.trim().isEmpty) return;
      final decoded = jsonDecode(content) as List<dynamic>;
      _tasks.clear();
      for (final item in decoded) {
        _tasks.add(Task.fromJson(item as Map<String, dynamic>));
      }
    } catch (e) {
      throw TaskStorageException(
          'Impossible de lire le fichier "$filePath" : $e');
    }
  }

  void _persist() {
    try {
      final file = File(filePath);
      final jsonList = _tasks.map((t) => t.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonList));
    } catch (e) {
      throw TaskStorageException(
          'Impossible d\'écrire dans le fichier "$filePath" : $e');
    }
  }

  @override
  List<Task> getAll() => List.unmodifiable(_tasks);

  @override
  Task? getById(int id) {
    for (final task in _tasks) {
      if (task.id == id) return task;
    }
    return null;
  }

  @override
  void add(Task item) {
    if (getById(item.id) != null) {
      throw DuplicateTaskException(item.id);
    }
    _tasks.add(item);
    _persist();
  }

  @override
  void update(Task item) {
    final index = _tasks.indexWhere((t) => t.id == item.id);
    if (index == -1) {
      throw TaskNotFoundException(item.id);
    }
    _tasks[index] = item;
    _persist();
  }

  @override
  void deleteById(int id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) {
      throw TaskNotFoundException(id);
    }
    _tasks.removeAt(index);
    _persist();
  }
}
