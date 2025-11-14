import 'dart:convert';
import 'dart:io';
import '../../domain/entities/appointment.dart';
import '../../domain/repositories/interfaces.dart';

class AppointmentRepository implements IAppointmentRepository {
  final Map<String, Appointment> _appointmentStorage = {};
  final String _filePath = 'data/appointments.json';

  AppointmentRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      print('📁 Loading appointments from: ${file.absolute.path}');
      
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        print('📄 File content length: ${jsonString.length} characters');
        
        final List<dynamic> jsonList = json.decode(jsonString);
        print('📋 Found ${jsonList.length} appointments in JSON');
        
        for (var jsonItem in jsonList) {
          final appointment = _fromJson(jsonItem);
          _appointmentStorage[appointment.id] = appointment;
        }
        print('✅ Loaded ${_appointmentStorage.length} appointments into storage');
      } else {
        print('❌ File does not exist: ${file.absolute.path}');
      }
    } catch (e) {
      print('Error loading appointment data: $e');
    }
  }

  Appointment _fromJson(Map<String, dynamic> json) {
    // Handle both 'dateTime' and 'scheduledTime' field names
    final String? dateTimeStr = json['dateTime'] as String? ?? json['scheduledTime'] as String?;
    if (dateTimeStr == null) {
      throw Exception('Appointment must have a dateTime or scheduledTime field');
    }
    
    final appointment = Appointment(
      id: json['id'] as String? ?? '',
      patientId: json['patientId'] as String? ?? '',
      doctorId: json['doctorId'] as String? ?? '',
      scheduledTime: DateTime.parse(dateTimeStr),
      reason: json['reason'] as String? ?? '',
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == (json['status'] as String? ?? 'scheduled'),
        orElse: () => AppointmentStatus.scheduled,
      ),
      appointmentType: json['appointmentType'] as String? ?? 'General Checkup',
      roomId: json['roomId'] as String?,
      startTime: json['actualStartTime'] != null
          ? DateTime.parse(json['actualStartTime'] as String)
          : null,
      endTime: json['actualEndTime'] != null
          ? DateTime.parse(json['actualEndTime'] as String)
          : null,
    );
    
    // Add notes if present in JSON
    if (json['notes'] != null && json['notes'] != '') {
      appointment.addNotes(json['notes'] as String);
    }
    
    return appointment;
  }

  Map<String, dynamic> _toJson(Appointment appointment) {
    return {
      'id': appointment.id,
      'patientId': appointment.patientId,
      'doctorId': appointment.doctorId,
      'dateTime': appointment.scheduledTime.toIso8601String(),
      'reason': appointment.reason,
      'status': appointment.status.name,
      'notes': appointment.notes ?? '',
      'appointmentType': appointment.appointmentType,
      'roomId': appointment.roomId,
      'actualStartTime': appointment.actualStartTime?.toIso8601String(),
      'actualEndTime': appointment.actualEndTime?.toIso8601String(),
      'duration': appointment.duration?.inMinutes ?? 30,
    };
  }

  @override
  Future<void> scheduleAppointment(Appointment appointment) async {
    if (_appointmentStorage.containsKey(appointment.id)) {
      throw Exception('Appointment with ID ${appointment.id} already exists');
    }
    _appointmentStorage[appointment.id] = appointment;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList = _appointmentStorage.values
          .map((appointment) => _toJson(appointment))
          .toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving appointment data: $e');
    }
  }

  @override
  Future<Appointment?> getAppointmentById(String id) async {
    return _appointmentStorage[id];
  }

  @override
  Future<List<Appointment>> getAppointmentsByPatient(String patientId) async {
    return _appointmentStorage.values
        .where((appointment) => appointment.patientId == patientId)
        .toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDoctor(String doctorId) async {
    return _appointmentStorage.values
        .where((appointment) => appointment.doctorId == doctorId)
        .toList();
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    return _appointmentStorage.values.where((a) => a.isUpcoming).toList();
  }
  
  // Get all appointments regardless of status
  Future<List<Appointment>> getAllAppointments() async {
    return _appointmentStorage.values.toList();
  }

  @override
  Future<List<Appointment>> getAppointmentsByDate(DateTime date) async {
    return _appointmentStorage.values.where((appointment) {
      return appointment.scheduledTime.year == date.year &&
          appointment.scheduledTime.month == date.month &&
          appointment.scheduledTime.day == date.day;
    }).toList();
  }

  @override
  Future<void> updateAppointment(Appointment appointment) async {
    if (!_appointmentStorage.containsKey(appointment.id)) {
      throw Exception('Appointment with ID ${appointment.id} not found');
    }
    _appointmentStorage[appointment.id] = appointment;
  }

  @override
  Future<bool> cancelAppointment(String id) async {
    final appointment = _appointmentStorage[id];
    if (appointment != null) {
      appointment.cancel();
      await _saveData();
      return true;
    }
    return false;
  }

  // Method clear all data useful for testing
  Future<void> clearAll() async {
    _appointmentStorage.clear();
    await _saveData();
  }
}
