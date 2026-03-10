import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mindease_app/src/app/utils/app_constants.dart';

class DateHeader extends StatelessWidget {
  const DateHeader({super.key, required this.selectedDate, required this.onDatePicked});

  final DateTime selectedDate;
  final void Function(DateTime) onDatePicked;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = DateFormat(
      "EEEE, d 'de' MMMM",
      'pt_BR',
    ).format(selectedDate);

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.paddingM,
          vertical: AppSizes.paddingS,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formatted,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              icon: Icon(Icons.calendar_month, color: colorScheme.secondary),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: colorScheme.copyWith(
                          primary: colorScheme.secondary,
                          onPrimary: colorScheme.onSecondary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  onDatePicked(picked);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
