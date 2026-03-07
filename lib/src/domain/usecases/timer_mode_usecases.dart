import 'package:mindease_app/src/domain/repositories/timer_repository.dart';

class GetCurrentModeIndexUseCase {
  GetCurrentModeIndexUseCase(this.repository);
  final TimerRepositoryBase repository;

  Future<int?> call() => repository.getCurrentModeIndex();
}

class SetCurrentModeIndexUseCase {
  SetCurrentModeIndexUseCase(this.repository);
  final TimerRepositoryBase repository;

  Future<void> call(int index) => repository.setCurrentModeIndex(index);
}
