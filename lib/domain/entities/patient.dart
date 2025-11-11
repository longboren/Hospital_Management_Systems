class Patient {
  final String _id;
  final String _name;
  final DateTime _dateOfBirth;
  final String _gender;
  final String _address;
  final String _phoneNumber;
  final String _email;
  final String? _emergencyPhone;
  final String _bloodType;
  final List<String> _medicalHistory;
  final List<String> _appointmentIds;
  final List<String> _prescriptionIds;
  final List<String> _allergies;
  final List<String> _medicalConditions;
  final DateTime _createdAt;

  Patient({
    required String id,
    required String name,
    required DateTime dateOfBirth,
    required String gender,
    required String address,
    required String phoneNumber,
    required String email,
    String? emergencyPhone,
    required String bloodType,
    List<String>? medicalHistory,
    List<String>? allergies,
    List<String>? medicalConditions,
  })  : _id = id,
        _name = name,
        _dateOfBirth = dateOfBirth,
        _gender = gender,
        _address = address,
        _phoneNumber = phoneNumber,
        _email = email,
        _emergencyPhone = emergencyPhone,
        _bloodType = bloodType,
        _medicalHistory = medicalHistory ?? [],
        _appointmentIds = [],
        _prescriptionIds = [],
        _allergies = allergies ?? [],
        _medicalConditions = medicalConditions ?? [],
        _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  DateTime get dateOfBirth => _dateOfBirth;
  String get gender => _gender;
  String get address => _address;
  String get phoneNumber => _phoneNumber;
  String get email => _email;
  String? get emergencyPhone => _emergencyPhone;
  String get bloodType => _bloodType;
  List<String> get medicalHistory => List.unmodifiable(_medicalHistory);
  List<String> get appointmentIds => List.unmodifiable(_appointmentIds);
  List<String> get prescriptionIds => List.unmodifiable(_prescriptionIds);
  List<String> get allergies => List.unmodifiable(_allergies);
  List<String> get medicalConditions => List.unmodifiable(_medicalConditions);
  DateTime get createdAt => _createdAt;
  int get age {
    final now = DateTime.now();
    int age = now.year - _dateOfBirth.year;
    if (now.month < _dateOfBirth.month ||
        (now.month == _dateOfBirth.month && now.day < _dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  void addMedicalHistory(String history) {
    _medicalHistory.add(history);
  }

  void addAppointment(String appointmentId) {
    _appointmentIds.add(appointmentId);
  }

  void removeAppointment(String appointmentId) {
    _appointmentIds.remove(appointmentId);
  }

  void addPrescription(String prescriptionId) {
    _prescriptionIds.add(prescriptionId);
  }

  void addAllergy(String allergy) {
    _allergies.add(allergy);
  }

  void addMedicalCondition(String condition) {
    _medicalConditions.add(condition);
  }
}
