import 'package:flutter/material.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class Container_Neo extends StatefulWidget {
  const Container_Neo(
      {super.key,
      required this.bgcolor,
      required this.child,
      required this.size,
      this.onLongPressed,
      this.onPressed});
  final Color bgcolor;
  final Widget child;
  final double size;
  final Function? onPressed;
  final Function? onLongPressed;
  @override
  State<Container_Neo> createState() => _Container_NeoState();
}

class _Container_NeoState extends State<Container_Neo> {
  double _paddingb = 6;
  double _paddingr = 3;
  @override
  Widget build(BuildContext context) {
    double vertical = widget.size / 2;
    double horizontal = widget.size;

    return GestureDetector(
      onLongPress: () => widget.onLongPressed!(),
      onTap: () {
        // if (widget.onPressed != null) {
        //   widget.onPressed!();
        // }
      },
      onTapCancel: () => setState(() {
        _paddingb = widget.size / 5;
        _paddingr = widget.size / 10;
      }),
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
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeInQuad,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(widget.size / 2),
        ),
        child: TouchRippleEffect(
          onTap: () => widget.onPressed!(),
          rippleColor: Colors.amber,
          child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.size * 9,
              ),
              decoration: BoxDecoration(
                color: widget.bgcolor,
                borderRadius: BorderRadius.circular(widget.size / 3),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: widget.child),
        ),
      ),
    );
  }
}
