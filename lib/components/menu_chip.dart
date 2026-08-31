import 'package:flutter/material.dart';

class MenuChip extends StatefulWidget {
  final List<String> options;
  const MenuChip({super.key, required this.options});

  @override
  State<MenuChip> createState() => _MenuChipState();
}

class _MenuChipState extends State<MenuChip> {
  String _selected = "All";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // set an appropriate height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ChoiceChip(
              selectedColor: Colors.blue,backgroundColor: Colors.grey[200],
              showCheckmark: false,
              side: const BorderSide(color: Colors.transparent),
              shape: const StadiumBorder(),
              label: Text(
                widget.options[index],
                style: TextStyle(
                    color: _selected == widget.options[index]
                        ? Colors.white
                        : Colors.grey),
              ),
              selected: _selected == widget.options[index],
              onSelected: (bool selected) {
                setState(() {
                  if (selected) {
                    _selected = widget.options[index];
                  } else {
                    _selected = "All";
                  }
                });
              },
            ),
          );
        },
      ),
    );
  }
}
