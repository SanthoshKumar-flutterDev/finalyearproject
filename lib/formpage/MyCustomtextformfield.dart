import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final int? maxLines;
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;// Optional validator

  const CustomTextFormField({
    super.key,
    this.maxLines,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onChanged
    // Default is null, meaning validation is optional
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 15.w),
      child: TextFormField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey.shade50),
            borderRadius: BorderRadius.circular(15)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.blueGrey.shade50)
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade50,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.black54, fontSize: 10.w),
          border: OutlineInputBorder(),
        ),
        validator: widget.validator, // Uses custom validation if provided
      ),
    );
  }
}
