import 'package:flutter/material.dart';

class ButtonNeo extends StatefulWidget {
  ButtonNeo(
      {super.key,
      required this.bgcolor,
      required this.text,
      required this.onPressed});
  final Color bgcolor;
  final String text;
  final Function? onPressed;

  @override
  State<ButtonNeo> createState() => _ButtonNeoState();
}

class _ButtonNeoState extends State<ButtonNeo> {
  double _paddingb = 4;
  double _paddingr = 2;

  @override
  Widget build(BuildContext context) {
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
          _paddingb = 4;
          _paddingr = 2;
        });
      },
      child: AnimatedContainer(
        padding: EdgeInsets.only(right: _paddingr, bottom: _paddingb),
        duration: const Duration(milliseconds: 85),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: widget.bgcolor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
