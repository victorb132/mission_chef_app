import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:master_chef_app/utils/app_colors.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _hours = 0;
  int _minutes = 0;
  Timer? _timer;
  bool _isRunning = false;
  int _totalSeconds = 0;

  void _startStopTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      if (_totalSeconds == 0) {
        _totalSeconds = (_hours * 3600) + (_minutes * 60);
      }

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_totalSeconds > 0) {
            _totalSeconds--;
          } else {
            _timer?.cancel();
            _isRunning = false;
          }
        });
      });
    }

    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _incrementHours() {
    setState(() {
      _hours = (_hours + 1) % 24;
    });
  }

  void _decrementHours() {
    setState(() {
      _hours = (_hours - 1 + 24) % 24;
    });
  }

  void _incrementMinutes() {
    setState(() {
      _minutes = (_minutes + 1) % 60;
    });
  }

  void _decrementMinutes() {
    setState(() {
      _minutes = (_minutes - 1 + 60) % 60;
    });
  }

  String _formattedTime() {
    final int hours = _totalSeconds ~/ 3600;
    final int minutes = (_totalSeconds % 3600) ~/ 60;
    final int seconds = _totalSeconds % 60;

    return '${hours.toString().padLeft(2, '0')} : '
        '${minutes.toString().padLeft(2, '0')} : '
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _isRunning ? const Color(0xFFFFF6DC) : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: _isRunning ? Colors.black : Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título superior
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "hr",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(width: 80),
                Text(
                  "min",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Controles de horas, minutos e segundos
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Horas
                _timeControl(_hours, _incrementHours, _decrementHours),
                const SizedBox(width: 20),
                Text(
                  ":",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: _isRunning ? Colors.black : Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                // Minutos
                _timeControl(_minutes, _incrementMinutes, _decrementMinutes),
              ],
            ),

            const SizedBox(height: 50),

            // Botão de START/STOP
            GestureDetector(
              onTap: _startStopTimer,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Ícone da panela
                      Icon(
                        Icons.ramen_dining_outlined,
                        size: 180,
                        color: _isRunning ? Colors.red : Colors.white24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Text(
                          _isRunning ? "STOP" : "START",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _isRunning ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_isRunning) ...[
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.local_fire_department,
                      color: Colors.red,
                      size: 48,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tempo Atual
            Text(
              _formattedTime(),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: _isRunning ? Colors.black87 : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeControl(
    int value,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: onIncrement,
          icon: Icon(
            Icons.arrow_drop_up,
            size: 36,
            color: _isRunning ? Colors.black : Colors.white,
          ),
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: _isRunning ? Colors.black : Colors.white,
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 36,
            color: _isRunning ? Colors.black : Colors.white,
          ),
        ),
      ],
    );
  }
}
