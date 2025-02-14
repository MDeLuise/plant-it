import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
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

  Future<List<Image>> getImagesForPlant(int plantId) {
    return (db.select(db.images)..where((t) => t.plantId.equals(plantId)))
        .get();
  }

  Future<List<String>> getImagesBase64ForPlant(int plantId) async {
    final List<Image> images = await getImagesForPlant(plantId);
    return Future.wait(images.map((i) => getBase64(i.id)));
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

    // Use local file if path is available
    final String? path = imageRecord.imagePath;
    if (path != null) {
      final File file = File(path);
      if (!await file.exists()) {
        throw Exception("File not found at path: $path");
      }
      final Uint8List bytes = await file.readAsBytes();
      return base64Encode(bytes);
    }

    // Fallback to downloading image from URL
    final String? url = imageRecord.imageUrl;
    if (url != null) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception("Failed to download image from URL: $url");
      }
      return base64Encode(response.bodyBytes);
    }

    // Neither source is available
    throw Exception("Both imagePath and imageUrl are null for image ID: $id");
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

  Future<Image?> getSpecifiedAvatarForPlant(int plantId) async {
    return (db.select(db.images)
          ..where(
              (img) => img.plantId.equals(plantId) & img.isAvatar.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String?> getSpecifiedAvatarForPlantBase64(int plantId) async {
    return getSpecifiedAvatarForPlant(plantId).then((i) {
      if (i == null) {
        return null;
      }
      return getBase64(i.id);
    });
  }

  Future<Image?> getSpecifiedAvatarForSpecies(int speciesId) async {
    return (db.select(db.images)
          ..where((img) =>
              img.speciesId.equals(speciesId) & img.isAvatar.equals(true))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<String?> getSpecifiedAvatarForSpeciesBase64(int speciesId) async {
    return getSpecifiedAvatarForSpecies(speciesId).then((i) {
      if (i == null) {
        return null;
      }
      return getBase64(i.id);
    });
  }

  Future<void> insertAll(List<ImagesCompanion> toInsert) async {
    await db.batch((batch) {
      batch.insertAll(db.images, toInsert);
    });
  }

  Future<void> removeAvatarForSpecies(speciesId) async {
    final Image? avatar = await getSpecifiedAvatarForSpecies(speciesId);
    if (avatar == null) {
      return;
    }
    (db.delete(db.images)..where((i) => i.speciesId.equals(speciesId))).go();
    if (avatar.imagePath != null) {
      await removeImageFile(avatar.imagePath!);
    }
  }

  Future<void> unsetAvatarForPlant(plantId) async {
    final Image? avatar = await getSpecifiedAvatarForPlant(plantId);
    if (avatar == null) {
      return;
    }
    await update(avatar.copyWith(isAvatar: false));
  }
}
