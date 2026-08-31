import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FieldType {
  email,
  password,
  phone,
  price,
  optional,
  text,
}

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final FieldType fieldType;
  final String? Function(String?)? customValidator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.fieldType = FieldType.text,
    this.customValidator,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(hintText),const SizedBox(height: 5,),
        TextFormField(
            controller: controller,
            maxLines: maxLines,
            obscureText: fieldType == FieldType.password,
            keyboardType: keyboardType ?? _getKeyboardType(),
            inputFormatters: inputFormatters ?? _getInputFormatters(),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black,width: 1.5),
                
              ),focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black,width: 1.5
                ),
              ) ,
            
            ),
            validator: customValidator ?? _defaultValidator,
          ),
      ],
    )
    ;
  }

  TextInputType _getKeyboardType() {
    switch (fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.price:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (fieldType) {
      case FieldType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      case FieldType.price:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }

  String? _defaultValidator(String? value) {
    if (fieldType == FieldType.optional && (value == null || value.isEmpty)) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    switch (fieldType) {
      case FieldType.email:
        final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegExp.hasMatch(value)) {
          return 'Enter a valid email address';
        }
        break;
      case FieldType.password:
        if (value.length < 8) {
          return 'Password must be at least 8 characters long';
        }
        break;
      case FieldType.phone:
        if (value.length != 10) {
          return 'Enter a valid 10-digit number';
        }
        if (!RegExp(r'^[9876]').hasMatch(value)) {
          return 'Phone number should start with 9, 8, 7, or 6';
        }
        break;
      case FieldType.price:
        final intValue = int.tryParse(value);
        if (intValue == null) {
          return 'Please enter a valid integer';
        }
        break;
      default:
        break;
    }

    return null;
  }
}