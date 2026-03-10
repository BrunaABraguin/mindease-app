class Preferences {
  const Preferences({
    required this.showHelpIcons,
    required this.showAnimations,
    required this.darkTheme,
    this.selectedTaskId,
  });

  factory Preferences.fromMap(Map<String, dynamic> map) {
    final defaults = defaultValues();
    return Preferences(
      showHelpIcons: map['showHelpIcons'] ?? defaults.showHelpIcons,
      showAnimations: map['showAnimations'] ?? defaults.showAnimations,
      darkTheme: map['darkTheme'] ?? defaults.darkTheme,
      selectedTaskId: map['selectedTaskId'] as String?,
    );
  }

  static Preferences defaultValues() => const Preferences(
    showHelpIcons: true,
    showAnimations: true,
    darkTheme: false,
  );
  final bool showHelpIcons;
  final bool showAnimations;
  final bool darkTheme;
  final String? selectedTaskId;

  static const Object _notSpecified = Object();

  Preferences copyWith({
    bool? showHelpIcons,
    bool? showAnimations,
    bool? darkTheme,
    Object? selectedTaskId = _notSpecified,
  }) {
    return Preferences(
      showHelpIcons: showHelpIcons ?? this.showHelpIcons,
      showAnimations: showAnimations ?? this.showAnimations,
      darkTheme: darkTheme ?? this.darkTheme,
      selectedTaskId: identical(selectedTaskId, _notSpecified)
          ? this.selectedTaskId
          : selectedTaskId as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showHelpIcons': showHelpIcons,
      'showAnimations': showAnimations,
      'darkTheme': darkTheme,
      'selectedTaskId': selectedTaskId,
    };
  }
}
