import 'package:flutter/material.dart';

class ButtonNeo extends StatefulWidget {
  ButtonNeo(
      {super.key,
      required this.bgcolor,
      required this.text,
      this.size = 20,
      required this.onPressed});
  final Color bgcolor;
  final String text;
  final Function? onPressed;
  final double size;

  @override
  State<ButtonNeo> createState() => _ButtonNeoState();
}

class _ButtonNeoState extends State<ButtonNeo> {
  double _paddingb = 4;
  double _paddingr = 2;

  @override
  Widget build(BuildContext context) {
    double vertical = widget.size / 2;
    double horizontal = widget.size;

    return GestureDetector(
      onTap: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapDown: (_) {
        setState(() {
          _paddingb = 0;
          _paddingr = 0;
        });
      },
      onTapUp: (_) {
        setState(() {
          _paddingb = widget.size / 5;
          _paddingr = widget.size / 10;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(right: _paddingr, bottom: _paddingb),
        duration: const Duration(milliseconds: 85),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(widget.size / 2),
        ),
        child: Container(
          padding:
              EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
          decoration: BoxDecoration(
            color: widget.bgcolor,
            borderRadius: BorderRadius.circular(widget.size / 2),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: widget.size,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
