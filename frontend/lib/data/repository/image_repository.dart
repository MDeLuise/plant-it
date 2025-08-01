import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';

class ImageRepository extends CRUDRepository<Image> {
  ImageRepository({required super.db});

  @override
  TableInfo<Table, Image> get table => db.images;

  Future<Result<List<Image>>> getImagesForPlant(int plantId) async {
    try {
      List<Image> imageList = await (db.select(db.images)
            ..where((t) => t.plantId.equals(plantId))
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.createdAt,
                    mode: OrderingMode.desc,
                  )
            ]))
          .get();
      return imageList.toSuccess();
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<List<String>>> getImagesBase64ForPlant(int plantId) async {
    Result<List<Image>> imagesResult = await getImagesForPlant(plantId);

    if (imagesResult.isError()) {
      return Failure(Exception(imagesResult.exceptionOrNull()!));
    }

    try {
      List<Future<Result<String>>> base64ResultsFuture =
          imagesResult.getOrThrow().map((i) => getBase64(i.id)).toList();

      List<Result<String>> base64Results =
          await Future.wait(base64ResultsFuture);

      List<String> base64List = [];
      for (Result<String> result in base64Results) {
        if (result.isError()) {
          return Failure(Exception(result.exceptionOrNull()));
        }
        base64List.add(result.getOrThrow());
      }

      return Success(base64List);
    } catch (e) {
      return Failure(Exception('Failed to get image base64s: $e'));
    }
  }

  Future<Result<String>> getBase64(int id) async {
    Result<Image> imageGetResult = await get(id);
    if (imageGetResult.isError()) {
      return Failure(imageGetResult.exceptionOrNull()!);
    }
    Image imageRecord = imageGetResult.getOrThrow();

    // Use local file if path is available
    String? path = imageRecord.imagePath;
    if (path != null) {
      File file = File(path);
      if (!await file.exists()) {
        return Failure(Exception("File not found at path: $path"));
      }
      Uint8List bytes = await file.readAsBytes();
      return base64Encode(bytes).toSuccess();
    }

    // Fallback to downloading image from URL
    String? url = imageRecord.imageUrl;
    if (url != null) {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return Failure(Exception("Failed to download image from URL: $url"));
      }
      return base64Encode(response.bodyBytes).toSuccess();
    }

    return Failure(
        Exception("Both imagePath and imageUrl are null for image ID: $id"));
  }

  Future<Result<String>> saveImageFile(File imageFile, String extension) async {
    Uuid uuid = Uuid();
    Directory dir = await getApplicationDocumentsDirectory();
    Directory imageDir = Directory('${dir.path}/images');

    if (!(await imageDir.exists())) {
      try {
        await imageDir.create(recursive: true);
      } catch (e) {
        return Failure(Exception(e.toString()));
      }
    }

    String fileName = '${uuid.v4()}.$extension';
    String savedPath = '${imageDir.path}/$fileName';

    await imageFile.copy(savedPath);
    return savedPath.toSuccess();
  }

  Future<Result<void>> removeImageFile(String imagePath) async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory imageDir = Directory('${dir.path}/images');
    String savedPath = '${imageDir.path}/$imagePath';
    File file = File(savedPath);
    if (!await file.exists()) {
      return Failure(Exception("File not found at path: $savedPath"));
    }
    return (await file.delete()).toSuccess();
  }

  Future<Result<Image>?> getSpecifiedAvatarForPlant(int plantId) async {
    Image? avatar = await (db.select(db.images)
          ..where(
              (img) => img.plantId.equals(plantId) & img.isAvatar.equals(true))
          ..limit(1))
        .getSingleOrNull();
    return avatar?.toSuccess();
  }

  Future<Result<String>?> getSpecifiedAvatarForPlantBase64(int plantId) async {
    Result<Image>? specifiedAvatarResult =
        await getSpecifiedAvatarForPlant(plantId);
    if (specifiedAvatarResult == null) {
      return null;
    }
    return getBase64(specifiedAvatarResult.getOrThrow().id);
  }

  Future<Result<Image>?> getSpecifiedAvatarForSpecies(int speciesId) async {
    Image? avatar = await (db.select(db.images)
          ..where((img) =>
              img.speciesId.equals(speciesId) & img.isAvatar.equals(true))
          ..limit(1))
        .getSingleOrNull();
    return avatar?.toSuccess();
  }

  Future<Result<String>?> getSpecifiedAvatarForSpeciesBase64(
      int speciesId) async {
    Result<Image>? specifiedAvatarResult =
        await getSpecifiedAvatarForSpecies(speciesId);
    if (specifiedAvatarResult == null) {
      return null;
    }
    return getBase64(specifiedAvatarResult.getOrThrow().id);
  }

  Future<Result<void>?> removeAvatarForSpecies(int speciesId) async {
    final Result<Image>? avatarResult =
        await getSpecifiedAvatarForSpecies(speciesId);
    if (avatarResult == null) {
      return null;
    }
    await (db.delete(db.images)..where((i) => i.speciesId.equals(speciesId)))
        .go();

    if (avatarResult.getOrThrow().imagePath == null) {
      return "ok".toSuccess();
    }
    return await removeImageFile(avatarResult.getOrThrow().imagePath!);
  }

  Future<Result<void>> unsetAvatarForPlant(int plantId) async {
    final Result<Image>? avatarResult =
        await getSpecifiedAvatarForPlant(plantId);
    if (avatarResult == null) {
      return Failure(Exception("Plant with ID $plantId has no avatar set"));
    }
    return await update(
        avatarResult.getOrThrow().copyWith(isAvatar: false).toCompanion(false));
  }
}
