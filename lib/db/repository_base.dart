import 'package:hive/hive.dart';

abstract class RepositoryBase<TObject> {
  Future<void> save(TObject tObject);

  TObject? getById(dynamic id);

  Future<void> delete(TObject tObject);
  Future<void> deleteAll();
}

abstract class HiveRepositoryBase<TObject> {
  late Box<TObject> box;

  final String boxName;

  HiveRepositoryBase({required this.boxName});

  /// Initializes the repository by opening the Hive box.
  Future<void> init() async {
    box = await Hive.openBox(boxName);
  }
}
