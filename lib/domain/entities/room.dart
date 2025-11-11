enum RoomType {
  generalWard('General Ward'),
  privateRoom('Private Room'),
  icu('ICU'),
  emergency('Emergency'),
  operatingRoom('Operating Room'),
  consultationRoom('Consultation Room'),
  maternity('Maternity Ward');

  const RoomType(this.displayName);
  final String displayName;
}

class Room {
  final String _id;
  final String _number;
  final RoomType _type;
  final int _capacity;
  final double _pricePerDay;
  final List<String> _equipment;
  final List<Bed> _beds;

  Room({
    required String id,
    required String number,
    required RoomType type,
    required int capacity,
    required double pricePerDay,
    List<String>? equipment,
  })  : _id = id,
        _number = number,
        _type = type,
        _capacity = capacity,
        _pricePerDay = pricePerDay,
        _equipment = equipment ?? [],
        _beds = [] {
    for (int i = 1; i <= capacity; i++) {
      _beds.add(
        Bed(
          id: '$id-B${i.toString().padLeft(2, '0')}',
          roomId: id,
          bedNumber: i,
        ),
      );
    }
  }

  String get id => _id;
  String get number => _number;
  RoomType get type => _type;
  int get capacity => _capacity;
  double get pricePerDay => _pricePerDay;
  List<Bed> get beds => List.unmodifiable(_beds);
  List<String> get equipment => List.unmodifiable(_equipment);

  int get availableBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.available).length;

  int get occupiedBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.occupied).length;

  int get maintenanceBedsCount =>
      _beds.where((bed) => bed.status == BedStatus.maintenance).length;

  Bed? getAvailableBed() {
    try {
      return _beds.firstWhere((bed) => bed.status == BedStatus.available);
    } catch (e) {
      return null;
    }
  }

  void addEquipment(String item) {
    if (!_equipment.contains(item)) {
      _equipment.add(item);
    }
  }

  void removeEquipment(String item) {
    _equipment.remove(item);
  }
}

enum BedStatus { available, occupied, maintenance }

class Bed {
  final String _id;
  final String _roomId;
  final int _bedNumber;
  BedStatus _status;
  String? _patientId;
  DateTime? _assignedDate;
  DateTime? _dischargeDate;

  Bed({
    required String id,
    required String roomId,
    required int bedNumber,
    BedStatus status = BedStatus.available,
  })  : _id = id,
        _roomId = roomId,
        _bedNumber = bedNumber,
        _status = status;

  String get id => _id;
  String get roomId => _roomId;
  int get bedNumber => _bedNumber;
  BedStatus get status => _status;
  String? get patientId => _patientId;
  DateTime? get assignedDate => _assignedDate;
  DateTime? get dischargeDate => _dischargeDate;

  // Internal setter for repository use only (during deserialization)
  set statusInternal(BedStatus value) => _status = value;
  set patientIdInternal(String? value) => _patientId = value;
  set assignedDateInternal(DateTime? value) => _assignedDate = value;
  set dischargeDateInternal(DateTime? value) => _dischargeDate = value;

  void assignPatient(String patientId) {
    if (_status != BedStatus.available) {
      throw StateError('Bed is not available for assignment');
    }
    _patientId = patientId;
    _assignedDate = DateTime.now();
    _status = BedStatus.occupied;
  }

  void dischargePatient() {
    _patientId = null;
    _dischargeDate = DateTime.now();
    _status = BedStatus.available;
  }

  void setMaintenance() {
    _patientId = null;
    _assignedDate = null;
    _status = BedStatus.maintenance;
  }

  Duration? get occupancyDuration {
    if (_assignedDate == null) return null;
    final endDate = _dischargeDate ?? DateTime.now();
    return endDate.difference(_assignedDate!);
  }
}
