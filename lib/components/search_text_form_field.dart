import 'package:flutter/material.dart';

class SearchTextFormField extends StatelessWidget {
  SearchTextFormField({super.key,});


  final OutlineInputBorder textFieldStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.transparent));

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style:
          const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
      // cursorColor: GlobalVariables.selectedNavBarColor,
      decoration: InputDecoration(
        filled: true,
        
        fillColor: Colors.grey[200],
        hintText: "Search",
        hintStyle: const TextStyle(
            color: Colors.black45, fontWeight: FontWeight.normal),
        constraints: const BoxConstraints(maxHeight: 45, minHeight: 45),
        prefixIcon: const Icon(Icons.search),
        focusedBorder: textFieldStyle,
        enabledBorder: textFieldStyle,
        border: textFieldStyle,
        contentPadding: const EdgeInsets.only(top: 3),
        // suffixIcon: IconButton(
        //         icon:const Icon(Icons.mic_outlined),
        //         color: Colors.grey, onPressed: () {  },
        //       ),
      ),
    );
  }
}
