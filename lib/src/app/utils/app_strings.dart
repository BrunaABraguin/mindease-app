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

  // Habits
  static const String addNewHabit = '+ Adicione um novo hábito';
  static const String emptyHabitsMessage =
      'Você ainda não tem hábitos.\nComece adicionando um acima!';
  static const String habitNameHint = 'Nome do hábito';
  static const String confirmDelete = 'Deseja excluir este hábito?';
  static const String yes = 'Sim';
  static const String no = 'Não';
  static const String mon = 'seg.';
  static const String tue = 'ter.';
  static const String wed = 'qua.';
  static const String thu = 'qui.';
  static const String fri = 'sex.';
  static const String sat = 'sáb.';
  static const String sun = 'dom.';

  // Actions
  static const String start = 'Iniciar';
  static const String pause = 'Pausar';

  // Missions
  static String missionsProgress(int completed, int total) =>
      '$completed / $total concluídas';
  static const String missionsLoginMessage =
      'Faça login com o Google para\nadicionar e gerenciar suas missões.';
}
