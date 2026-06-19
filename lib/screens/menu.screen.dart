import 'package:flutter/material.dart';
import 'puzzle_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<String> puzzles = [
    'assets/bolbasor.png',
    'assets/cha.png',
    'assets/chansi.png',
    'assets/gigli.png',
    'assets/squart.png',
  ];

  int index = 0;

  final PageController _controller = PageController();

  void _next() {
    setState(() {
      index++;
      if (index >= puzzles.length) index = 0;
    });

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _prev() {
    setState(() {
      index--;
      if (index < 0) index = puzzles.length - 1;
    });

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),

      body: Column(
        children: [
          const SizedBox(height: 60),

          // 🔥 TÍTULO TIPO POKÉMON
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ROMPEC",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                "assets/pokebola.png",
                width: 30,
                height: 30,
              ),
              const Text(
                "C",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Image.asset(
                "assets/pokebola.png",
                width: 30,
                height: 30,
              ),
            ],
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Row(
              children: [
                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _prev,
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: puzzles.length,
                    onPageChanged: (i) {
                      setState(() {
                        index = i;
                      });
                    },
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            puzzles[i],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                IconButton(
                  iconSize: 40,
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _next,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PuzzleScreen(
                    imagen: puzzles[index],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(
                horizontal: 60,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "JUGAR",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}