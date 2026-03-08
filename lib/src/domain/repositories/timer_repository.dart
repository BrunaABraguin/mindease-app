import 'package:mindease_app/src/domain/entities/timer_entity.dart';

abstract class TimerRepositoryBase {
  Future<void> saveTimerEntity(TimerEntity timer);
  Future<TimerEntity?> loadTimerEntity();
}
