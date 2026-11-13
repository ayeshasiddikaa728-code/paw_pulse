import 'dart:convert';
import 'package:flutter/material.dart';

class Pet {
  final String id;
  final String name;
  final String breed;
  final int age;
  final double weight;
  final String imagePath;
  final String category; // Dog, Cat, Bird, Other
  final bool isFavorite;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    this.imagePath = '',
    this.category = 'Dog',
    this.isFavorite = false,
  });

  Pet copyWith({
    String? id,
    String? name,
    String? breed,
    int? age,
    double? weight,
    String? imagePath,
    String? category,
    bool? isFavorite,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  String get healthStatus {
    if (category == 'Cat') {
      if (weight < 3.0) return 'Underweight 💛';
      if (weight > 6.0) return 'Overweight 🧡';
      return 'Healthy 💚';
    } else if (category == 'Dog') {
      if (weight < 5.0) return 'Underweight 💛';
      if (weight > 30.0) return 'Overweight 🧡';
      return 'Healthy 💚';
    } else {
      if (weight < 0.5) return 'Underweight 💛';
      return 'Healthy 💚';
    }
  }

  Color get statusColor {
    if (healthStatus.contains('Underweight')) return Colors.orange.shade400;
    if (healthStatus.contains('Overweight')) return Colors.deepOrange.shade400;
    return Colors.teal.shade600;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'age': age,
      'weight': weight,
      'imagePath': imagePath,
      'category': category,
      'isFavorite': isFavorite,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      breed: map['breed'] ?? '',
      age: map['age']?.toInt() ?? 0,
      weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
      imagePath: map['imagePath'] ?? '',
      category: map['category'] ?? 'Dog',
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) => Pet.fromMap(json.decode(source));
}