import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.controller,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20),
        fillColor: Colors.grey.shade300,
        filled: true,
        alignLabelWithHint: true,
        hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
