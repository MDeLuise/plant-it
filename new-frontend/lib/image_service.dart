import 'dart:io';

import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';

class ImageService {
  final Environment env;

  ImageService(this.env);

  Future<void> addImageToSpecies(
      File imageFile, String extension, int speciesId) async {
    final String path =
        await env.imageRepository.saveImageFile(imageFile, extension);
    final ImagesCompanion toSave = ImagesCompanion(
      imagePath: Value(path),
    );
    final int imageId = await env.imageRepository.insert(toSave);
    final Specy species = await env.speciesRepository.get(speciesId);
    await env.speciesRepository.insert(species
        .copyWith(
          avatar: Value(imageId),
        )
        .toCompanion(false));
  }

  Future<void> removeImageToSpecies(int speciesId) async {
    final Specy species = await env.speciesRepository.get(speciesId);
    if (species.avatar == null) {
      throw Exception("Species ${species.id} does not have a saved image");
    }
    final Image image = await env.imageRepository.get(species.avatar!);
    await env.imageRepository.removeImageFile(image.imagePath);
    env.imageRepository.delete(image.id);
  }

  Future<void> addImageToPlant(File imageFile, String extension, int plantId,
      String? description) async {
    final String path =
        await env.imageRepository.saveImageFile(imageFile, extension);
    final ImagesCompanion toSave = ImagesCompanion(
      imagePath: Value(path),
      description: Value.absentIfNull(description),
    );
    final int imageId = await env.imageRepository.insert(toSave);
    final Plant plant = await env.plantRepository.get(plantId);
    await env.plantRepository.insert(plant
        .copyWith(
          avatar: Value(imageId),
        )
        .toCompanion(false));
  }

  Future<void> removeImageToPlant(int plantId) async {
    final Plant plant = await env.plantRepository.get(plantId);
    if (plant.avatar == null) {
      throw Exception("Plant ${plant.id} does not have a saved image");
    }
    final Image image = await env.imageRepository.get(plant.avatar!);
    await env.imageRepository.removeImageFile(image.imagePath);
    env.imageRepository.delete(image.id);
  }
}
