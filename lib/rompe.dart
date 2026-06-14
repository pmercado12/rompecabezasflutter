import 'package:flutter/material.dart';

class Rompe extends StatefulWidget {
  const Rompe({super.key});

  @override
  State<Rompe> createState() => _RompeState();
}

class _RompeState extends State<Rompe> {
  double lero = 100, leve = 200;

  void swap() {
    double tmp = lero;
    lero = leve;
    leve = tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rompecocos')),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            left: lero,
            top: 200,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print('tocaste mosaico rojo');
                  swap();
                });
              },
              child: Container(width: 100, height: 100, color: Colors.red),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 1000),
            left: leve,
            top: 200,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  print('tocaste mosaico verde');
                  swap();
                });
              },
              child: Container(width: 100, height: 100, color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }
}
