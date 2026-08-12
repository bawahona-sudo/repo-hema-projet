/// Interface : tout objet capable de se convertir en `Map` JSON.
///
/// En Dart, une classe abstraite sans implémentation concrète, utilisée
/// avec `implements`, joue le rôle d'interface (il n'y a pas de mot-clé
/// `interface` dédié comme en Java).
abstract class JsonSerializable {
  Map<String, dynamic> toJson();
}
