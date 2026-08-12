/// Niveau de priorité d'une tâche.
enum Priority {
  low,
  medium,
  high;

  /// Convertit une chaîne (issue du JSON ou saisie utilisateur) en [Priority].
  static Priority fromString(String value) {
    switch (value.toLowerCase().trim()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        throw ArgumentError('Priorité inconnue : "$value"');
    }
  }

  /// Représentation lisible pour l'affichage CLI.
  String get label {
    switch (this) {
      case Priority.low:
        return 'basse';
      case Priority.medium:
        return 'moyenne';
      case Priority.high:
        return 'haute';
    }
  }
}
