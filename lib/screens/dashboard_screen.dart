import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pet_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petProvider = Provider.of<PetProvider>(context);
    final pets = petProvider.pets;

    int dogCount = pets.where((p) => p.category == 'Dog').length;
    int catCount = pets.where((p) => p.category == 'Cat').length;
    int birdCount = pets.where((p) => p.category == 'Bird').length;

    // Pick first pet for birthday card demo
    final birthdayPet = pets.isNotEmpty ? pets.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PawPulse 🐾', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8DA1), Color(0xFFFFB6C1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8DA1).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back! 💖',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Track your lovely pets and their health stats easily.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Birthday Card Section 🎂
            if (birthdayPet != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFFFC1CC), width: 1.5),
                ),
                child: Row(
                  children: [
                    const Text('🎂', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upcoming Birthday! 🎉',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.pink.shade700),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${birthdayPet.name} turns ${birthdayPet.age + 1} soon! Get ready for treats 🦴',
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Category Stats Title
            const Text(
              'Pet Category Breakdown 📊',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
            ),
            const SizedBox(height: 12),

            // Category Grid
            Row(
              children: [
                Expanded(child: _buildCategoryCard('Dogs 🐶', '$dogCount', const Color(0xFFFFE4E1))),
                const SizedBox(width: 10),
                Expanded(child: _buildCategoryCard('Cats 🐱', '$catCount', const Color(0xFFFFF0F5))),
                const SizedBox(width: 10),
                Expanded(child: _buildCategoryCard('Birds 🦜', '$birdCount', const Color(0xFFE8F5E9))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String title, String count, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black)),
        ],
      ),
    );
  }
}