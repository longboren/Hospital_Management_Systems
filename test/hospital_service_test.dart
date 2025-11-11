import 'package:test/test.dart';
import 'package:hospital_management_system/domain/entities/staff.dart';
import 'package:hospital_management_system/domain/entities/patient.dart';
import 'package:hospital_management_system/domain/entities/room.dart';
import 'package:hospital_management_system/domain/services/hospital_service.dart';
import 'package:hospital_management_system/data/repositories/staff_repository.dart';
import 'package:hospital_management_system/data/repositories/patient_repository.dart';
import 'package:hospital_management_system/data/repositories/room_repository.dart';
import 'package:hospital_management_system/data/repositories/appointment_repository.dart';
import 'package:hospital_management_system/data/repositories/prescription_repository.dart';

void main() {
  group('Hospital Service Tests', () {
    late HospitalService service;

    setUp(() async {
      final staffRepo = StaffRepository();
      final patientRepo = PatientRepository();
      final roomRepo = RoomRepository();
      final appointmentRepo = AppointmentRepository();
      final prescriptionRepo = PrescriptionRepository();

      await Future.delayed(Duration(milliseconds: 100));
      await staffRepo.clearAll();
      await patientRepo.clearAll();
      await roomRepo.clearAll();
      await appointmentRepo.clearAll();
      await prescriptionRepo.clearAll();

      service = HospitalService(
        staffRepository: staffRepo,
        patientRepository: patientRepo,
        roomRepository: roomRepo,
        appointmentRepository: appointmentRepo,
        prescriptionRepository: prescriptionRepo,
      );
    });

    test('Patient admission and bed assignment', () async {
      final patient = Patient(
        id: 'P001',
        name: 'Khem Sothea',
        dateOfBirth: DateTime(1990, 1, 1),
        gender: 'Male',
        phoneNumber: '+855-12-567-890',
        email: 'khem.sothea@email.com',
        address: 'St. 63, Phnom Penh',
        bloodType: 'O+',
      );

      final room = Room(
        id: 'R001',
        number: '101',
        type: RoomType.privateRoom,
        capacity: 1,
        pricePerDay: 250.0,
      );

      await service.admitPatient(patient);
      await service.addRoom(room);

      final bed =
          await service.assignPatientToBed('P001', RoomType.privateRoom);
      expect(bed, isNotNull);
      expect(bed!.patientId, 'P001');
    });

    test('Appointment scheduling', () async {
      final doctor = Doctor(
        id: 'D001',
        name: 'Dr. Lim Sokha',
        email: 'lim.sokha@hospital.com',
        phoneNumber: '+855-23-678-901',
        joinDate: DateTime.now(),
        department: 'Cardiology',
        specialization: 'Heart Surgery',
        licenseNumber: 'LIC123',
      );

      final patient = Patient(
        id: 'P001',
        name: 'Pich Chanthy',
        dateOfBirth: DateTime(1995, 5, 5),
        gender: 'Female',
        phoneNumber: '+855-12-789-012',
        email: 'pich.chanthy@email.com',
        address: 'St. 51, Phnom Penh',
        bloodType: 'A+',
      );

      await service.hireStaff(doctor);
      await service.admitPatient(patient);

      final appointment = await service.scheduleAppointment(
        patientId: 'P001',
        doctorId: 'D001',
        scheduledTime: DateTime.now().add(Duration(hours: 2)),
        reason: 'Checkup',
      );

      expect(appointment.patientId, 'P001');
      expect(appointment.doctorId, 'D001');
    });

    test('Hospital statistics', () async {
      await service.hireStaff(Doctor(
        id: 'D001',
        name: 'Dr. Sok Pisey',
        email: 'sok.pisey@hospital.com',
        phoneNumber: '+855-23-890-123',
        joinDate: DateTime.now(),
        department: 'General',
        specialization: 'General',
        licenseNumber: 'TEST',
      ));

      await service.addRoom(Room(
        id: 'R001',
        number: '101',
        type: RoomType.generalWard,
        capacity: 4,
        pricePerDay: 100.0,
      ));

      final stats = await service.getHospitalStats();
      expect(stats['totalStaff'], 1);
      expect(stats['availableBeds'], 4);
    });
  });
}
