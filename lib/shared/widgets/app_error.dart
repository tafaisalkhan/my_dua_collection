import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  const AppError(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Center(child: Text(message));
}
