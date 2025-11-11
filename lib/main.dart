import 'data/repositories/staff_repository.dart';
import 'data/repositories/patient_repository.dart';
import 'data/repositories/room_repository.dart';
import 'data/repositories/appointment_repository.dart';
import 'data/repositories/prescription_repository.dart';
import 'domain/services/hospital_service.dart';
import 'ui/console_ui.dart';

void main() async {
  print('Initializing Hospital Management System...');

  // Initialize repositories (they automatically load data from JSON files)
  final staffRepository = StaffRepository();
  final patientRepository = PatientRepository();
  final roomRepository = RoomRepository();
  final appointmentRepository = AppointmentRepository();
  final prescriptionRepository = PrescriptionRepository();

  // Initialize service with dependencies
  final hospitalService = HospitalService(
    staffRepository: staffRepository,
    patientRepository: patientRepository,
    roomRepository: roomRepository,
    appointmentRepository: appointmentRepository,
    prescriptionRepository: prescriptionRepository,
  );

  // Give repositories time to load data asynchronously
  await Future.delayed(const Duration(milliseconds: 500));

  print('✓ All data loaded from JSON files');
  print('Ready to use the Hospital Management System!\n');

  // Initialize and run UI
  final consoleUI = ConsoleUI(hospitalService);
  await consoleUI.run();
}
