import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InterText extends StatefulWidget {
  final String text;
  final FontWeight weight;
  final Color color;
  final double size;
  final TextAlign align;

  const InterText(
      {super.key,
      required this.text,
      required this.weight,
      required this.color,
      required this.size,
      required this.align});

  @override
  State<InterText> createState() => _InterTextState();
}

class _InterTextState extends State<InterText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: GoogleFonts.inter(
          fontSize: widget.size,
          fontWeight: widget.weight,
          color: widget.color),
      textAlign: widget.align,
    );
  }
}
