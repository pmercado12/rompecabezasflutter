import 'package:flutter/material.dart';

class Anipos extends StatefulWidget {
  const Anipos({super.key});

  @override
  State<Anipos> createState() => _AniposState();
}

class _AniposState extends State<Anipos> {
  double r = 800, b = 1600;
  bool flag = false;

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            left: 0,
            top: 0,
            right: r,
            bottom: b,
            duration: Duration(milliseconds: 1000),
            child: Container(width: 100, height: 100, color: Colors.purple),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (flag == false) {
              b = screen.height / 2;
              r = screen.width / 2;
              flag = true;
            } else {
              b = screen.height;
              r = screen.width;
              flag = false;
            }

            print(' flag = $flag ');
          });
        },
      ),
    );
  }
}
