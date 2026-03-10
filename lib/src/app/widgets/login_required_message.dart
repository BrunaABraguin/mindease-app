import 'package:flutter/material.dart';

import 'package:mindease_app/src/app/widgets/empty_state_card.dart';

class LoginRequiredMessage extends StatelessWidget {
  const LoginRequiredMessage({
    super.key,
    this.message = 'Faça login com o Google para\nacessar esta funcionalidade.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyStateCard(
      icon: Icons.lock_outline_rounded,
      message: message,
      iconAlpha: 0.4,
    );
  }
}
