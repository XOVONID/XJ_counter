import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  bool _isPlusPressed = false;
  bool _isResetPressed = false;
  bool _isMinusPressed = false;

  bool get _isAnyButtonPressed => _isPlusPressed || _isResetPressed || _isMinusPressed;

  void _incrementCounter() {
    setState(() { _counter++; });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _resetCounter() {
    setState(() { _counter = 0; });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWarning = _counter > 10;
    final Color neonColor = isWarning ? Colors.red : Colors.purple;
    final Color neonColorAccent = isWarning ? Colors.redAccent : Colors.purpleAccent;
    final Color deepNeonColor = isWarning ? Colors.deepOrange : Colors.deepPurple;

    return Scaffold(
      backgroundColor: const Color(0xff09090b),
      appBar: AppBar(
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 20.0,
                color: neonColor.withAlpha(200),
                offset: const Offset(0.0, 0.0),  
              ), 
            ],
          ),
          child: const Text('XJ'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0.0, -0.15),
              child: AnimatedScale(
                scale: _isAnyButtonPressed ? 0.90 : 1.0,
                duration: const Duration(milliseconds: 262),
                curve: Curves.fastLinearToSlowEaseIn,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    '$_counter',
                    key: ValueKey<int>(_counter),
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.w200,
                      color: Colors.white,
                      shadows: [
                        Shadow(blurRadius: 15.0, color: neonColor.withAlpha(255)),
                        Shadow(blurRadius: 35.0, color: neonColorAccent.withAlpha(200)),
                        Shadow(blurRadius: 65.0, color: deepNeonColor.withAlpha(150)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.add,
                    isPressed: _isPlusPressed,
                    onTapDown: () => setState(() => _isPlusPressed = true),
                    onTapUp: () { setState(() => _isPlusPressed = false); _incrementCounter(); },
                  ),
                ),
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.refresh,
                    isPressed: _isResetPressed,
                    onTapDown: () => setState(() => _isResetPressed = true),
                    onTapUp: () { setState(() => _isResetPressed = false); _resetCounter(); },
                  ),
                ),
                Expanded(
                  child: _buildGlassButton(
                    icon: Icons.remove,
                    isPressed: _isMinusPressed,
                    onTapDown: () => setState(() => _isMinusPressed = true),
                    onTapUp: () { setState(() => _isMinusPressed = false); _decrementCounter(); },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required bool isPressed,
    required VoidCallback onTapDown,
    required VoidCallback onTapUp,
  }) {
    return GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapUp(),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 262),
          curve: Curves.easeOutBack,
          width: isPressed ? 119 : 95,
          height: isPressed ? 61 : 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(31.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Colors.white.withAlpha(20), Colors.white.withAlpha(30)],
            ),
            border: Border.all(color: Colors.blue.withAlpha(isPressed ? 220 : 80), width: 1 / 2),
            boxShadow: [
              BoxShadow(
                color: isPressed ? Colors.blue.withAlpha(140) : Colors.black.withAlpha(100),
                blurRadius: isPressed ? 20.0 : 10.0, spreadRadius: 10.0, offset: isPressed ? Offset.zero : const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white.withAlpha(isPressed ? 225 : 220), size: isPressed ? 35 : 26),
        ),
      ),
    );
  }
}
