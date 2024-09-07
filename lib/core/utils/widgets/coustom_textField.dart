import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final  TextEditingController controller;
  final String labelText;
  final bool obsText;

  const CustomTextField({super.key, required this.controller, required this.labelText, this.obsText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
       controller: controller,
       obscureText: obsText,
       decoration: InputDecoration(
         labelText: labelText,
         border: const OutlineInputBorder(

         )
       ),
    );
  }
}
