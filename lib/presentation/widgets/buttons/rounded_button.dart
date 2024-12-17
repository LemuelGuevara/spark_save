import 'package:flutter/material.dart';

class RoundedButton extends StatefulWidget {
  final VoidCallback? onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool disabled; // New prop for disabling button

  const RoundedButton({
    required this.onTap,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.disabled = false, // Default to false
    super.key,
  });

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled ? null : widget.onTap, // Disable onTap if disabled
      onTapDown: (_) {
        if (!widget.disabled) {
          setState(() {
            _isPressed = true;
          });
        }
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Opacity(
        opacity:
            widget.disabled ? 0.5 : (_isPressed ? 0.7 : 1.0), // Adjust opacity
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: widget.backgroundColor, // Background color
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.textColor, // Text color
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}