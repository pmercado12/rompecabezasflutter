import 'package:flutter/material.dart';

class CuboRubikGesto extends StatefulWidget {
  const CuboRubikGesto({super.key});

  @override
  State<CuboRubikGesto> createState() => _CuboRubikGestoState();
}

class _CuboRubikGestoState extends State<CuboRubikGesto> {
  static const double tamanoPieza = 80.0;
  static const double separacion = 5.0;

  List<Pieza> tablero = [
    const Pieza(id: 1, color: Colors.purple),
    const Pieza(id: 2, color: Colors.blue),
    const Pieza(id: 3, color: Colors.orange),
    const Pieza(id: 4, color: Colors.green),
    const Pieza(id: 5, color: Colors.pink),
    const Pieza(id: 6, color: Colors.yellow),
    const Pieza(id: 7, color: Colors.redAccent),
    const Pieza(id: 8, color: Colors.teal),
    const Pieza(id: 0, color: Colors.white, esComodin: true),
  ];

  int get indiceVacio => tablero.indexWhere((p) => p.esComodin);

  final Pieza vacia = const Pieza(id: 0, color: Colors.white);

  double lero = 100, leve = 200;

  @override
  Widget build(BuildContext context) {
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
            children: tablero.asMap().entries.map((entry) {
              int index = entry.key;
              Pieza pieza = entry.value;

              int fila = index ~/ 3;
              int columna = index % 3;

              return AnimatedPositioned(
                key: ValueKey(pieza.id),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                left: obtenerX(index),
                top: obtenerY(index),
                child: GestureDetector(
                  onTap: () {
                    mover(index);
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
                  child: nodo(pieza),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  double obtenerX(int index) {
    int col = index % 3;
    return col * (tamanoPieza + separacion);
  }

  double obtenerY(int index) {
    int fila = index ~/ 3;
    return fila * (tamanoPieza + separacion);
  }

  Widget nodo(Pieza pieza) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: pieza.esComodin ? Colors.white : pieza.color,
        border: Border.all(color: Colors.white),
      ),
    );
  }

  bool puedeMover(int index) {
    int vacio = indiceVacio;

    int filaP = index ~/ 3;
    int colP = index % 3;

    int filaV = vacio ~/ 3;
    int colV = vacio % 3;

    return (filaP == filaV && (colP - colV).abs() == 1) ||
        (colP == colV && (filaP - filaV).abs() == 1);
  }

  bool estaResuelto() {
    for (int i = 0; i < 8; i++) {
      if (tablero[i].id != i + 1) return false;
    }
    return tablero[8].esComodin;
  }

  void mover(int index) {
    print(index);
    if (!puedeMover(index)) return;
    print("puede");

    setState(() {
      final vacio = indiceVacio;

      final temp = tablero[index];
      tablero[index] = tablero[vacio];
      tablero[vacio] = temp;
    });
  }
}

class Pieza {
  final int id; // 0 = vacío
  final Color color;
  final bool esComodin;

  const Pieza({required this.id, required this.color, this.esComodin = false});
}
