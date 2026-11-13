import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';

class PetDetailScreen extends StatefulWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late TextEditingController _notesController;
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.pet.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveNotes() {
    final updatedPet = widget.pet.copyWith(notes: _notesController.text.trim());
    Provider.of<PetProvider>(context, listen: false).updatePet(updatedPet);
    setState(() => _isEditingNotes = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF880E4F),
        content: Text('Care notes updated successfully! 📝💖'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final currentPet = petProvider.pets.firstWhere(
          (p) => p.id == widget.pet.id,
      orElse: () => widget.pet,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      appBar: AppBar(
        title: Text('${currentPet.name}\'s Profile 🐾', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFFC1CC),
        foregroundColor: const Color(0xFF880E4F),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              currentPet.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.pinkAccent,
            ),
            onPressed: () => petProvider.toggleFavorite(currentPet.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8DA1).withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE4E1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        currentPet.category == 'Cat' ? '🐱' : (currentPet.category == 'Bird' ? '🦜' : '🐶'),
                        style: const TextStyle(fontSize: 45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentPet.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF880E4F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${currentPet.breed} • ${currentPet.category}',
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: currentPet.statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Health Status: ${currentPet.healthStatus}',
                      style: TextStyle(
                        color: currentPet.statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8DA1).withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.cake_outlined, color: Color(0xFFFF8DA1), size: 28),
                        const SizedBox(height: 8),
                        const Text('Age', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          '${currentPet.age} Years',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8DA1).withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.monitor_weight_outlined, color: Color(0xFFFF8DA1), size: 28),
                        const SizedBox(height: 8),
                        const Text('Weight', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(
                          '${currentPet.weight} kg',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Care Notes & Bio 📝',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF880E4F),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isEditingNotes ? Icons.check_circle_rounded : Icons.edit_note_rounded,
                          color: const Color(0xFFFF8DA1),
                          size: 28,
                        ),
                        onPressed: () {
                          if (_isEditingNotes) {
                            _saveNotes();
                          } else {
                            setState(() => _isEditingNotes = true);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _isEditingNotes
                      ? TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Add dietary preferences, allergies, vet notes...',
                      filled: true,
                      fillColor: const Color(0xFFFFF0F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                      : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      currentPet.notes.isEmpty
                          ? 'No care notes added yet. Tap the edit icon to add dietary or health notes! 💕'
                          : currentPet.notes,
                      style: TextStyle(
                        fontSize: 14,
                        color: currentPet.notes.isEmpty ? Colors.grey.shade500 : Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}