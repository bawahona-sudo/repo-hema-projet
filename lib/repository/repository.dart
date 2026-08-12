/// Contrat générique d'un dépôt de données.
///
/// [T] est le type des objets stockés (ici [Task], mais le contrat est
/// volontairement générique pour pouvoir être réutilisé avec un autre
/// modèle sans dupliquer de code).
abstract class Repository<T> {
  List<T> getAll();
  T? getById(int id);
  void add(T item);
  void update(T item);
  void deleteById(int id);
}
