class Preferences {
  const Preferences({
    required this.showHelpIcons,
    required this.showAnimations,
    required this.darkTheme,
  });

  factory Preferences.fromMap(Map<String, dynamic> map) {
    final defaults = defaultValues();
    return Preferences(
      showHelpIcons: map['showHelpIcons'] ?? defaults.showHelpIcons,
      showAnimations: map['showAnimations'] ?? defaults.showAnimations,
      darkTheme: map['darkTheme'] ?? defaults.darkTheme,
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

  Preferences copyWith({
    bool? showHelpIcons,
    bool? showAnimations,
    bool? darkTheme,
  }) {
    return Preferences(
      showHelpIcons: showHelpIcons ?? this.showHelpIcons,
      showAnimations: showAnimations ?? this.showAnimations,
      darkTheme: darkTheme ?? this.darkTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'showHelpIcons': showHelpIcons,
      'showAnimations': showAnimations,
      'darkTheme': darkTheme,
    };
  }
}
