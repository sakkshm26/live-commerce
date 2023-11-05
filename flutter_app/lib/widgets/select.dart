import 'package:flutter/material.dart';

class SelectOption extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool? active;
  final Function onTap;
  const SelectOption(
      {super.key,
      required this.text,
      required this.textColor,
      required this.backgroundColor,
      required this.onTap,
      this.active});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 1,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          onTap();
        },
        borderRadius: BorderRadius.circular(50),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(62),
            border: Border.all(color: active! ? Color.fromARGB(255, 207, 207, 207) : Color.fromARGB(255, 78, 78, 78), width: 2),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
