import 'dart:convert';
import 'dart:io';
import '../../domain/entities/room.dart';
import '../../domain/repositories/interfaces.dart';

class RoomRepository implements IRoomRepository {
  final Map<String, Room> _roomStorage = {};
  final String _filePath = 'data/rooms.json';

  RoomRepository() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final file = File(_filePath);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        for (var jsonItem in jsonList) {
          final room = _fromJson(jsonItem);
          _roomStorage[room.id] = room;
        }
      }
    } catch (e) {
      print('Error loading room data: $e');
    }
  }

  Room _fromJson(Map<String, dynamic> json) {
    final room = Room(
      id: json['id'],
      number: json['number'],
      type: RoomType.values.firstWhere((e) => e.name == json['type']),
      capacity: json['capacity'],
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      equipment: (json['equipment'] as List?)?.cast<String>(),
    );

    // Restore bed states if available
    if (json['beds'] != null) {
      final bedsJson = json['beds'] as List;
      for (int i = 0; i < bedsJson.length && i < room.beds.length; i++) {
        final bedJson = bedsJson[i];
        final bed = room.beds[i];

        // Restore bed status using internal setter
        bed.statusInternal = BedStatus.values.firstWhere(
          (e) => e.name == bedJson['status'],
          orElse: () => BedStatus.available,
        );

        // Restore patient assignment data
        if (bedJson['patientId'] != null) {
          bed.patientIdInternal = bedJson['patientId'];
        }

        if (bedJson['assignedDate'] != null) {
          bed.assignedDateInternal = DateTime.parse(bedJson['assignedDate']);
        }

        if (bedJson['dischargeDate'] != null) {
          bed.dischargeDateInternal = DateTime.parse(bedJson['dischargeDate']);
        }
      }
    }

    return room;
  }

  Map<String, dynamic> _bedToJson(Bed bed) {
    return {
      'id': bed.id,
      'roomId': bed.roomId,
      'bedNumber': bed.bedNumber,
      'status': bed.status.name,
      'patientId': bed.patientId,
      'assignedDate': bed.assignedDate?.toIso8601String(),
      'dischargeDate': bed.dischargeDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> _toJson(Room room) {
    return {
      'id': room.id,
      'number': room.number,
      'type': room.type.name,
      'capacity': room.capacity,
      'pricePerDay': room.pricePerDay,
      'equipment': room.equipment,
      'beds': room.beds.map((bed) => _bedToJson(bed)).toList(),
    };
  }

  @override
  Future<void> addRoom(Room room) async {
    if (_roomStorage.containsKey(room.id)) {
      throw Exception('Room with ID ${room.id} already exists');
    }
    _roomStorage[room.id] = room;
    await _saveData();
  }

  Future<void> _saveData() async {
    try {
      final file = File(_filePath);
      final jsonList =
          _roomStorage.values.map((room) => _toJson(room)).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Error saving room data: $e');
    }
  }

  @override
  Future<Room?> getRoomById(String id) async {
    return _roomStorage[id];
  }

  @override
  Future<List<Room>> getRoomsByType(RoomType type) async {
    return _roomStorage.values.where((room) => room.type == type).toList();
  }

  @override
  Future<List<Room>> getAllRooms() async {
    return _roomStorage.values.toList();
  }

  @override
  Future<void> updateRoom(Room room) async {
    if (!_roomStorage.containsKey(room.id)) {
      throw Exception('Room with ID ${room.id} not found');
    }
    _roomStorage[room.id] = room;
  }

  @override
  Future<List<Room>> getAvailableRooms() async {
    return _roomStorage.values
        .where((room) => room.availableBedsCount > 0)
        .toList();
  }

  // Method clear all data (useful for testing)
  Future<void> clearAll() async {
    _roomStorage.clear();
    await _saveData();
  }
}
