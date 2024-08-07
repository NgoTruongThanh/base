import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String title;
  final String hintText;
  final String? initialValue;
  final bool obscureText;
  final Widget? icon;
  const AuthInput({
    super.key,
    required this.title,
    required this.hintText,
    this.onFieldSubmitted,
    this.initialValue,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.icon,
  
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: icon,
            hintText: hintText,
          ),
          validator: validator,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }
}
