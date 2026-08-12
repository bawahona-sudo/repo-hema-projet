import '../exceptions/task_exceptions.dart';
import '../models/normal_task.dart';
import '../models/priority.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';
import '../repository/repository.dart';

/// Critère de tri disponible pour l'affichage de la liste des tâches.
enum SortBy { priority, dueDate }

/// Couche métier : orchestre les règles de gestion des tâches au-dessus
/// du [Repository]. Le CLI (bin/main.dart) ne parle qu'à ce service, il
/// ne manipule jamais directement le repository.
class TaskManager {
  final Repository<Task> _repository;

  TaskManager(this._repository);

  /// Ajoute une tâche et retourne l'instance créée.
  ///
  /// - [title] ne peut pas être vide.
  /// - [isUrgent] contrôle si l'on crée une [UrgentTask] (priorité haute
  ///   imposée) ou une [NormalTask] (priorité choisie via [priority]).
  Task addTask({
    required String title,
    Priority priority = Priority.medium,
    DateTime? dueDate,
    bool isUrgent = false,
  }) {
    if (title.trim().isEmpty) {
      throw InvalidTaskDataException('Le titre ne peut pas être vide.');
    }

    final newId = _nextId();
    final Task task = isUrgent
        ? UrgentTask(id: newId, title: title, dueDate: dueDate)
        : NormalTask(id: newId, title: title, priority: priority, dueDate: dueDate);

    _repository.add(task);
    return task;
  }

  int _nextId() {
    final all = _repository.getAll();
    if (all.isEmpty) return 1;
    return all.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// Retourne toutes les tâches triées selon [sortBy].
  List<Task> listTasks({SortBy sortBy = SortBy.priority}) {
    final tasks = _repository.getAll().toList();
    switch (sortBy) {
      case SortBy.priority:
        tasks.sort(); // utilise Task.compareTo (priorité puis échéance)
        break;
      case SortBy.dueDate:
        tasks.sort((a, b) => a.compareByDueDate(b));
        break;
    }
    return tasks;
  }

  /// Marque une tâche comme terminée.
  /// Lève [TaskNotFoundException] si l'id n'existe pas.
  Task completeTask(int id) {
    final task = _repository.getById(id);
    if (task == null) {
      throw TaskNotFoundException(id);
    }
    task.isDone = true;
    _repository.update(task);
    return task;
  }

  /// Supprime une tâche.
  /// Lève [TaskNotFoundException] si l'id n'existe pas.
  void deleteTask(int id) {
    _repository.deleteById(id);
  }
}
