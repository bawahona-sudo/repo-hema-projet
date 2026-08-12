import 'priority.dart';
import 'task.dart';

/// Tâche "classique" : la priorité et l'échéance sont librement choisies
/// par l'utilisateur.
class NormalTask extends Task {
  NormalTask({
    required int id,
    required String title,
    required Priority priority,
    DateTime? dueDate,
    bool isDone = false,
  }) : super(
          id: id,
          title: title,
          priority: priority,
          dueDate: dueDate,
          isDone: isDone,
        );

  @override
  String get typeLabel => 'Normal';

  factory NormalTask.fromJson(Map<String, dynamic> json) {
    return NormalTask(
      id: json['id'] as int,
      title: json['title'] as String,
      priority: Priority.fromString(json['priority'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      isDone: json['isDone'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'type': 'normal',
      };
}
