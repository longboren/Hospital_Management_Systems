import 'dart:convert';
import 'dart:io';
import '../../domain/entities/prescription.dart';
import '../../domain/repositories/interfaces.dart';

class PrescriptionRepository implements IPrescriptionRepository {
  final Map<String, Prescription> _prescriptionStorage = {};
  final String _filePath = 'data/prescriptions.json';

  PrescriptionRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final prescription = _fromJson(jsonItem);
          _prescriptionStorage[prescription.id] = prescription;
        }
      }
    } catch (e) {
      print('Error loading prescription data: $e');
    }
  }

  Medication _medicationFromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      notes: json['notes'],
      cost: (json['cost'] as num).toDouble(),
      isValid: json['isValid'] ?? true,
    );
  }

  Map<String, dynamic> _medicationToJson(Medication medication) {
    return {
      'name': medication.name,
      'dosage': medication.dosage,
      'frequency': medication.frequency,
      'notes': medication.notes,
      'cost': medication.cost,
      'isValid': medication.isValid,
    };
  }

  Prescription _fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      issueDate: DateTime.parse(json['issueDate']),
      diagnosis: json['diagnosis'],
      items: (json['items'] as List)
          .map((itemJson) => _medicationFromJson(itemJson))
          .toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
      instructions: json['instructions'],
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'])
          : null,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> _toJson(Prescription prescription) {
    return {
      'id': prescription.id,
      'patientId': prescription.patientId,
      'doctorId': prescription.doctorId,
      'issueDate': prescription.issueDate.toIso8601String(),
      'diagnosis': prescription.diagnosis,
      'items': prescription.items.map((m) => _medicationToJson(m)).toList(),
      'totalCost': prescription.totalCost,
      'instructions': prescription.instructions,
      'followUpDate': prescription.followUpDate?.toIso8601String(),
      'isFilled': prescription.isFilled,
      'isValid': prescription.isValid,
      'notes': prescription.notes,
    };
  }

  @override
  Future<void> addPrescription(Prescription prescription) async {
    if (_prescriptionStorage.containsKey(prescription.id)) {
      throw Exception('Prescription with ID ${prescription.id} already exists');
    }
    _prescriptionStorage[prescription.id] = prescription;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList = _prescriptionStorage.values
          .map((prescription) => _toJson(prescription))
          .toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving prescription data: $e');
    }
  }

  @override
  Future<Prescription?> getPrescriptionById(String id) async {
    return _prescriptionStorage[id];
  }

  @override
  Future<List<Prescription>> getPrescriptionsByPatient(String patientId) async {
    return _prescriptionStorage.values
        .where((prescription) => prescription.patientId == patientId)
        .toList();
  }

  @override
  Future<List<Prescription>> getActivePrescriptions(String patientId) async {
    final prescriptions = await getPrescriptionsByPatient(patientId);
    return prescriptions.where((prescription) => prescription.isValid).toList();
  }

  @override
  Future<void> updatePrescription(Prescription prescription) async {
    if (!_prescriptionStorage.containsKey(prescription.id)) {
      throw Exception('Prescription with ID ${prescription.id} not found');
    }
    _prescriptionStorage[prescription.id] = prescription;
  }

  @override
  Future<List<Prescription>> getPrescriptionsByDoctor(String doctorId) async {
    return _prescriptionStorage.values
        .where((prescription) => prescription.doctorId == doctorId)
        .toList();
  }

  // Method clear all data (useful for testing)
  Future<void> clearAll() async {
    _prescriptionStorage.clear();
    await _saveData();
  }
}
