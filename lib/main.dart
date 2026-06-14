import 'package:estados/align.dart';
import 'package:estados/anipos.dart';
import 'package:estados/home.dart';
import 'package:estados/rompe.dart';
import 'package:estados/rompe_gesto.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //return const MaterialApp(home: CuboRubikGesto());
    return const MaterialApp(home: Rompe());
  }
}
