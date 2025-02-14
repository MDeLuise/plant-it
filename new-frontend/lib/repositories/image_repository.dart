import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';
import 'package:uuid/uuid.dart';

class ImageRepository extends BaseRepository<Image> {
  final AppDatabase db;
  final Cache cache;

  ImageRepository(this.db, this.cache);

  ImageRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Image>> getAll() async {
    return db.select(db.images).get();
  }

  @override
  Future<Image> get(int id) {
    return (db.select(db.images)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Image> toInsert) {
    return db.into(db.images).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.images)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(Image updated) async {
    return db.update(db.images).replace(updated);
  }

  Future<String> getBase64(int id) async {
    final Image imageRecord = await get(id);

    final File file = File(imageRecord.imagePath);
    if (!await file.exists()) {
      throw Exception("File not found at path: ${imageRecord.imagePath}");
    }

    final Uint8List bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<String> saveImageFile(File imageFile, String extension) async {
    final Uuid uuid = Uuid();
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory('${dir.path}/images');

    if (!(await imageDir.exists())) {
      await imageDir.create(recursive: true);
    }

    final String fileName = '${uuid.v4()}.$extension';
    final String savedPath = '${imageDir.path}/$fileName';

    await imageFile.copy(savedPath);
    return savedPath;
  }

  Future<void> removeImageFile(String imagePath) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final Directory imageDir = Directory('${dir.path}/images');
    final String savedPath = '${imageDir.path}/$imagePath';
    final File file = File(savedPath);
    if (!await file.exists()) {
      throw Exception("File not found at path: $savedPath");
    }
    await file.delete();
  }
}
