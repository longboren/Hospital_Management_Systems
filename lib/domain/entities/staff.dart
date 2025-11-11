// Base abstract class for all staff members
abstract class Staff {
  final String _id;
  final String _name;
  final String _email;
  final String _phoneNumber;
  final DateTime _joinDate;
  final String _department;

  Staff({
    required String id,
    required String name,
    required String email,
    required String phoneNumber,
    required DateTime joinDate,
    required String department,
  })  : _id = id,
        _name = name,
        _email = email,
        _phoneNumber = phoneNumber,
        _joinDate = joinDate,
        _department = department;

  String get id => _id;
  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  DateTime get joinDate => _joinDate;
  String get department => _department;
  String get role;
}

class Doctor extends Staff {
  final String _specialization;
  final String _licenseNumber;
  final List<String> _appointmentIds;
  final List<String> _qualifications;

  Doctor({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required String specialization,
    required String licenseNumber,
    List<String>? qualifications,
  })  : _specialization = specialization,
        _licenseNumber = licenseNumber,
        _appointmentIds = [],
        _qualifications = qualifications ?? [];

  @override
  String get role => 'Doctor';

  String get specialization => _specialization;
  String get licenseNumber => _licenseNumber;
  List<String> get appointmentIds => List.unmodifiable(_appointmentIds);
  List<String> get qualifications => List.unmodifiable(_qualifications);

  void addAppointment(String appointmentId) {
    _appointmentIds.add(appointmentId);
  }

  void removeAppointment(String appointmentId) {
    _appointmentIds.remove(appointmentId);
  }

  void addQualification(String qualification) {
    _qualifications.add(qualification);
  }
}

class Nurse extends Staff {
  final String _ward;
  final String _shift;
  final List<String> _specialties;

  Nurse({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required String ward,
    required String shift,
    List<String>? specialties,
  })  : _ward = ward,
        _shift = shift,
        _specialties = specialties ?? [];

  @override
  String get role => 'Nurse';

  String get ward => _ward;
  String get shift => _shift;
  List<String> get specialties => List.unmodifiable(_specialties);

  void addSpecialty(String specialty) {
    _specialties.add(specialty);
  }
}

class Administrative extends Staff {
  final String _position;
  final List<String> _responsibilities;

  Administrative({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.joinDate,
    required super.department,
    required String position,
    List<String>? responsibilities,
  })  : _position = position,
        _responsibilities = responsibilities ?? [];

  @override
  String get role => 'Administrative';

  String get position => _position;
  List<String> get responsibilities => List.unmodifiable(_responsibilities);

  void addResponsibility(String responsibility) {
    _responsibilities.add(responsibility);
  }
}
