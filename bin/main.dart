import 'dart:io';

import 'package:task_manager_cli/exceptions/task_exceptions.dart';
import 'package:task_manager_cli/models/priority.dart';
import 'package:task_manager_cli/repository/json_task_repository.dart';
import 'package:task_manager_cli/services/task_manager.dart';

const String _dataFile = 'tasks.json';

void main() {
  final repository = JsonTaskRepository(_dataFile);
  final manager = TaskManager(repository);

  print('=== Gestionnaire de tâches (CLI) ===');

  var running = true;
  while (running) {
    _printMenu();
    final choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          _handleAddTask(manager);
          break;
        case '2':
          _handleListTasks(manager);
          break;
        case '3':
          _handleCompleteTask(manager);
          break;
        case '4':
          _handleDeleteTask(manager);
          break;
        case '5':
          running = false;
          print('Au revoir !');
          break;
        default:
          print('Choix invalide, réessayez.\n');
      }
    } on InvalidTaskDataException catch (e) {
      print('Erreur : $e\n');
    } on TaskNotFoundException catch (e) {
      print('Erreur : $e\n');
    } on DuplicateTaskException catch (e) {
      print('Erreur : $e\n');
    } on TaskStorageException catch (e) {
      print('Erreur : $e\n');
    }
  }
}

void _printMenu() {
  print('''
--------------------------------
1. Ajouter une tâche
2. Lister les tâches
3. Marquer une tâche comme terminée
4. Supprimer une tâche
5. Quitter
--------------------------------''');
  stdout.write('Votre choix : ');
}

void _handleAddTask(TaskManager manager) {
  stdout.write('Titre de la tâche : ');
  final title = stdin.readLineSync() ?? '';

  stdout.write('Cette tâche est-elle urgente ? (o/n) : ');
  final urgentAnswer = (stdin.readLineSync() ?? '').trim().toLowerCase();
  final isUrgent = urgentAnswer == 'o' || urgentAnswer == 'oui';

  Priority priority = Priority.medium;
  if (!isUrgent) {
    stdout.write('Priorité (low/medium/high) [medium] : ');
    final priorityInput = (stdin.readLineSync() ?? '').trim();
    if (priorityInput.isNotEmpty) {
      priority = Priority.fromString(priorityInput);
    }
  }

  stdout.write('Date limite (AAAA-MM-JJ), ou vide si aucune : ');
  final dueInput = (stdin.readLineSync() ?? '').trim();
  DateTime? dueDate;
  if (dueInput.isNotEmpty) {
    dueDate = DateTime.parse(dueInput);
  }

  final task = manager.addTask(
    title: title,
    priority: priority,
    dueDate: dueDate,
    isUrgent: isUrgent,
  );
  print('Tâche créée : $task\n');
}

void _handleListTasks(TaskManager manager) {
  stdout.write('Trier par (priorite/date) [priorite] : ');
  final sortInput = (stdin.readLineSync() ?? '').trim().toLowerCase();
  final sortBy = sortInput == 'date' ? SortBy.dueDate : SortBy.priority;

  final tasks = manager.listTasks(sortBy: sortBy);
  if (tasks.isEmpty) {
    print('Aucune tâche enregistrée.\n');
    return;
  }
  print('--- Liste des tâches ---');
  for (final task in tasks) {
    print(task);
  }
  print('');
}

void _handleCompleteTask(TaskManager manager) {
  stdout.write('Id de la tâche à marquer comme terminée : ');
  final id = int.parse((stdin.readLineSync() ?? '').trim());
  final task = manager.completeTask(id);
  print('Tâche marquée comme terminée : $task\n');
}

void _handleDeleteTask(TaskManager manager) {
  stdout.write('Id de la tâche à supprimer : ');
  final id = int.parse((stdin.readLineSync() ?? '').trim());
  manager.deleteTask(id);
  print('Tâche #$id supprimée.\n');
}
