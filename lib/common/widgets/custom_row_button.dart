import 'package:flutter/material.dart';

class CustomRowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final String buttonText;

  const CustomRowButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }
}
