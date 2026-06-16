import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class CuboRubikGesto extends StatefulWidget {
  const CuboRubikGesto({super.key});

  @override
  State<CuboRubikGesto> createState() => _CuboRubikGestoState();
}

class _CuboRubikGestoState extends State<CuboRubikGesto> {
  static const double tamanoPieza = 80.0;
  static const double separacion = 5.0;
  Timer? timer;
  int segundos = 0;
  bool juegoTerminado = false;

  final List<Pieza> piezasBase = const [
    Pieza(id: 1, color: Colors.purple),
    Pieza(id: 2, color: Colors.blue),
    Pieza(id: 3, color: Colors.orange),
    Pieza(id: 4, color: Colors.green),
    Pieza(id: 5, color: Colors.pink),
    Pieza(id: 6, color: Colors.yellow),
    Pieza(id: 7, color: Colors.redAccent),
    Pieza(id: 8, color: Colors.brown),
    Pieza(id: 0, color: Colors.white, esComodin: true),
  ];

  late List<Pieza> objetivo;

  late List<Pieza> tablero;

  int get indiceVacio => tablero.indexWhere((p) => p.esComodin);

  @override
  void initState() {
    super.initState();

    generarObjetivo();
    tablero = List.of(objetivo);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mezclar(3);
      iniciarTimer();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(title: const Text('Rompecabezas Pedro')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    miniaturaObjetivo(),
                    //const SizedBox(height: 5),
                    const Text(
                      "Objetivo",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Column(children: [timerWidget(), const SizedBox(height: 5)]),
              ],
            ),
            const SizedBox(height: 20),
            Container(
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
                      },
                      child: nodo(pieza),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    nuevoJuego();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nuevo'),
                ),

                const SizedBox(width: 10),

                ElevatedButton.icon(
                  onPressed: mostrarAyuda,
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Ayuda'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void generarObjetivo() {
    objetivo = List.of(piezasBase);

    do {
      objetivo.shuffle();
    } while (objetivo.last.id != 0);
  }

  void nuevoJuego() {
    setState(() {
      generarObjetivo();
      tablero = List.of(objetivo);
      mezclar(2);
    });
    iniciarTimer();
  }

  void mostrarAyuda() {
    final solucion = resolverAStar(estadoActual(), estadoObjetivo());

    if (solucion.length > 1) {
      final siguiente = solucion[1];

      print('Próximo movimiento: $siguiente');
    }
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
    for (int i = 0; i < tablero.length; i++) {
      if (tablero[i].id != objetivo[i].id) {
        return false;
      }
    }
    return true;
  }

  void mover(int index) {
    if (!puedeMover(index)) return;

    setState(() {
      final vacio = indiceVacio;

      final temp = tablero[index];
      tablero[index] = tablero[vacio];
      tablero[vacio] = temp;
    });

    if (estaResuelto()) {
      detenerTimer();
      mostrarDialogoVictoria();
    }
  }

  void mezclar([int pasos = 100]) {
    final random = Random();

    do {
      tablero = List.of(objetivo);

      for (int i = 0; i < pasos; i++) {
        int vacio = indiceVacio;

        List<int> vecinos = [];

        int fila = vacio ~/ 3;
        int columna = vacio % 3;

        if (fila > 0) vecinos.add(vacio - 3);
        if (fila < 2) vecinos.add(vacio + 3);
        if (columna > 0) vecinos.add(vacio - 1);
        if (columna < 2) vecinos.add(vacio + 1);

        int elegido = vecinos[random.nextInt(vecinos.length)];

        final temp = tablero[elegido];
        tablero[elegido] = tablero[vacio];
        tablero[vacio] = temp;
      }
    } while (estaResuelto());

    setState(() {});
  }

  void mostrarDialogoVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('🎉 ¡Ganaste!'),
          content: const Text('Has completado correctamente el puzzle.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nuevoJuego();
              },
              child: const Text('Jugar otra vez'),
            ),
          ],
        );
      },
    );
  }

  Widget miniaturaObjetivo() {
    return SizedBox(
      width: 90,
      height: 90,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: objetivo.length,
        itemBuilder: (_, index) {
          Pieza pieza = objetivo[index];
          return Container(margin: const EdgeInsets.all(1), color: pieza.color);
        },
      ),
    );
  }

  void iniciarTimer() {
    timer?.cancel();

    segundos = 0;
    juegoTerminado = false;

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      setState(() {
        segundos++;
      });
    });
  }

  void detenerTimer() {
    timer?.cancel();
  }

  String formatearTiempo(int totalSegundos) {
    final minutos = totalSegundos ~/ 60;
    final segundosRestantes = totalSegundos % 60;

    return '${minutos.toString().padLeft(2, '0')}:'
        '${segundosRestantes.toString().padLeft(2, '0')}';
  }

  Widget timerWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDDAA),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 18, color: Colors.black87),
          const SizedBox(width: 6),
          Text(
            formatearTiempo(segundos),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  List<int> estadoActual() {
    return tablero.map((p) => p.id).toList();
  }

  List<int> estadoObjetivo() {
    return objetivo.map((p) => p.id).toList();
  }

  int distanciaManhattan(List<int> estado, List<int> objetivo) {
    int total = 0;

    for (int valor = 1; valor <= 8; valor++) {
      int actual = estado.indexOf(valor);
      int destino = objetivo.indexOf(valor);

      int filaA = actual ~/ 3;
      int colA = actual % 3;

      int filaD = destino ~/ 3;
      int colD = destino % 3;

      total += (filaA - filaD).abs() + (colA - colD).abs();
    }

    return total;
  }

  List<List<int>> vecinos(List<int> estado) {
    List<List<int>> resultado = [];

    int vacio = estado.indexOf(0);

    int fila = vacio ~/ 3;
    int col = vacio % 3;

    List<int> movimientos = [];

    if (fila > 0) movimientos.add(vacio - 3);
    if (fila < 2) movimientos.add(vacio + 3);
    if (col > 0) movimientos.add(vacio - 1);
    if (col < 2) movimientos.add(vacio + 1);

    for (final destino in movimientos) {
      final nuevo = List<int>.from(estado);

      int tmp = nuevo[vacio];
      nuevo[vacio] = nuevo[destino];
      nuevo[destino] = tmp;

      resultado.add(nuevo);
    }

    return resultado;
  }

  List<List<int>> resolverAStar(List<int> inicio, List<int> meta) {
    List<NodoAStar> abiertos = [];

    Set<String> cerrados = {};

    abiertos.add(
      NodoAStar(estado: inicio, g: 0, h: distanciaManhattan(inicio, meta)),
    );

    while (abiertos.isNotEmpty) {
      abiertos.sort((a, b) => a.f.compareTo(b.f));

      NodoAStar actual = abiertos.removeAt(0);

      if (actual.estado.toString() == meta.toString()) {
        return reconstruirCamino(actual);
      }

      cerrados.add(actual.estado.toString());

      for (final vecino in vecinos(actual.estado)) {
        if (cerrados.contains(vecino.toString())) {
          continue;
        }

        abiertos.add(
          NodoAStar(
            estado: vecino,
            g: actual.g + 1,
            h: distanciaManhattan(vecino, meta),
            padre: actual,
          ),
        );
      }
    }

    return [];
  }

  List<List<int>> reconstruirCamino(NodoAStar nodo) {
    List<List<int>> camino = [];

    NodoAStar? actual = nodo;

    while (actual != null) {
      camino.add(actual.estado);
      actual = actual.padre;
    }

    return camino.reversed.toList();
  }
}

class Pieza {
  final int id; // 0 = vacío
  final Color color;
  final bool esComodin;

  const Pieza({required this.id, required this.color, this.esComodin = false});
}

class NodoAStar {
  final List<int> estado;
  final int g;
  final int h;
  final NodoAStar? padre;

  NodoAStar({
    required this.estado,
    required this.g,
    required this.h,
    this.padre,
  });

  int get f => g + h;
}
