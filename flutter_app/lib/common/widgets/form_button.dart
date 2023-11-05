import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final bool isLoading;
  const FormButton({super.key, required this.title, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: const Color(0xFF363342),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),
                  ),
                )
              : Text(title),
        ),
      ),
    );
  }
}
