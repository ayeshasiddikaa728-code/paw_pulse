import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import 'pet_detail_screen.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  String _searchQuery = '';
  String _selectedFilterCategory = 'All';

  final List<String> _filterCategories = ['All', 'Dog', 'Cat', 'Bird', 'Other'];

  void _openPetForm({Pet? existingPet}) {
    final isEditing = existingPet != null;
    final nameController = TextEditingController(text: isEditing ? existingPet.name : '');
    final breedController = TextEditingController(text: isEditing ? existingPet.breed : '');
    final ageController = TextEditingController(text: isEditing ? existingPet.age.toString() : '');
    final weightController = TextEditingController(text: isEditing ? existingPet.weight.toString() : '');
    String selectedAvatar = isEditing && existingPet.imagePath.isNotEmpty ? existingPet.imagePath : '🐶';
    String selectedCategory = isEditing ? existingPet.category : 'Dog';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFF0F5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Pet Info 🎀' : 'Add New Pet 🐾',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFD81B60)),
                  ),
                  const SizedBox(height: 16),

                  const Text('Category 🏷️:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: ['Dog', 'Cat', 'Bird', 'Other'].map((cat) {
                      final isSel = selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSel,
                          selectedColor: const Color(0xFFFF8DA1),
                          labelStyle: TextStyle(color: isSel ? Colors.white : Colors.black87),
                          onSelected: (bool selected) {
                            if (selected) setSheetState(() => selectedCategory = cat);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name *',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: breedController,
                    decoration: InputDecoration(
                      labelText: 'Breed',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age (Years) *',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Weight (kg) *',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8DA1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (nameController.text.trim().isNotEmpty) {
                          final petData = Pet(
                            id: isEditing ? existingPet.id : DateTime.now().toString(),
                            name: nameController.text.trim(),
                            breed: breedController.text.trim().isEmpty ? 'Cute Pet' : breedController.text.trim(),
                            age: int.tryParse(ageController.text.trim()) ?? 0,
                            weight: double.tryParse(weightController.text.trim()) ?? 0.0,
                            imagePath: selectedAvatar,
                            category: selectedCategory,
                            isFavorite: isEditing ? existingPet.isFavorite : false,
                            notes: isEditing ? existingPet.notes : '',
                          );

                          final provider = Provider.of<PetProvider>(context, listen: false);
                          if (isEditing) {
                            provider.updatePet(petData);
                          } else {
                            provider.addPet(petData);
                          }

                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(isEditing ? 'Update Pet 💖' : 'Save Pet 💕', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(Pet pet, int originalIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Pet 🐾'),
        content: Text('Are you sure you want to remove ${pet.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.pink),
            onPressed: () {
              final provider = Provider.of<PetProvider>(context, listen: false);
              provider.deletePet(pet.id);
              Navigator.of(ctx).pop();

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF880E4F),
                  content: Text('${pet.name} deleted 🗑️'),
                  action: SnackBarAction(
                    label: 'UNDO ↩️',
                    textColor: const Color(0xFFFFC1CC),
                    onPressed: () {
                      provider.insertPet(originalIndex, pet);
                    },
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);

    final filteredPets = petProvider.pets.where((pet) {
      final matchesSearch = pet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          pet.breed.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedFilterCategory == 'All' || pet.category == _selectedFilterCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filteredPets.sort((a, b) => (b.isFavorite ? 1 : 0).compareTo(a.isFavorite ? 1 : 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets 🐶🐱💖', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          if (petProvider.pets.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Search pets by name or breed... 🔍',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFF8DA1)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: const Color(0xFFFFC1CC).withValues(alpha: 0.5), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFFF8DA1), width: 1.5),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterCategories.length,
                itemBuilder: (context, index) {
                  final cat = _filterCategories[index];
                  final isSelected = _selectedFilterCategory == cat;
                  String displayLabel = cat == 'All' ? 'All 🐾' : (cat == 'Dog' ? 'Dogs 🐶' : (cat == 'Cat' ? 'Cats 🐱' : (cat == 'Bird' ? 'Birds 🦜' : 'Others ✨')));

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(displayLabel),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFF8DA1),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: isSelected ? const Color(0xFFFF8DA1) : const Color(0xFFFFC1CC),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF880E4F),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      onSelected: (bool selected) {
                        if (selected) setState(() => _selectedFilterCategory = cat);
                      },
                    ),
                  );
                },
              ),
            ),
          ],

          Expanded(
            child: petProvider.pets.isEmpty
                ? Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF8DA1).withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.pets_rounded,
                          size: 90,
                          color: Color(0xFFFF8DA1),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Your furry friends are waiting! 💕',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the "+ Add Pet 💕" button below to add your pet\'s profile and track their weight & health.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
                : filteredPets.isEmpty
                ? Center(
              child: Text(
                'No pets found! 🐾',
                style: TextStyle(fontSize: 16, color: Colors.pink.shade300, fontWeight: FontWeight.w600),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredPets.length,
              itemBuilder: (ctx, index) {
                final pet = filteredPets[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PetDetailScreen(pet: pet),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8DA1).withValues(alpha: 0.12),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -10,
                            bottom: -10,
                            child: Icon(
                              pet.category == 'Cat' ? Icons.cruelty_free_rounded : Icons.pets,
                              size: 110,
                              color: const Color(0xFFFFE4E1).withValues(alpha: 0.4),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFE4E1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      pet.category == 'Cat' ? '🐱' : (pet.category == 'Bird' ? '🦜' : '🐶'),
                                      style: const TextStyle(fontSize: 30),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pet.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF880E4F),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${pet.breed} • ${pet.age} yrs (${pet.category})',
                                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                                      ),
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFC1CC),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.monitor_weight_outlined, size: 14, color: Color(0xFFC2185B)),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${pet.weight} kg',
                                                  style: const TextStyle(
                                                    color: Color(0xFFC2185B),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: pet.statusColor.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              pet.healthStatus,
                                              style: TextStyle(
                                                color: pet.statusColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    pet.isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: pet.isFavorite ? Colors.pinkAccent : Colors.pink.shade200,
                                  ),
                                  onPressed: () {
                                    petProvider.toggleFavorite(pet.id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Color(0xFFFF8DA1)),
                                  onPressed: () => _openPetForm(existingPet: pet),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.pinkAccent),
                                  onPressed: () => _confirmDelete(pet, index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openPetForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Pet 💕', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}