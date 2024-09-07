
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function onAction;
  const CustomButton({super.key, required this.title, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:()=> onAction(),
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(25)
        ),
        child: Center(
          child: Text(title,style:const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Colors.white
          ),),
        ),
      ),
    );
  }
}
