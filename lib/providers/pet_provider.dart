import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet.dart';

class PetProvider with ChangeNotifier {
  List<Pet> _pets = [];

  List<Pet> get pets => _pets;

  PetProvider() {
    loadPets();
  }

  Future<void> loadPets() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? petsJson = prefs.getStringList('paw_pulse_pets');

    if (petsJson != null) {
      _pets = petsJson.map((item) => Pet.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> addPet(Pet pet) async {
    _pets.add(pet);
    notifyListeners();
    await _saveToPrefs();
  }

  // Insert pet at a specific index (Used for Undo Delete)
  Future<void> insertPet(int index, Pet pet) async {
    if (index >= 0 && index <= _pets.length) {
      _pets.insert(index, pet);
    } else {
      _pets.add(pet);
    }
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> updatePet(Pet updatedPet) async {
    final index = _pets.indexWhere((p) => p.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      notifyListeners();
      await _saveToPrefs();
    }
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String petId) async {
    final index = _pets.indexWhere((p) => p.id == petId);
    if (index != -1) {
      _pets[index] = _pets[index].copyWith(isFavorite: !_pets[index].isFavorite);
      notifyListeners();
      await _saveToPrefs();
    }
  }

  Future<void> deletePet(String petId) async {
    _pets.removeWhere((p) => p.id == petId);
    notifyListeners();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> petsJson = _pets.map((pet) => pet.toJson()).toList();
    await prefs.setStringList('paw_pulse_pets', petsJson);
  }
}