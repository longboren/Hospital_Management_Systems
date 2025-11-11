import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';

void main() {
  group('Repository Tests', () {
    test('Staff CRUD operations', () async {
      final repository = StaffRepository();
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

      final doctor = Doctor(
        id: 'D001',
        name: 'Dr. Chea Ratha',
        email: 'chea.ratha@hospital.com',
        phoneNumber: '+855-12-901-234',
        joinDate: DateTime.now(),
        department: 'Cardiology',
        specialization: 'Cardiology',
        licenseNumber: 'TEST123',
      );

      await repository.addStaff(doctor);
      final retrieved = await repository.getStaffById('D001');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Dr. Chea Ratha');

      await repository.deleteStaff('D001');
      final afterDelete = await repository.getStaffById('D001');
      expect(afterDelete, isNull);
    });

    test('Patient search', () async {
      final repository = PatientRepository();
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

      await repository.addPatient(Patient(
        id: 'P001',
        name: 'Vann Sopheak',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        phoneNumber: '+855-12-012-345',
        email: 'vann.sopheak@test.com',
        address: 'St. 432, Phnom Penh',
        bloodType: 'O+',
      ));

      final results = await repository.searchPatients('vann');
      expect(results.length, 1);
      expect(results.first.name, 'Vann Sopheak');
    });

    test('Room availability', () async {
      final repository = RoomRepository();
      await Future.delayed(Duration(milliseconds: 100));
      await repository.clearAll();

      final room = Room(
        id: 'R001',
        number: '101',
        type: RoomType.privateRoom,
        capacity: 1,
        pricePerDay: 250.0,
      );

      await repository.addRoom(room);
      final availableRooms = await repository.getAvailableRooms();
      expect(availableRooms.length, 1);
    });
  });
}
