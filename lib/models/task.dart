import 'json_serializable.dart';
import 'priority.dart';
import 'normal_task.dart';
import 'urgent_task.dart';

/// Classe abstraite représentant une tâche.
///
/// [Task] ne peut pas être instanciée directement : elle définit l'état
/// commun (id, titre, priorité, échéance, statut) et impose un contrat
/// (`typeLabel`) à toutes ses sous-classes concrètes ([NormalTask],
/// [UrgentTask]).
///
/// Elle implémente deux contrats :
/// - [Comparable] pour permettre le tri natif (`List.sort`) par priorité ;
/// - [JsonSerializable] (interface) pour la persistance JSON.
abstract class Task implements Comparable<Task>, JsonSerializable {
  final int id;
  final String title;
  final Priority priority;
  final DateTime? dueDate;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    required this.priority,
    this.dueDate,
    this.isDone = false,
  }) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Le titre d\'une tâche ne peut pas être vide.');
    }
  }

  /// Étiquette du type concret, définie par chaque sous-classe.
  /// C'est le "point d'extension" que toute sous-classe de [Task] doit
  /// fournir : c'est ce qui rend cette classe abstraite plutôt que concrète.
  String get typeLabel;

  /// Fabrique polymorphe : reconstruit la bonne sous-classe à partir du
  /// champ `type` stocké dans le JSON.
  factory Task.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'urgent':
        return UrgentTask.fromJson(json);
      case 'normal':
        return NormalTask.fromJson(json);
      default:
        throw ArgumentError('Type de tâche inconnu dans le JSON : "$type"');
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'priority': priority.name,
        'dueDate': dueDate?.toIso8601String(),
        'isDone': isDone,
      };

  /// Tri par priorité décroissante (haute -> basse).
  /// Deux tâches de même priorité sont ensuite triées par échéance.
  @override
  int compareTo(Task other) {
    final byPriority = other.priority.index.compareTo(priority.index);
    if (byPriority != 0) return byPriority;
    return compareByDueDate(other);
  }

  int compareByDueDate(Task other) {
    if (dueDate == null && other.dueDate == null) return 0;
    if (dueDate == null) return 1; // pas d'échéance -> classée après
    if (other.dueDate == null) return -1;
    return dueDate!.compareTo(other.dueDate!);
  }

  @override
  String toString() {
    final check = isDone ? '[x]' : '[ ]';
    final due = dueDate != null
        ? ' — échéance : ${dueDate!.toIso8601String().split('T').first}'
        : '';
    return '$check #$id ($typeLabel, priorité ${priority.label}) $title$due';
  }
}
