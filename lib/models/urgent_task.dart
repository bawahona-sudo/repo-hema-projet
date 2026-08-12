import 'priority.dart';
import 'task.dart';

/// Tâche urgente.
///
/// Règle métier illustrant l'héritage et le polymorphisme : quelle que
/// soit la priorité demandée à la création, une [UrgentTask] est TOUJOURS
/// traitée comme priorité haute (le constructeur force `Priority.high`
/// dans l'appel à `super`). Elle affiche aussi un marqueur visuel distinct
/// via l'override de `toString`.
class UrgentTask extends Task {
  UrgentTask({
    required int id,
    required String title,
    DateTime? dueDate,
    bool isDone = false,
  }) : super(
          id: id,
          title: title,
          priority: Priority.high,
          dueDate: dueDate,
          isDone: isDone,
        );

  @override
  String get typeLabel => 'Urgent';

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      id: json['id'] as int,
      title: json['title'] as String,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      isDone: json['isDone'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'type': 'urgent',
      };

  @override
  String toString() => '🔥 ${super.toString()}';
}
