import 'package:estados/modelos/primo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController tecNumero = TextEditingController();
  String resultado = '';
  double w = 0, h = 0;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Número Primo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: tecNumero,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(hint: Text('Ingresa aca el número')),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      FocusScope.of(context).unfocus();
                      String ct = tecNumero.text.trim();
                      if (ct.isNotEmpty) {
                        int n = int.parse(tecNumero.text);
                        Primo objPrimo = Primo(n);
                        if (objPrimo.esPrimo()) {
                          resultado = '$n si es primo';
                        } else {
                          resultado = '$n no es primo';
                        }
                        w = 250;
                        h = 250;
                      }
                    });
                  },
                  child: Text('Primo'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tecNumero.clear();
                      resultado = '';
                      w = 0;
                      h = 0;
                      flag = false;
                    });
                  },
                  child: Text('Nuevo'),
                ),
              ],
            ),
            SizedBox(height: 50),
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              onEnd: () {
                setState(() {
                  if (w > 0) {
                    flag = true;
                  }
                });
              },
              width: w,
              height: h,
              color: Colors.purple.shade200,
              child: Center(
                child: flag
                    ? Text(resultado, style: TextStyle(fontSize: 25))
                    : SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
