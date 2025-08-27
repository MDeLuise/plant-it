import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class AddPlantViewmodel extends ChangeNotifier {
  AddPlantViewmodel({
    required PlantRepository plantRepository,
  }) : _plantRepository = plantRepository {
    load = Command.createAsync((Map<String, String> input) async {
      Result<void> result = await _load(input);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
    insert = Command.createAsyncNoParam(() async {
      Result<int> result = await _insert();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    }, initialValue: -1);
  }

  final PlantRepository _plantRepository;
  final _log = Logger('AddPlantViewmodel');

  late final Command<void, int> insert;
  late final Command<Map<String, String>, void> load;

  late PlantsCompanion _plant;

  setName(String name) {
    _plant = _plant.copyWith(name: Value(name));
  }

  setStartDate(DateTime date) {
    _plant = _plant.copyWith(startDate: Value(date));
  }

  setNote(String note) {
    _plant = _plant.copyWith(note: Value(note));
  }

  setLocation(String location) {
    _plant = _plant.copyWith(location: Value(location));
  }

  setSeller(String seller) {
    _plant = _plant.copyWith(seller: Value(seller));
  }

  setPrice(double price) {
    _plant = _plant.copyWith(price: Value(price));
  }

  String? get name => _plant.name.value;

  Future<Result<int>> _insert() {
    return _plantRepository.insert(
      _plant.copyWith(
        createdAt: Value(
          DateTime.now(),
        ),
      ),
    );
  }

  Future<Result<void>> _load(Map<String, String> input) async {
    int speciesId = int.parse(input['speciesId']!);
    String speciesName = input['speciesName']!;
    Result<int> count = await _plantRepository.countBySpecies(speciesId);
    if (count.isError()) {
      return count;
    }
    String plantDefaultName =
        "$speciesName${count.getOrThrow() == 0 ? "" : " ${count.getOrThrow()}"}";
    _plant = PlantsCompanion(
      species: Value(speciesId),
      name: Value(plantDefaultName),
    );
    return Success("ok");
  }
}
