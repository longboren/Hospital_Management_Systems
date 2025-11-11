import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/domain/entities/appointment.dart';
import 'package:hospital_management_system/domain/entities/prescription.dart';

void main() {
  group('Domain Entities Tests', () {
    test('Staff creation - Doctor, Nurse, Admin', () {
      final doctor = Doctor(
        id: 'D001',
        name: 'Dr. Sok Virak',
        email: 'sok.virak@hospital.com',
        phoneNumber: '+855-12-345-678',
        joinDate: DateTime(2020, 1, 1),
        department: 'Cardiology',
        specialization: 'Heart Surgery',
        licenseNumber: 'LIC123',
      );

      final nurse = Nurse(
        id: 'N001',
        name: 'Nhean Sreypov',
        email: 'nhean.sreypov@hospital.com',
        phoneNumber: '+855-12-345-679',
        joinDate: DateTime(2021, 1, 1),
        department: 'Emergency',
        ward: 'ER',
        shift: 'Night',
      );

      final admin = Administrative(
        id: 'A001',
        name: 'Chea Dara',
        email: 'chea.dara@hospital.com',
        phoneNumber: '+855-12-345-680',
        joinDate: DateTime(2019, 1, 1),
        department: 'Administration',
        position: 'Manager',
      );

      expect(doctor.role, 'Doctor');
      expect(nurse.role, 'Nurse');
      expect(admin.role, 'Administrative');
    });

    test('Patient age calculation and medical records', () {
      final patient = Patient(
        id: 'P001',
        name: 'Srey Mao',
        dateOfBirth: DateTime(1990, 6, 15),
        gender: 'Female',
        address: 'St. 271, Phnom Penh',
        phoneNumber: '+855-23-456-789',
        email: 'srey.mao@email.com',
        bloodType: 'O+',
        allergies: ['Penicillin'],
      );

      expect(patient.age, greaterThanOrEqualTo(30));
      patient.addAllergy('Latex');
      expect(patient.allergies.length, 2);
    });

    test('Room and bed management', () {
      final room = Room(
        id: 'R001',
        number: '101',
        type: RoomType.privateRoom,
        capacity: 2,
        pricePerDay: 250.0,
      );

      expect(room.availableBedsCount, 2);

      final bed = room.getAvailableBed();
      bed!.assignPatient('P001');
      expect(room.availableBedsCount, 1);
      expect(bed.status, BedStatus.occupied);

      bed.dischargePatient();
      expect(room.availableBedsCount, 2);
    });

    test('Appointment lifecycle', () {
      final appointment = Appointment(
        id: 'APT001',
        patientId: 'P001',
        doctorId: 'D001',
        scheduledTime: DateTime.now().add(Duration(hours: 2)),
        reason: 'Checkup',
      );

      expect(appointment.status, AppointmentStatus.scheduled);

      appointment.startAppointment();
      expect(appointment.status, AppointmentStatus.inProgress);

      appointment.complete();
      expect(appointment.status, AppointmentStatus.completed);
    });

    test('Prescription validation', () {
      final medication = Medication(
        name: 'Aspirin',
        dosage: '500mg',
        frequency: 'twice daily',
        cost: 5.99,
      );

      final prescription = Prescription(
        id: 'RX001',
        patientId: 'P001',
        doctorId: 'D001',
        issueDate: DateTime.now(),
        diagnosis: 'Pain',
        items: [medication],
        totalCost: 5.99,
        instructions: 'Take with food',
      );

      expect(prescription.isValid, isTrue);
      expect(prescription.items.length, 1);
    });
  });
}
