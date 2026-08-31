import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  const CustomElevatedButton({
    super.key,
    this.buttonText = const Text("data"),
    required this.onPressed,
    this.isRectangle = 20,
    this.height = 50,
  });

  final Widget buttonText;
  final Function()? onPressed;
  final double isRectangle;
  final double height;

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.isRectangle),
          boxShadow:  [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.outline,
                    offset: const Offset(5, 5),
                  ),
                ]
             
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          transform: Matrix4.translationValues(
            _isPressed ? 4 : 0,
            _isPressed ? 4 : 0,
            0,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(widget.isRectangle),
              child: Ink(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(widget.isRectangle),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Container(
                  height: widget.height,
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  child: widget.buttonText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}