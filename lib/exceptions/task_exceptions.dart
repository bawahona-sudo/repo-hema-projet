/// Exception levée quand on cherche/modifie/supprime une tâche dont
/// l'id n'existe pas dans le dépôt.
class TaskNotFoundException implements Exception {
  final int id;
  TaskNotFoundException(this.id);

  @override
  String toString() => 'TaskNotFoundException : aucune tâche avec l\'id $id.';
}

/// Exception levée quand on tente d'ajouter une tâche dont l'id existe
/// déjà dans le dépôt.
class DuplicateTaskException implements Exception {
  final int id;
  DuplicateTaskException(this.id);

  @override
  String toString() =>
      'DuplicateTaskException : une tâche avec l\'id $id existe déjà.';
}

/// Exception levée quand les données fournies pour créer/modifier une
/// tâche sont invalides (titre vide, priorité inconnue, date mal
/// formée, etc.).
class InvalidTaskDataException implements Exception {
  final String message;
  InvalidTaskDataException(this.message);

  @override
  String toString() => 'InvalidTaskDataException : $message';
}

/// Exception levée en cas de problème de lecture/écriture du fichier
/// JSON de persistance.
class TaskStorageException implements Exception {
  final String message;
  TaskStorageException(this.message);

  @override
  String toString() => 'TaskStorageException : $message';
}
