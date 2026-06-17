import 'package:flutter/material.dart';

class CuboRubikGesto extends StatefulWidget {
  const CuboRubikGesto({super.key});

  @override
  State<CuboRubikGesto> createState() => _CuboRubikGestoState();
}

class _CuboRubikGestoState extends State<CuboRubikGesto> {
  @override
  Widget build(BuildContext context) {
    final List<Container> misContenedores = [
      Container(width: 80, height: 80, color: Colors.purple),
      Container(width: 80, height: 80, color: Colors.blue),
      Container(width: 80, height: 80, color: Colors.orange),
      Container(width: 80, height: 80, color: Colors.green),
      Container(width: 80, height: 80, color: Colors.white),
      Container(width: 80, height: 80, color: Colors.yellow),
      Container(width: 80, height: 80, color: Colors.redAccent),
      Container(width: 80, height: 80, color: Colors.teal),
      Container(width: 80, height: 80, color: Colors.pink),
    ];

    const double tamanoPieza = 80.0;
    const double separacion = 5.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(title: const Text('Cubo Rubik con Stack')),
      body: Center(
        child: Container(
          width: 260,
          height: 260,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: misContenedores.asMap().entries.map((entry) {
              int index = entry.key;
              Container contenedor = entry.value;

              int fila = index ~/ 3;
              int columna = index % 3;

              double x = columna * (tamanoPieza + separacion);
              double y = fila * (tamanoPieza + separacion);

              return Positioned(
                left: x,
                top: y,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tocaste la Fila: ${fila + 1}, Columna: ${columna + 1}',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: contenedor,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
