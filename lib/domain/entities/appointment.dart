enum AppointmentStatus { scheduled, inProgress, completed, cancelled, noShow }

class Appointment {
  final String _id;
  final String _patientId;
  final String _doctorId;
  final DateTime _scheduledTime;
  final String _reason;
  DateTime? _actualStartTime;
  DateTime? _actualEndTime;
  AppointmentStatus _status;
  String? _notes;
  final String _appointmentType;
  final DateTime _createdAt;
  final String? _roomId;

  Appointment({
    required String id,
    required String patientId,
    required String doctorId,
    required DateTime scheduledTime,
    required String reason,
    AppointmentStatus status = AppointmentStatus.scheduled,
    String? appointmentType,
    String? roomId,
    DateTime? startTime,
    DateTime? endTime,
  })  : _id = id,
        _patientId = patientId,
        _doctorId = doctorId,
        _scheduledTime = scheduledTime,
        _reason = reason,
        _status = status,
        _appointmentType = appointmentType ?? 'General Checkup',
        _roomId = roomId,
        _createdAt = DateTime.now(),
        _actualStartTime = startTime,
        _actualEndTime = endTime;

  String get id => _id;
  String get patientId => _patientId;
  String get doctorId => _doctorId;
  DateTime get scheduledTime => _scheduledTime;
  String get reason => _reason;
  DateTime? get actualStartTime => _actualStartTime;
  DateTime? get actualEndTime => _actualEndTime;
  AppointmentStatus get status => _status;
  String? get notes => _notes;
  String get appointmentType => _appointmentType;
  String? get roomId => _roomId;
  DateTime get createdAt => _createdAt;

  void addNotes(String notes) {
    _notes = notes;
  }

  void startAppointment() {
    if (_status == AppointmentStatus.scheduled) {
      _status = AppointmentStatus.inProgress;
      _actualStartTime = DateTime.now();
    }
  }

  void complete() {
    if (_status == AppointmentStatus.inProgress) {
      _status = AppointmentStatus.completed;
      _actualEndTime = DateTime.now();
    }
  }

  void cancel() {
    _status = AppointmentStatus.cancelled;
  }

  void markAsNoShow() {
    _status = AppointmentStatus.noShow;
  }

  bool get isUpcoming =>
      _status == AppointmentStatus.scheduled &&
      _scheduledTime.isAfter(DateTime.now());

  bool get isPast => _scheduledTime.isBefore(DateTime.now());

  Duration? get duration {
    if (_actualStartTime == null || _actualEndTime == null) return null;
    return _actualEndTime!.difference(_actualStartTime!);
  }

  bool get isInProgress => _status == AppointmentStatus.inProgress;

  bool get canStart =>
      _status == AppointmentStatus.scheduled &&
      _scheduledTime.isBefore(DateTime.now().add(Duration(minutes: 30))) &&
      _scheduledTime.isAfter(DateTime.now().subtract(Duration(hours: 1)));

  @override
  String toString() {
    return 'Appointment{id: $_id, patientId: $_patientId, doctorId: $_doctorId, '
        'scheduled: $_scheduledTime, status: $_status, type: $_appointmentType}';
  }
}
