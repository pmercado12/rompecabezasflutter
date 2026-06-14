import 'package:flutter/material.dart';

class AniAlign extends StatefulWidget {
  const AniAlign({super.key});

  @override
  State<AniAlign> createState() => _AniAlignState();
}

class _AniAlignState extends State<AniAlign> {
  double x = 0, y = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedAlign(
            duration: Duration(milliseconds: 2000),
            curve: Curves.bounceOut,
            onEnd: () {
              setState(() {
                y = 1;
              });
            },
            alignment: Alignment(x, y),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient: RadialGradient(colors: [Colors.white, Colors.black]),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            y = -1;
          });
        },
      ),
    );
  }
}
