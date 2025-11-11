class Medication {
  final String _name;
  final String _dosage;
  final String _frequency;
  final String? _notes;
  final double _cost;
  final bool _isValid;

  Medication({
    required String name,
    required String dosage,
    required String frequency,
    String? notes,
    required double cost,
    bool isValid = true,
  })  : _name = name,
        _dosage = dosage,
        _frequency = frequency,
        _notes = notes,
        _cost = cost,
        _isValid = isValid;

  String get name => _name;
  String get dosage => _dosage;
  String get frequency => _frequency;
  String? get notes => _notes;
  double get cost => _cost;
  bool get isValid => _isValid;
  String get dosageDescription => '$_dosage, $_frequency';
}

class Prescription {
  final String _id;
  final String _patientId;
  final String _doctorId;
  final DateTime _issueDate;
  final String _diagnosis;
  final List<Medication> _items;
  final double _totalCost;
  final String _instructions;
  final DateTime? _followUpDate;
  final bool _isFilled;
  final String? _notes;

  Prescription({
    required String id,
    required String patientId,
    required String doctorId,
    required DateTime issueDate,
    required String diagnosis,
    required List<Medication> items,
    required double totalCost,
    required String instructions,
    DateTime? followUpDate,
    String? notes,
  })  : _id = id,
        _patientId = patientId,
        _doctorId = doctorId,
        _issueDate = issueDate,
        _diagnosis = diagnosis,
        _items = items,
        _totalCost = totalCost,
        _instructions = instructions,
        _followUpDate = followUpDate,
        _notes = notes,
        _isFilled = false;

  String get id => _id;
  String get patientId => _patientId;
  String get doctorId => _doctorId;
  DateTime get issueDate => _issueDate;
  String get diagnosis => _diagnosis;
  List<Medication> get items => List.unmodifiable(_items);
  double get totalCost => _totalCost;
  String get instructions => _instructions;
  DateTime? get followUpDate => _followUpDate;
  String? get notes => _notes;
  bool get isFilled => _isFilled;

  // Check if prescription is still valid (not expired)
  bool get isValid => _items.every((item) => item.isValid);
}
