abstract class TimerRepositoryBase {
  Future<int?> getCurrentModeIndex();
  Future<void> setCurrentModeIndex(int index);
}
