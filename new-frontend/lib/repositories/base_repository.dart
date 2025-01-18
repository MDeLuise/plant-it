import 'package:drift/drift.dart';

abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T> get(int id);
  Future<int> insert(UpdateCompanion<T> toInsert);
  void delete(int id);
  Future<bool> update(T updated);
}
