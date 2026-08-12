import 'dart:io';

import 'package:task_manager_cli/exceptions/task_exceptions.dart';
import 'package:task_manager_cli/models/priority.dart';
import 'package:task_manager_cli/models/urgent_task.dart';
import 'package:task_manager_cli/repository/json_task_repository.dart';
import 'package:task_manager_cli/services/task_manager.dart';
import 'package:test/test.dart';

void main() {
  late String testFilePath;
  late JsonTaskRepository repository;
  late TaskManager manager;

  setUp(() {
    // Chaque test utilise son propre fichier JSON temporaire, isolé des
    // autres tests et de l'application réelle.
    testFilePath =
        'test_tasks_${DateTime.now().microsecondsSinceEpoch}.json';
    repository = JsonTaskRepository(testFilePath);
    manager = TaskManager(repository);
  });

  tearDown(() {
    final file = File(testFilePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
  });

  test('addTask crée une tâche et la rend visible dans listTasks', () {
    manager.addTask(title: 'Rédiger le mémoire', priority: Priority.high);

    final tasks = manager.listTasks();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Rédiger le mémoire');
    expect(tasks.first.isDone, false);
  });

  test('addTask avec un titre vide lève InvalidTaskDataException', () {
    expect(
      () => manager.addTask(title: ''),
      throwsA(isA<InvalidTaskDataException>()),
    );
  });

  test('une UrgentTask a toujours la priorité haute, même si on l\'ignore',
      () {
    final task = manager.addTask(title: 'Panne serveur', isUrgent: true);

    expect(task, isA<UrgentTask>());
    expect(task.priority, Priority.high);
  });

  test('completeTask marque bien la tâche comme terminée', () {
    final created = manager.addTask(title: 'Nettoyer le bureau');

    final completed = manager.completeTask(created.id);

    expect(completed.isDone, true);
    // On vérifie aussi que le changement est bien persisté dans le repo.
    expect(repository.getById(created.id)!.isDone, true);
  });

  test('completeTask avec un id inconnu lève TaskNotFoundException', () {
    expect(
      () => manager.completeTask(999),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('deleteTask supprime bien la tâche de la liste', () {
    final created = manager.addTask(title: 'Tâche à supprimer');

    manager.deleteTask(created.id);

    expect(manager.listTasks(), isEmpty);
  });

  test('listTasks trie par priorité décroissante (haute -> basse)', () {
    manager.addTask(title: 'Basse', priority: Priority.low);
    manager.addTask(title: 'Haute', priority: Priority.high);
    manager.addTask(title: 'Moyenne', priority: Priority.medium);

    final tasks = manager.listTasks(sortBy: SortBy.priority);

    expect(tasks.map((t) => t.title).toList(), ['Haute', 'Moyenne', 'Basse']);
  });

  test('les tâches persistent après relecture du fichier JSON', () {
    manager.addTask(title: 'Persistance', priority: Priority.medium);

    // On simule un nouveau lancement de l'application : nouveau repo,
    // même fichier.
    final reloadedRepository = JsonTaskRepository(testFilePath);
    final reloadedManager = TaskManager(reloadedRepository);

    final tasks = reloadedManager.listTasks();
    expect(tasks.length, 1);
    expect(tasks.first.title, 'Persistance');
  });
}
