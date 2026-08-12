<<<<<<< HEAD
# Task Manager CLI

Application en ligne de commande (Dart pur, sans Flutter) pour gérer une
liste de tâches, avec persistance dans un fichier JSON local.

## Fonctionnalités

- Ajouter une tâche (titre, priorité `low`/`medium`/`high`, date limite optionnelle)
- Lister toutes les tâches, triées par priorité ou par date limite
- Marquer une tâche comme terminée
- Supprimer une tâche
- Persistance automatique dans `tasks.json` (créé au premier lancement)

## Choix techniques

| Exigence | Où c'est fait |
|---|---|
| Classe abstraite + héritage | `Task` (abstraite) → `NormalTask`, `UrgentTask` (`lib/models/`) |
| Interface | `JsonSerializable` (`lib/models/json_serializable.dart`), implémentée par `Task` |
| Générique | `Repository<T>` (`lib/repository/repository.dart`), concrétisé par `JsonTaskRepository implements Repository<Task>` |
| Exceptions personnalisées | `TaskNotFoundException`, `DuplicateTaskException`, `InvalidTaskDataException`, `TaskStorageException` (`lib/exceptions/`) |
| Persistance JSON | `JsonTaskRepository` (`lib/repository/json_task_repository.dart`) |
| Tests unitaires (≥ 5) | `test/task_manager_test.dart` (7 tests, package `test`) |

### Détail d'une règle métier

Une `UrgentTask` force toujours sa priorité à `high` dans son constructeur,
quel que soit ce que l'utilisateur aurait pu vouloir passer : c'est un
exemple concret de polymorphisme (`typeLabel`, `toString`) et
d'encapsulation d'une règle métier dans la sous-classe plutôt que dans le
code appelant.

## Structure du projet

```
task_manager_cli/
├── bin/
│   └── main.dart                  # point d'entrée CLI
├── lib/
│   ├── models/
│   │   ├── priority.dart
│   │   ├── json_serializable.dart # interface
│   │   ├── task.dart               # classe abstraite
│   │   ├── normal_task.dart
│   │   └── urgent_task.dart
│   ├── exceptions/
│   │   └── task_exceptions.dart
│   ├── repository/
│   │   ├── repository.dart         # interface générique Repository<T>
│   │   └── json_task_repository.dart
│   └── services/
│       └── task_manager.dart       # logique métier
├── test/
│   └── task_manager_test.dart
├── pubspec.yaml
└── README.md
```

## Lancer l'application

Prérequis : [Dart SDK](https://dart.dev/get-dart) installé.

```bash
dart pub get
dart run bin/main.dart
```

Un menu s'affiche dans le terminal :

```
1. Ajouter une tâche
2. Lister les tâches
3. Marquer une tâche comme terminée
4. Supprimer une tâche
5. Quitter
```

Les tâches sont automatiquement sauvegardées dans `tasks.json`, à la
racine du projet, après chaque opération.

## Lancer les tests

```bash
dart pub get
dart test
```

Les tests utilisent des fichiers JSON temporaires isolés (créés et
supprimés par chaque test via `setUp`/`tearDown`), donc ils ne touchent
jamais au `tasks.json` de l'application réelle.

## Exemple d'utilisation

```
$ dart run bin/main.dart
=== Gestionnaire de tâches (CLI) ===
--------------------------------
1. Ajouter une tâche
2. Lister les tâches
3. Marquer une tâche comme terminée
4. Supprimer une tâche
5. Quitter
--------------------------------
Votre choix : 1
Titre de la tâche : Préparer la soutenance
Cette tâche est-elle urgente ? (o/n) : n
Priorité (low/medium/high) [medium] : high
Date limite (AAAA-MM-JJ), ou vide si aucune : 2026-09-01
Tâche créée : [ ] #1 (Normal, priorité haute) Préparer la soutenance — échéance : 2026-09-01
```
=======
# repo-hema-projet
>>>>>>> 2a544dc73805bd48624573d91502a01eab920281
