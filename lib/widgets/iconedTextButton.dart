import 'package:flutter/material.dart';

class IconedTextButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color? color;
  final void Function()? onPressed;

  const IconedTextButton({required this.iconData, required this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [

        TextButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Icon(
                iconData,
                color: color,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                text,
                style: TextStyle(color: color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
