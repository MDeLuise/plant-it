import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class EditPlantViewModel extends ChangeNotifier {
  EditPlantViewModel({
    required PlantRepository plantRepository,
  }) : _plantRepository = plantRepository {
    load = Command.createAsync((int id) async {
      Result<void> result = await _load(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
    update = Command.createAsyncNoParam(() async {
      Result<bool> result = await _update();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    }, initialValue: false);
  }

  final PlantRepository _plantRepository;
  final _log = Logger('EditPlantViewmodel');

  late final Command<void, bool> update;
  late final Command<int, void> load;

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

  String get name => _plant.name.value;
  DateTime? get date => _plant.startDate.value;
  String? get note => _plant.note.value;
  String? get location => _plant.location.value;
  String? get seller => _plant.seller.value;
  double? get price => _plant.price.present ? _plant.price.value : null;

  Future<Result<bool>> _update() {
    return _plantRepository.update(_plant);
  }

  Future<Result<void>> _load(int id) async {
    Result<Plant> plant = await _plantRepository.get(id);
    if (plant.isError()) {
      return plant;
    }
    _plant = plant.getOrThrow().toCompanion(true);
    return Success("ok");
  }
}
