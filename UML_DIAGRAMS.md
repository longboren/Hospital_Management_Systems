# Hospital Management System - UML Diagrams
**Clean Architecture Implementation with Private Encapsulation**

## 1. Class Diagram - Domain Entities

```mermaid
classDiagram
    %% Staff Hierarchy (Domain Entities - Pure Business Logic)
    class Staff {
        <<abstract>>
        -String _id
        -String _name
        -String _email
        -String _phoneNumber
        -DateTime _joinDate
        -String _department
        +String id
        +String name
        +String email
        +String phoneNumber
        +DateTime joinDate
        +String department
        +String role*
    }
    
    class Doctor {
        -String _specialization
        -String _licenseNumber
        -List~String~ _appointmentIds
        -List~String~ _qualifications
        +String specialization
        +String licenseNumber
        +List~String~ appointmentIds
        +List~String~ qualifications
        +String role
        +addAppointment(appointmentId) void
        +removeAppointment(appointmentId) void
        +addQualification(qualification) void
    }
    
    class Nurse {
        -String _ward
        -String _shift
        -List~String~ _specialties
        +String ward
        +String shift
        +List~String~ specialties
        +String role
        +addSpecialty(specialty) void
    }
    
    class Administrative {
        -String _position
        -List~String~ _responsibilities
        +String position
        +List~String~ responsibilities
        +String role
        +addResponsibility(responsibility) void
    }
    
    Staff <|-- Doctor
    Staff <|-- Nurse
    Staff <|-- Administrative
    
    %% Patient Entity
    class Patient {
        -String _id
        -String _name
        -DateTime _dateOfBirth
        -String _gender
        -String _address
        -String _phoneNumber
        -String _email
        -String? _emergencyPhone
        -String _bloodType
        -List~String~ _medicalHistory
        -List~String~ _appointmentIds
        -List~String~ _prescriptionIds
        -List~String~ _allergies
        -List~String~ _medicalConditions
        -DateTime _createdAt
        +String id
        +String name
        +DateTime dateOfBirth
        +String gender
        +String address
        +String phoneNumber
        +String email
        +String? emergencyPhone
        +String bloodType
        +List~String~ medicalHistory
        +List~String~ appointmentIds
        +List~String~ prescriptionIds
        +List~String~ allergies
        +List~String~ medicalConditions
        +DateTime createdAt
        +int age
        +addMedicalHistory(history) void
        +addAppointment(appointmentId) void
        +removeAppointment(appointmentId) void
        +addPrescription(prescriptionId) void
        +addAllergy(allergy) void
        +addMedicalCondition(condition) void
    }
    
    %% Room & Bed Entities
    class Room {
        -String _id
        -String _number
        -RoomType _type
        -int _capacity
        -double _pricePerDay
        -List~String~ _equipment
        -List~Bed~ _beds
        +String id
        +String number
        +RoomType type
        +int capacity
        +double pricePerDay
        +List~Bed~ beds
        +List~String~ equipment
        +int availableBedsCount
        +int occupiedBedsCount
        +int maintenanceBedsCount
        +getAvailableBed() Bed?
        +addEquipment(item) void
        +removeEquipment(item) void
    }
    
    class Bed {
        -String _id
        -String _roomId
        -int _bedNumber
        -BedStatus _status
        -String? _patientId
        -DateTime? _assignedDate
        -DateTime? _dischargeDate
        +String id
        +String roomId
        +int bedNumber
        +BedStatus status
        +String? patientId
        +DateTime? assignedDate
        +DateTime? dischargeDate
        +Duration? occupancyDuration
        +assignPatient(patientId) void
        +dischargePatient() void
        +setMaintenance() void
        +statusInternal BedStatus
        +patientIdInternal String?
        +assignedDateInternal DateTime?
        +dischargeDateInternal DateTime?
    }
    
    class RoomType {
        <<enumeration>>
        generalWard
        privateRoom
        icu
        emergency
        operatingRoom
        consultationRoom
        maternity
        +String displayName
    }
    
    class BedStatus {
        <<enumeration>>
        available
        occupied
        maintenance
    }
    
    Room "1" *-- "many" Bed : contains
    Room --> RoomType
    Bed --> BedStatus
    Bed ..> Patient : assigned to
    
    %% Appointment Entity
    class Appointment {
        -String _id
        -String _patientId
        -String _doctorId
        -DateTime _scheduledTime
        -String _reason
        -DateTime? _actualStartTime
        -DateTime? _actualEndTime
        -AppointmentStatus _status
        -String? _notes
        -String _appointmentType
        -DateTime _createdAt
        -String? _roomId
        +String id
        +String patientId
        +String doctorId
        +DateTime scheduledTime
        +String reason
        +DateTime? actualStartTime
        +DateTime? actualEndTime
        +AppointmentStatus status
        +String? notes
        +String appointmentType
        +DateTime createdAt
        +String? roomId
        +bool isUpcoming
        +bool isPast
        +bool isInProgress
        +bool canStart
        +Duration? duration
        +addNotes(notes) void
        +startAppointment() void
        +complete() void
        +cancel() void
        +markAsNoShow() void
    }
    
    class AppointmentStatus {
        <<enumeration>>
        scheduled
        inProgress
        completed
        cancelled
        noShow
    }
    
    Appointment --> AppointmentStatus
    Appointment ..> Patient : for
    Appointment ..> Doctor : with
    Appointment ..> Room : in
    
    %% Prescription & Medication Entities
    class Prescription {
        -String _id
        -String _patientId
        -String _doctorId
        -DateTime _issueDate
        -String _diagnosis
        -List~Medication~ _items
        -double _totalCost
        -String _instructions
        -DateTime? _followUpDate
        -bool _isFilled
        -String? _notes
        +String id
        +String patientId
        +String doctorId
        +DateTime issueDate
        +String diagnosis
        +List~Medication~ items
        +double totalCost
        +String instructions
        +DateTime? followUpDate
        +bool isFilled
        +String? notes
        +bool isValid
    }
    
    class Medication {
        -String _name
        -String _dosage
        -String _frequency
        -String? _notes
        -double _cost
        -bool _isValid
        +String name
        +String dosage
        +String frequency
        +String? notes
        +double cost
        +bool isValid
        +String dosageDescription
    }
    
    Prescription "1" *-- "many" Medication : contains
    Prescription ..> Patient : for
    Prescription ..> Doctor : by
```

## 2. Class Diagram - Repository Interfaces & Implementations

```mermaid
classDiagram
    %% Repository Interfaces (Domain Layer)
    class IStaffRepository {
        <<interface>>
        +addStaff(staff) Future~void~
        +getStaffById(id) Future~Staff?~
        +getStaffByRole(role) Future~List~Staff~~
        +getAllStaff() Future~List~Staff~~
        +updateStaff(staff) Future~void~
        +deleteStaff(id) Future~bool~
    }
    
    class IPatientRepository {
        <<interface>>
        +addPatient(patient) Future~void~
        +getPatientById(id) Future~Patient?~
        +getAllPatients() Future~List~Patient~~
        +updatePatient(patient) Future~void~
        +deletePatient(id) Future~bool~
        +searchPatients(query) Future~List~Patient~~
    }
    
    class IRoomRepository {
        <<interface>>
        +addRoom(room) Future~void~
        +getRoomById(id) Future~Room?~
        +getRoomsByType(type) Future~List~Room~~
        +getAllRooms() Future~List~Room~~
        +updateRoom(room) Future~void~
        +getAvailableRooms() Future~List~Room~~
    }
    
    class IAppointmentRepository {
        <<interface>>
        +scheduleAppointment(appointment) Future~void~
        +getAppointmentById(id) Future~Appointment?~
        +getAppointmentsByPatient(patientId) Future~List~Appointment~~
        +getAppointmentsByDoctor(doctorId) Future~List~Appointment~~
        +getUpcomingAppointments() Future~List~Appointment~~
        +getAppointmentsByDate(date) Future~List~Appointment~~
        +updateAppointment(appointment) Future~void~
        +cancelAppointment(id) Future~bool~
    }
    
    class IPrescriptionRepository {
        <<interface>>
        +addPrescription(prescription) Future~void~
        +getPrescriptionById(id) Future~Prescription?~
        +getPrescriptionsByPatient(patientId) Future~List~Prescription~~
        +getActivePrescriptions(patientId) Future~List~Prescription~~
        +updatePrescription(prescription) Future~void~
        +getPrescriptionsByDoctor(doctorId) Future~List~Prescription~~
    }
    
    %% Concrete Implementations (Data Layer)
    class StaffRepository {
        -Map~String, Staff~ _staffStorage
        -String _filePath
        -bool _isLoaded
        -_loadData() Future~void~
        -_ensureLoaded() Future~void~
        -_fromJson(json) Staff
        -_toJson(staff) Map~String, dynamic~
        -_saveData() Future~void~
        +clearAll() Future~void~
    }
    
    class PatientRepository {
        -Map~String, Patient~ _patientStorage
        -String _filePath
        -bool _isLoaded
        -_loadData() Future~void~
        -_ensureLoaded() Future~void~
        -_fromJson(json) Patient
        -_toJson(patient) Map~String, dynamic~
        -_saveData() Future~void~
        +clearAll() Future~void~
    }
    
    class RoomRepository {
        -Map~String, Room~ _roomStorage
        -String _filePath
        -bool _isLoaded
        -_loadData() Future~void~
        -_ensureLoaded() Future~void~
        -_fromJson(json) Room
        -_toJson(room) Map~String, dynamic~
        -_saveData() Future~void~
        +clearAll() Future~void~
    }
    
    class AppointmentRepository {
        -Map~String, Appointment~ _appointmentStorage
        -String _filePath
        -bool _isLoaded
        -_loadData() Future~void~
        -_ensureLoaded() Future~void~
        -_fromJson(json) Appointment
        -_toJson(appointment) Map~String, dynamic~
        -_saveData() Future~void~
        +clearAll() Future~void~
    }
    
    class PrescriptionRepository {
        -Map~String, Prescription~ _prescriptionStorage
        -String _filePath
        -bool _isLoaded
        -_loadData() Future~void~
        -_ensureLoaded() Future~void~
        -_fromJson(json) Prescription
        -_toJson(prescription) Map~String, dynamic~
        -_saveData() Future~void~
        +clearAll() Future~void~
    }
    
    IStaffRepository <|.. StaffRepository : implements
    IPatientRepository <|.. PatientRepository : implements
    IRoomRepository <|.. RoomRepository : implements
    IAppointmentRepository <|.. AppointmentRepository : implements
    IPrescriptionRepository <|.. PrescriptionRepository : implements
    
    StaffRepository ..> Staff : serializes
    PatientRepository ..> Patient : serializes
    RoomRepository ..> Room : serializes
    AppointmentRepository ..> Appointment : serializes
    PrescriptionRepository ..> Prescription : serializes
```

## 3. Class Diagram - Hospital Service (Business Logic)

```mermaid
classDiagram
    class HospitalService {
        -IStaffRepository _staffRepository
        -IPatientRepository _patientRepository
        -IRoomRepository _roomRepository
        -IAppointmentRepository _appointmentRepository
        -IPrescriptionRepository _prescriptionRepository
        
        %% Staff Management
        +hireStaff(staff) Future~void~
        +getDoctors() Future~List~Doctor~~
        +getNurses() Future~List~Nurse~~
        +getStaffById(id) Future~Staff?~
        +getAllStaff() Future~List~Staff~~
        
        %% Patient Management
        +admitPatient(patient) Future~void~
        +getPatientById(id) Future~Patient?~
        +getAllPatients() Future~List~Patient~~
        +searchPatients(query) Future~List~Patient~~
        
        %% Room Management
        +addRoom(room) Future~void~
        +assignPatientToBed(patientId, type) Future~Bed?~
        +dischargePatientFromBed(patientId) Future~void~
        +getAvailableRooms() Future~List~Room~~
        +getAllRooms() Future~List~Room~~
        
        %% Appointment Management
        +scheduleAppointment(...) Future~Appointment~
        +startAppointment(id) Future~void~
        +completeAppointment(id, notes) Future~void~
        +getUpcomingAppointments() Future~List~Appointment~~
        +getAppointmentsByDoctor(doctorId) Future~List~Appointment~~
        
        %% Prescription Management
        +createPrescription(...) Future~Prescription~
        +getPatientPrescriptions(patientId) Future~List~Prescription~~
        +getActivePrescriptions(patientId) Future~List~Prescription~~
        
        %% Reports & Analytics
        +getHospitalStats() Future~Map~String, dynamic~~
        +getDoctorPerformance(doctorId) Future~Map~String, dynamic~~
    }
    
    HospitalService --> IStaffRepository : uses
    HospitalService --> IPatientRepository : uses
    HospitalService --> IRoomRepository : uses
    HospitalService --> IAppointmentRepository : uses
    HospitalService --> IPrescriptionRepository : uses
    
    HospitalService ..> Staff : manages
    HospitalService ..> Doctor : manages
    HospitalService ..> Nurse : manages
    HospitalService ..> Patient : manages
    HospitalService ..> Room : manages
    HospitalService ..> Bed : assigns
    HospitalService ..> Appointment : schedules
    HospitalService ..> Prescription : creates
```

## 4. Class Diagram - Console UI Layer

```mermaid
classDiagram
    class ConsoleUI {
        -HospitalService _hospitalService
        
        +run() Future~void~
        
        %% Menu Display
        -_displayMainMenu() void
        -_printWelcomeMessage() void
        -_getUserInput(prompt) String
        
        %% Staff Management
        -_manageStaff() Future~void~
        -_hireDoctor() Future~void~
        -_hireNurse() Future~void~
        -_hireAdministrative() Future~void~
        -_viewAllDoctors() Future~void~
        -_viewAllNurses() Future~void~
        -_searchStaff() Future~void~
        
        %% Patient Management
        -_managePatients() Future~void~
        -_admitNewPatient() Future~void~
        -_viewAllPatients() Future~void~
        -_searchPatient() Future~void~
        -_viewPatientDetails() Future~void~
        -_updatePatientRecord() Future~void~
        
        %% Room Management
        -_manageRooms() Future~void~
        -_addNewRoom() Future~void~
        -_viewAllRooms() Future~void~
        -_viewAvailableRooms() Future~void~
        -_assignBedToPatient() Future~void~
        -_dischargePatient() Future~void~
        
        %% Appointment Management
        -_manageAppointments() Future~void~
        -_scheduleNewAppointment() Future~void~
        -_viewUpcomingAppointments() Future~void~
        -_startAppointment() Future~void~
        -_completeAppointment() Future~void~
        
        %% Prescription Management
        -_managePrescriptions() Future~void~
        -_createNewPrescription() Future~void~
        -_viewPatientPrescriptions() Future~void~
        -_viewActivePrescriptions() Future~void~
        
        %% Reports
        -_viewReports() Future~void~
        -_viewHospitalOverview() Future~void~
        -_viewDoctorPerformance() Future~void~
    }
    
    ConsoleUI --> HospitalService : uses
    ConsoleUI ..> Staff : displays
    ConsoleUI ..> Patient : displays
    ConsoleUI ..> Room : displays
    ConsoleUI ..> Appointment : displays
    ConsoleUI ..> Prescription : displays
```

## 5. Clean Architecture Diagram

```mermaid
graph TB
    subgraph UI["🎨 Presentation Layer (UI)"]
        ConsoleUI[Console UI<br/>- User Interface<br/>- Input/Output Handling<br/>- Display Formatting]
    end
    
    subgraph Service["⚙️ Business Logic Layer (Service)"]
        HospitalService[Hospital Service<br/>- Business Rules<br/>- Workflow Orchestration<br/>- Data Validation<br/>- Transaction Management]
    end
    
    subgraph Domain["🏛️ Domain Layer (Pure Business)"]
        direction LR
        Entities["Domain Entities<br/>Staff, Doctor, Nurse, Administrative<br/>Patient, Room, Bed<br/>Appointment, Prescription<br/>(Private fields, Public getters)"]
        Interfaces["Repository Interfaces<br/>IStaffRepository<br/>IPatientRepository<br/>IRoomRepository<br/>IAppointmentRepository<br/>IPrescriptionRepository"]
    end
    
    subgraph Data["💾 Data Access Layer (Infrastructure)"]
        Repos["Repository Implementations<br/>StaffRepository<br/>PatientRepository<br/>RoomRepository<br/>AppointmentRepository<br/>PrescriptionRepository<br/>(JSON Serialization)"]
    end
    
    subgraph Storage["📁 Data Storage"]
        Files["JSON Files<br/>staff.json<br/>patients.json<br/>rooms.json<br/>appointments.json<br/>prescriptions.json"]
    end
    
    ConsoleUI -->|calls| HospitalService
    HospitalService -->|depends on| Interfaces
    HospitalService -->|uses| Entities
    Interfaces <-.implements.-o Repos
    Repos -->|read/write| Files
    
    style UI fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style Service fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style Domain fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style Data fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style Storage fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    
    classDef cleanCode fill:#c8e6c9,stroke:#2e7d32
    class Entities,Interfaces cleanCode
```

**Key Principles:**
- ✅ **Dependency Rule**: Dependencies point inward (toward domain)
- ✅ **Private Encapsulation**: All entity fields are private with public getters
- ✅ **No JSON in Domain**: Serialization logic is in data layer only
- ✅ **Interface Segregation**: Clear repository interfaces in domain layer

## 6. Sequence Diagram - Schedule Appointment Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as ConsoleUI
    participant Service as HospitalService
    participant PatientRepo as PatientRepository
    participant StaffRepo as StaffRepository
    participant ApptRepo as AppointmentRepository
    
    User->>UI: Select "Schedule Appointment"
    UI->>User: Request patient ID
    User->>UI: Enter patient ID
    
    UI->>Service: getPatientById(patientId)
    Service->>PatientRepo: getPatientById(patientId)
    PatientRepo->>PatientRepo: _ensureLoaded()
    PatientRepo-->>Service: Patient | null
    Service-->>UI: Patient
    
    UI->>User: Display patient info
    UI->>User: Request doctor ID
    User->>UI: Enter doctor ID
    
    UI->>Service: getStaffById(doctorId)
    Service->>StaffRepo: getStaffById(doctorId)
    StaffRepo->>StaffRepo: _ensureLoaded()
    StaffRepo-->>Service: Staff (Doctor)
    Service-->>UI: Doctor
    
    UI->>User: Display doctor info
    UI->>User: Request appointment details<br/>(date, time, reason)
    User->>UI: Enter details
    
    UI->>Service: scheduleAppointment(...)
    activate Service
    
    Service->>PatientRepo: getPatientById(patientId)
    PatientRepo-->>Service: Patient
    
    Service->>StaffRepo: getStaffById(doctorId)
    StaffRepo-->>Service: Doctor
    
    Service->>Service: Validate doctor role
    Service->>Service: Create Appointment object<br/>(id: APT-{timestamp})
    
    Service->>ApptRepo: scheduleAppointment(appointment)
    ApptRepo->>ApptRepo: _appointmentStorage[id] = appointment
    ApptRepo->>ApptRepo: _saveData() to JSON
    ApptRepo-->>Service: void
    
    Service->>Service: patient.addAppointment(id)
    Service->>PatientRepo: updatePatient(patient)
    PatientRepo->>PatientRepo: _saveData() to JSON
    PatientRepo-->>Service: void
    
    Service->>Service: doctor.addAppointment(id)
    Service->>StaffRepo: updateStaff(doctor)
    StaffRepo->>StaffRepo: _saveData() to JSON
    StaffRepo-->>Service: void
    
    Service-->>UI: Appointment
    deactivate Service
    
    UI-->>User: Display success message<br/>with appointment details
```

## 7. Sequence Diagram - View All Doctors Flow

```mermaid
sequenceDiagram
    actor User
    participant UI as ConsoleUI
    participant Service as HospitalService
    participant StaffRepo as StaffRepository
    participant File as staff.json
    
    User->>UI: Select "View All Doctors"
    activate UI
    
    UI->>Service: getDoctors()
    activate Service
    Note over Service: [Service] Getting doctors from repository...
    
    Service->>StaffRepo: getStaffByRole("Doctor")
    activate StaffRepo
    
    StaffRepo->>StaffRepo: _ensureLoaded()
    
    alt Data not loaded yet
        StaffRepo->>File: Read file
        File-->>StaffRepo: JSON string
        StaffRepo->>StaffRepo: json.decode(jsonString)
        loop For each staff member
            StaffRepo->>StaffRepo: _fromJson(jsonItem)
            Note over StaffRepo: Create Doctor/Nurse/Admin<br/>based on role field
            StaffRepo->>StaffRepo: _staffStorage[id] = staff
        end
        StaffRepo->>StaffRepo: _isLoaded = true
    end
    
    StaffRepo->>StaffRepo: Filter by role == "Doctor"
    StaffRepo-->>Service: List<Staff>
    deactivate StaffRepo
    
    Note over Service: [Service] Retrieved X staff with role Doctor
    Service->>Service: whereType<Doctor>()
    Note over Service: [Service] Converted to Y Doctor objects
    
    Service-->>UI: List<Doctor>
    deactivate Service
    
    UI->>UI: Format and display doctors<br/>(name, specialization, license)
    UI-->>User: Show doctor list
    deactivate UI
```

## 8. Use Case Diagram

```mermaid
graph TB
    subgraph Hospital["Hospital Management System"]
        direction TB
        
        subgraph StaffMgmt["Staff Management"]
            UC1[Hire Doctor]
            UC2[Hire Nurse]
            UC3[Hire Administrative]
            UC4[View All Staff]
        end
        
        subgraph PatientMgmt["Patient Management"]
            UC5[Admit Patient]
            UC6[View Patients]
            UC7[Search Patient]
            UC8[Update Patient Record]
        end
        
        subgraph RoomMgmt["Room Management"]
            UC9[Add Room]
            UC10[Assign Bed]
            UC11[Discharge Patient]
            UC12[View Available Rooms]
        end
        
        subgraph ApptMgmt["Appointment Management"]
            UC13[Schedule Appointment]
            UC14[Start Appointment]
            UC15[Complete Appointment]
            UC16[View Upcoming Appointments]
        end
        
        subgraph PrescMgmt["Prescription Management"]
            UC17[Create Prescription]
            UC18[View Prescriptions]
            UC19[View Active Prescriptions]
        end
        
        subgraph Reports["Reports & Analytics"]
            UC20[Hospital Statistics]
            UC21[Doctor Performance]
        end
    end
    
    Admin((Administrator))
    Doctor((Doctor))
    Nurse((Nurse))
    Receptionist((Receptionist))
    
    Admin --> UC1
    Admin --> UC2
    Admin --> UC3
    Admin --> UC4
    Admin --> UC9
    Admin --> UC20
    
    Receptionist --> UC5
    Receptionist --> UC6
    Receptionist --> UC7
    Receptionist --> UC8
    Receptionist --> UC10
    Receptionist --> UC11
    Receptionist --> UC13
    
    Doctor --> UC4
    Doctor --> UC6
    Doctor --> UC14
    Doctor --> UC15
    Doctor --> UC17
    Doctor --> UC21
    
    Nurse --> UC6
    Nurse --> UC10
    Nurse --> UC11
    Nurse --> UC16
    Nurse --> UC18
    
    style StaffMgmt fill:#e1f5ff
    style PatientMgmt fill:#fff3e0
    style RoomMgmt fill:#e8f5e9
    style ApptMgmt fill:#f3e5f5
    style PrescMgmt fill:#fce4ec
    style Reports fill:#fff9c4
```

## 9. Component Diagram

```mermaid
graph TB
    subgraph UI["🎨 UI Layer"]
        ConsoleUI["ConsoleUI<br/>---<br/>• Main menu system<br/>• Input handling<br/>• Output formatting<br/>• User interaction"]
    end
    
    subgraph Service["⚙️ Service Layer"]
        HospitalService["HospitalService<br/>---<br/>• Business logic<br/>• Workflow coordination<br/>• Data validation<br/>• Transaction management"]
    end
    
    subgraph Domain["🏛️ Domain Layer"]
        direction LR
        
        subgraph Entities["Domain Entities"]
            Staff["Staff<br/>Doctor<br/>Nurse<br/>Administrative"]
            Patient["Patient"]
            Room["Room<br/>Bed"]
            Appointment["Appointment"]
            Prescription["Prescription<br/>Medication"]
        end
        
        subgraph Interfaces["Repository Interfaces"]
            IStaffRepo["IStaffRepository"]
            IPatientRepo["IPatientRepository"]
            IRoomRepo["IRoomRepository"]
            IApptRepo["IAppointmentRepository"]
            IPrescRepo["IPrescriptionRepository"]
        end
    end
    
    subgraph Data["💾 Data Layer"]
        direction LR
        StaffRepo["StaffRepository<br/>---<br/>• JSON serialization<br/>• _fromJson()<br/>• _toJson()"]
        PatientRepo["PatientRepository<br/>---<br/>• JSON serialization<br/>• _fromJson()<br/>• _toJson()"]
        RoomRepo["RoomRepository<br/>---<br/>• JSON serialization<br/>• _fromJson()<br/>• _toJson()"]
        ApptRepo["AppointmentRepository<br/>---<br/>• JSON serialization<br/>• _fromJson()<br/>• _toJson()"]
        PrescRepo["PrescriptionRepository<br/>---<br/>• JSON serialization<br/>• _fromJson()<br/>• _toJson()"]
    end
    
    subgraph Storage["📁 Data Storage"]
        StaffJSON["staff.json"]
        PatientJSON["patients.json"]
        RoomJSON["rooms.json"]
        ApptJSON["appointments.json"]
        PrescJSON["prescriptions.json"]
    end
    
    ConsoleUI -->|uses| HospitalService
    
    HospitalService -->|depends on| IStaffRepo
    HospitalService -->|depends on| IPatientRepo
    HospitalService -->|depends on| IRoomRepo
    HospitalService -->|depends on| IApptRepo
    HospitalService -->|depends on| IPrescRepo
    
    HospitalService -.->|uses| Entities
    
    IStaffRepo -.implements.- StaffRepo
    IPatientRepo -.implements.- PatientRepo
    IRoomRepo -.implements.- RoomRepo
    IApptRepo -.implements.- ApptRepo
    IPrescRepo -.implements.- PrescRepo
    
    StaffRepo <-->|read/write| StaffJSON
    PatientRepo <-->|read/write| PatientJSON
    RoomRepo <-->|read/write| RoomJSON
    ApptRepo <-->|read/write| ApptJSON
    PrescRepo <-->|read/write| PrescJSON
    
    style UI fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style Service fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style Domain fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style Data fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style Storage fill:#fce4ec,stroke:#880e4f,stroke-width:2px
```

## 10. State Diagram - Appointment Lifecycle

```mermaid
stateDiagram-v2
    [*] --> scheduled: Create Appointment<br/>(id: APT-{timestamp})
    
    scheduled --> inProgress: startAppointment()<br/>actualStartTime = now
    scheduled --> cancelled: cancel()
    scheduled --> noShow: markAsNoShow()
    
    inProgress --> completed: complete()<br/>actualEndTime = now<br/>calculate duration
    inProgress --> cancelled: cancel()<br/>(emergency)
    
    completed --> [*]
    cancelled --> [*]
    noShow --> [*]
    
    note right of scheduled
        ✓ Patient & doctor assigned
        ✓ Scheduled time set
        ✓ Status: scheduled
        ✓ isUpcoming = true (if future)
    end note
    
    note right of inProgress
        ✓ actualStartTime recorded
        ✓ Doctor with patient
        ✓ Status: inProgress
        ✓ isInProgress = true
    end note
    
    note right of completed
        ✓ actualEndTime recorded
        ✓ Notes added
        ✓ Duration calculated
        ✓ Status: completed
    end note
    
    note left of cancelled
        ✓ Status: cancelled
        ✓ Can be cancelled from<br/>  scheduled or inProgress
    end note
    
    note left of noShow
        ✓ Status: noShow
        ✓ Patient didn't show up
    end note
```

## 11. State Diagram - Bed Status Lifecycle

```mermaid
stateDiagram-v2
    [*] --> available: Room created<br/>Beds initialized
    
    available --> occupied: assignPatient(patientId)<br/>assignedDate = now<br/>status = occupied
    available --> maintenance: setMaintenance()<br/>patientId = null
    
    occupied --> available: dischargePatient()<br/>dischargeDate = now<br/>patientId = null<br/>status = available
    occupied --> maintenance: setMaintenance()<br/>(emergency maintenance)
    
    maintenance --> available: Complete maintenance<br/>status = available
    
    available --> [*]: Room removed
    
    note right of available
        ✓ Ready for assignment
        ✓ patientId = null
        ✓ status = available
        ✓ Can be assigned
    end note
    
    note right of occupied
        ✓ Patient assigned
        ✓ assignedDate recorded
        ✓ status = occupied
        ✓ Billing active
        ✓ occupancyDuration calculated
    end note
    
    note right of maintenance
        ✓ Under repair/cleaning
        ✓ patientId = null
        ✓ status = maintenance
        ✓ Cannot be assigned
        ✓ Throws StateError if<br/>  assignment attempted
    end note
```

## 12. Deployment Diagram

```mermaid
graph TB
    subgraph UserMachine["💻 User Machine (Development/Production)"]
        Terminal["🖥️ Terminal/Console<br/>---<br/>• ZSH Shell<br/>• User I/O Interface"]
        
        DartVM["⚡ Dart VM<br/>---<br/>• Dart Runtime<br/>• Async Event Loop<br/>• Memory Management"]
        
        subgraph Application["📦 Hospital Management System"]
            direction TB
            BinDir["bin/<br/>hospital_management_system.dart"]
            LibDir["lib/<br/>---<br/>• domain/<br/>• data/<br/>• ui/"]
        end
        
        subgraph FileSystem["📂 File System"]
            DataDir["data/ directory<br/>---<br/>JSON Storage"]
            
            subgraph JSONFiles["JSON Files"]
                StaffFile["📄 staff.json<br/>(6 staff members)"]
                PatientFile["📄 patients.json"]
                RoomFile["📄 rooms.json<br/>(1 general ward)"]
                ApptFile["📄 appointments.json"]
                PrescFile["📄 prescriptions.json"]
            end
        end
    end
    
    Terminal -->|executes| DartVM
    DartVM -->|runs| BinDir
    BinDir -->|imports| LibDir
    
    LibDir <-->|read/write<br/>async I/O| DataDir
    DataDir --> JSONFiles
    
    StaffFile -.->|loaded into| StaffRepo[StaffRepository<br/>Memory Cache]
    PatientFile -.->|loaded into| PatientRepo[PatientRepository<br/>Memory Cache]
    RoomFile -.->|loaded into| RoomRepo[RoomRepository<br/>Memory Cache]
    ApptFile -.->|loaded into| ApptRepo[AppointmentRepository<br/>Memory Cache]
    PrescFile -.->|loaded into| PrescRepo[PrescriptionRepository<br/>Memory Cache]
    
    style UserMachine fill:#e3f2fd,stroke:#1565c0,stroke-width:3px
    style Terminal fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    style DartVM fill:#fff3e0,stroke:#e65100,stroke-width:2px
    style Application fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    style FileSystem fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    style JSONFiles fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    
    style StaffRepo fill:#c8e6c9
    style PatientRepo fill:#c8e6c9
    style RoomRepo fill:#c8e6c9
    style ApptRepo fill:#c8e6c9
    style PrescRepo fill:#c8e6c9
```

**Deployment Notes:**
- **Platform**: Cross-platform (Linux, macOS, Windows)
- **Runtime**: Dart VM (async/await support)
- **Storage**: File-based JSON persistence
- **Architecture**: Single-process console application
- **Data Access**: Async I/O with in-memory caching
- **Startup**: Repositories auto-load data from JSON files

---

## Summary

### Architecture Highlights

✅ **Clean Architecture Compliance**
- Clear separation of concerns across 4 layers
- Dependencies point inward (toward domain)
- Business logic isolated from infrastructure

✅ **Encapsulation Excellence**
- All 53 entity attributes are private with public getters
- No direct field modification from outside
- Controlled state changes through methods

✅ **Domain-Driven Design**
- Rich domain models with business behavior
- Repository interfaces in domain layer
- No framework dependencies in domain

✅ **SOLID Principles**
- **S**ingle Responsibility: Each class has one reason to change
- **O**pen/Closed: Open for extension via inheritance (Staff hierarchy)
- **L**iskov Substitution: Doctor, Nurse, Admin are substitutable for Staff
- **I**nterface Segregation: Focused repository interfaces
- **D**ependency Inversion: Service depends on abstractions, not implementations

### Key Design Patterns

1. **Repository Pattern**: Data access abstraction
2. **Dependency Injection**: Repositories injected into service
3. **Factory Method**: Entity creation from JSON in repositories
4. **Template Method**: Common repository operations
5. **Strategy Pattern**: Different staff types with same interface

### Data Flow

```
User Input → ConsoleUI → HospitalService → Repository Interface → Repository Implementation → JSON File
          ←            ←                  ←                      ←                         ←
```

### Technology Stack

- **Language**: Dart 3.x
- **Paradigm**: Object-Oriented Programming with Async/Await
- **Persistence**: JSON file storage
- **Architecture**: Clean Architecture + DDD
- **UI**: Console-based (Terminal)
- **Testing**: `package:test` with unit and integration tests

---

**Document Version**: 2.0  
**Last Updated**: 2025-11-11  
**Project**: Hospital Management System  
**Architecture**: Clean Architecture with Private Encapsulation

