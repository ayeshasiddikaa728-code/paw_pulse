# 🐾 PawPulse — Pet Care & Health Tracker

**PawPulse** is a cute, baby-pink-themed Flutter mobile application designed to help pet parents effortlessly manage their furry and feathered friends' profiles, track their weight and health status, and organize daily care routines offline.

---

## ✨ Key Features (Phase 2)

* 🌸 **Aesthetic Baby Pink UI:** Built with Material 3, custom pastel pink color palettes, soft shadows, and cute cat/dog watermark cards.
* 🐶 **Complete Pet CRUD Management:** Easily add, view, edit, and delete pet profiles using smooth modal bottom sheets.
* 💚 **Automatic Health Status Badges:** Calculates and displays real-time health indicators (`Healthy 💚`, `Underweight 💛`, `Overweight 🧡`) based on pet category and weight.
* 📊 **Dynamic Dashboard Stats:** Interactive overview displaying pet category breakdowns (Dogs, Cats, Birds) and an **Upcoming Birthday Banner 🎂**.
* 🔍 **Instant Search & Category Filters:** Quickly search pets by name or breed, or filter them using interactive category chips (`All`, `Dogs`, `Cats`, `Birds`, `Others`).
* 💖 **Favorites & Undo Delete:** Pin favorite pets to the top of the list with a heart toggle, and recover accidentally deleted pets via an instant `UNDO` SnackBar.
* 💾 **Offline Persistence:** All pet records and preferences are securely cached locally using `SharedPreferences`.

---

## 📸 Screenshots

| Dashboard & Stats | Pet Profiles & Health Badges | Add / Edit Pet Form |
| :---: | :---: | :---: |
| ![Dashboard](screenshots/dashboard.png) | ![Pets List](screenshots/pets_list.png) | ![Add Pet Form](screenshots/add_pet.png) |

*(Tip: Create a `screenshots` folder in your project root, add your app screenshots there, and match the filenames above to display them automatically!)*

---

## 🛠️ Tech Stack & Architecture

* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **Local Storage:** SharedPreferences
* **Design System:** Material 3 (Custom Baby Pink Theme)

### 📂 Folder Structure
```text
lib/
├── main.dart                  # App entry point & Provider setup
├── models/
│   └── pet.dart               # Pet data model, JSON serialization & health logic
├── providers/
│   └── pet_provider.dart      # State management & SharedPreferences persistence
├── screens/
│   ├── main_screen.dart       # Bottom navigation wrapper
│   ├── dashboard_screen.dart  # Category breakdown & birthday card
│   ├── pets_screen.dart       # Pet list, search, filters & CRUD bottom sheet
│   └── reminders_screen.dart  # Upcoming Phase 3 module
└── utils/
    └── app_theme.dart         # Custom baby pink theme & styling constants
