/// App strings and labels
class AppStrings {
  AppStrings._();

  // Navigation sections
  static const String timer = 'Timer';
  static const String habits = 'Hábitos';
  static const String tasks = 'Tarefas';
  static const String missions = 'Missões';
  static const String profile = 'Perfil';
  static const String focusMode = 'Modo Foco';

  // Profile
  static const String defaultUserName = 'Usuário';

  // Timer
  static const String timerZeroDisplay = '00:00';
  static const String decreaseTime = 'Diminuir tempo';
  static const String increaseTime = 'Aumentar tempo';
  static const String shortBreakLabel = 'PAUSA CURTA';
  static const String longBreakLabel = 'PAUSA LONGA';
  static String sessionsUntilLongBreak(int sessions) =>
      '$sessions sessões até a pausa longa';

  // Actions
  static const String start = 'Iniciar';
  static const String pause = 'Pausar';
}
