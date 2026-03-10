import 'package:mindease_app/src/data/repositories/timer_repository.dart';
import 'package:mindease_app/src/domain/entities/timer_entity.dart';

class MockTimerRepository implements TimerRepository {
  final List<TimerEntity> savedEntities = [];
  TimerEntity? entityToLoad;

  @override
  Future<void> saveTimerEntity(TimerEntity timer) async {
    savedEntities.add(timer);
  }

  @override
  Future<TimerEntity?> loadTimerEntity() async {
    return entityToLoad;
  }
}
