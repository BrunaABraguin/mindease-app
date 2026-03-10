import 'package:flutter/material.dart';

class HistoryToggleButton extends StatelessWidget {
  const HistoryToggleButton({
    super.key,
    required this.showHistory,
    required this.onPressed,
  });

  final bool showHistory;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          showHistory ? Icons.list_alt : Icons.view_kanban_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        tooltip: showHistory ? 'Tarefas pendentes' : 'Histórico de tarefas',
      ),
    );
  }
}
