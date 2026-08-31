import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  const TextCard({super.key,required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(10),
      width: double.infinity,
      
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
        
      ),
    );
  }
}
