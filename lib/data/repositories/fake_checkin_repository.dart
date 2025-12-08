import 'dart:async';
import '../../domain/entities/checkin_entities/check_in_entity.dart';

class FakeCheckInRepository {
  Future<CheckInEntity> loadInitial() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const CheckInEntity();
  }

  Future<void> save(CheckInEntity data) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
