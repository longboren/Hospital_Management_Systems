# Architecture Best Practices

## ✅ Separation of Concerns: Domain vs Data Layer

### 🎯 **The Problem We Fixed**

Previously, our domain entities (like `Staff`, `Patient`, `Appointment`) had `toJson()` and `fromJson()` methods. This violated the **Separation of Concerns** principle.

### 🏗️ **Clean Architecture Layers**

```
┌─────────────────────────────────────────┐
│         UI Layer (console_ui.dart)       │
│  - User interaction                      │
│  - Display logic                         │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│   Service Layer (hospital_service.dart)  │
│  - Business logic coordination           │
│  - Use cases                             │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│   Domain Layer (entities, interfaces)    │
│  ✅ Pure business objects                │
│  ✅ No serialization                     │
│  ✅ Framework-agnostic                   │
│  ✅ Independent of storage               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│   Data Layer (repositories)              │
│  ✅ JSON serialization/deserialization   │
│  ✅ File I/O operations                  │
│  ✅ Data mapping                         │
│  ✅ Storage implementation               │
└──────────────────────────────────────────┘
```

---

## 📁 **File Organization**

### **Domain Layer** (`lib/domain/`)
**Purpose**: Define business rules and entities

**What belongs here:**
- ✅ Entity classes with business logic
- ✅ Getters and computed properties
- ✅ Business methods (e.g., `assignPatient()`, `addAppointment()`)
- ✅ Repository interfaces (contracts)

**What does NOT belong here:**
- ❌ `toJson()` / `fromJson()` methods
- ❌ File I/O
- ❌ Database queries
- ❌ Any framework-specific code

**Example: `staff.dart`**
```dart
class Doctor extends Staff {
  final String specialization;
  final String licenseNumber;
  final List<String> _appointmentIds;
  
  // ✅ Business logic only
  void addAppointment(String appointmentId) {
    _appointmentIds.add(appointmentId);
  }
  
  // ❌ NO toJson() here!
}
```

---

### **Data Layer** (`lib/data/repositories/`)
**Purpose**: Handle data persistence and serialization

**What belongs here:**
- ✅ `_fromJson()` methods - deserialize JSON → Entity
- ✅ `_toJson()` methods - serialize Entity → JSON
- ✅ File reading/writing
- ✅ Data validation before storage
- ✅ Repository implementations

**Example: `staff_repository.dart`**
```dart
class StaffRepository implements IStaffRepository {
  // ✅ Serialization logic in data layer
  Staff _fromJson(Map<String, dynamic> json) {
    switch (json['role']) {
      case 'Doctor':
        return Doctor(
          id: json['id'],
          specialization: json['specialization'],
          // ... parse JSON → Entity
        );
      // ...
    }
  }

  Map<String, dynamic> _toJson(Staff staff) {
    final baseData = {
      'id': staff.id,
      'name': staff.name,
      // ... Entity → JSON
    };

    if (staff is Doctor) {
      return {
        ...baseData,
        'specialization': staff.specialization,
        // ...
      };
    }
    // ...
  }
}
```

---

## 🎁 **Benefits of This Architecture**

### 1. **Testability**
```dart
// ✅ Test domain logic without any data layer
test('Doctor can add appointment', () {
  final doctor = Doctor(id: '1', name: 'Dr. Smith', ...);
  doctor.addAppointment('apt-123');
  expect(doctor.appointmentIds, contains('apt-123'));
});

// ✅ Test serialization separately
test('Repository serializes doctor correctly', () {
  final repo = StaffRepository();
  final json = repo._toJson(doctor);
  expect(json['specialization'], 'Cardiology');
});
```

### 2. **Easy to Swap Storage**
Want to use a database instead of JSON files?
```dart
// Just create a new repository implementation!
class DatabaseStaffRepository implements IStaffRepository {
  @override
  Future<void> addStaff(Staff staff) async {
    // Use SQLite, Hive, Firebase, etc.
    await db.insert('staff', _toJson(staff));
  }
}
```

**No changes needed in:**
- ❌ Domain entities
- ❌ Service layer
- ❌ UI layer

### 3. **Independent Development**
- **Backend team** can work on repositories
- **Business team** can work on domain entities
- **Frontend team** can work on UI
- **No conflicts!**

### 4. **Reusability**
```dart
// ✅ Same domain entities can be used in:
// - Flutter mobile app
// - Web app
// - Desktop app
// - Command-line tool
// - GraphQL API
// - REST API
```

### 5. **Maintainability**
- **Single Responsibility**: Each layer has one job
- **Easy to find bugs**: Serialization issues? Check repositories. Business logic issues? Check domain.
- **Clear dependencies**: Domain ← Data (one direction only)

---

## 📊 **Data Flow**

### **Reading Data** (JSON → UI)
```
┌──────────────┐
│ data/        │  External JSON files
│ staff.json   │
└──────┬───────┘
       │
       │ File I/O
       ▼
┌──────────────────────┐
│ StaffRepository      │  Data Layer
│ _fromJson()          │  Deserializes JSON → Entity
└──────┬───────────────┘
       │
       │ Returns: List<Staff>
       ▼
┌──────────────────────┐
│ HospitalService      │  Service Layer
│ getDoctors()         │  Business logic
└──────┬───────────────┘
       │
       │ Returns: List<Doctor>
       ▼
┌──────────────────────┐
│ ConsoleUI            │  UI Layer
│ Display doctors      │  Presentation
└──────────────────────┘
```

### **Writing Data** (UI → JSON)
```
┌──────────────────────┐
│ ConsoleUI            │  User creates new doctor
│ Create doctor form   │
└──────┬───────────────┘
       │
       │ Doctor entity
       ▼
┌──────────────────────┐
│ HospitalService      │  Validates business rules
│ registerDoctor()     │
└──────┬───────────────┘
       │
       │ Doctor entity
       ▼
┌──────────────────────┐
│ StaffRepository      │  Data Layer
│ _toJson()            │  Serializes Entity → JSON
└──────┬───────────────┘
       │
       │ File I/O
       ▼
┌──────────────┐
│ data/        │  Persisted to file
│ staff.json   │
└──────────────┘
```

---

## 🔍 **Why This Is Professional**

### ❌ **BAD: Domain entities know about JSON**
```dart
// staff.dart (DOMAIN)
class Doctor {
  Map<String, dynamic> toJson() { ... }  // ❌ Couples domain to JSON
}
```

**Problems:**
- Can't reuse `Doctor` in a GraphQL API (expects different format)
- Can't test business logic without JSON dependencies
- Hard to switch from JSON to database
- Violates Single Responsibility Principle

### ✅ **GOOD: Repository handles serialization**
```dart
// staff.dart (DOMAIN)
class Doctor {
  void addAppointment(String id) { ... }  // ✅ Pure business logic
}

// staff_repository.dart (DATA)
class StaffRepository {
  Map<String, dynamic> _toJson(Staff staff) { ... }  // ✅ Data layer concern
}
```

**Benefits:**
- `Doctor` is pure business logic
- Can swap JSON for any storage (database, API, etc.)
- Easy to test
- Follows Clean Architecture principles

---

## 📚 **Summary**

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **Domain** | Business logic, entities, rules | `Staff`, `Patient`, `Appointment` |
| **Data** | Serialization, storage, I/O | `_toJson()`, `_fromJson()`, file operations |
| **Service** | Coordinate use cases | `registerDoctor()`, `scheduleAppointment()` |
| **UI** | User interaction | `ConsoleUI`, display logic |

### **Golden Rule**:
> **Domain entities should never know how they are stored.**  
> **Repositories should handle all storage concerns.**

This is the **professional way** to structure applications! 🎉
