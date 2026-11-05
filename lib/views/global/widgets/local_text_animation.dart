import 'dart:async';

import 'package:flutter/widgets.dart';

class LocalTextAnimation extends StatefulWidget {
  const LocalTextAnimation({super.key, this.text = 'Cargando', this.style});
  final String text;
  final TextStyle? style;
  @override
  State<LocalTextAnimation> createState() => _LocalTextAnimationState();
}

class _LocalTextAnimationState extends State<LocalTextAnimation> {
  int _dotsCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Alterna la cantidad de puntos de 0 a 3 cada 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _dotsCount = (_dotsCount + 1) % 4;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Importante cancelar el timer al destruir el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotsCount;
    // Para evitar que el texto "salte" o se mueva horizontalmente al cambiar de tamaño,
    // puedes renderizar los puntos dentro de una cadena con ancho visible o espacios.
    return Text(
      '${widget.text}$dots',
      style: widget.style,
    );
  }
}
