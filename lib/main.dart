import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(HotPotatoGame());
}

class HotPotatoGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hot Potato Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Timer _timer;
  int _timerDuration = 10; // in seconds
  bool _gameStarted = false;
  int _currentPlayerIndex = 0;

  List<String> _players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
  ];

  void _startGame() {
    setState(() {
      _gameStarted = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_timerDuration > 0) {
            _timerDuration--;
          } else {
            _endGame();
          }
        });
      });
    });
  }

  void _passPotato() {
    // Logic for passing potato to the next player
    // For simplicity, just increment player index
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _players.length;
     // Reset the timer when passing the potato
  }

  void _endGame() {
    _timer.cancel();
    // Determine the losing player and display a message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('${_players[_currentPlayerIndex]} lost!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _gameStarted = false;
                  _timerDuration = 10;
                  _currentPlayerIndex = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayerCircle(String playerName, Color color, bool isActivePlayer) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActivePlayer ? color : Colors.grey,
      ),
      child: Center(
        child: Text(
          playerName,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hot Potato Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _players
                    .sublist(0, _players.length ~/ 2)
                    .map((player) => _buildPlayerCircle(
                        player,
                        player == 'Player 1'
                        ? Colors.blue
                        : player == 'Player 2'
                        ? Colors.red
                        : player == 'Player 3'
                        ? Colors.green
                        : Colors.yellow,
                        _currentPlayerIndex == _players.indexOf(player)))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _gameStarted ? 'Time left: $_timerDuration' : 'Press Start to begin',
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _players
                    .sublist(_players.length ~/ 2)
                    .map((player) => _buildPlayerCircle(
                        player,
                        player == 'Player 1'
                            ? Colors.blue
                            : player == 'Player 2'
                                ? Colors.red
                                : player == 'Player 3'
                                    ? Colors.green
                                    : Colors.yellow,
                        _currentPlayerIndex == _players.indexOf(player)))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            if (!_gameStarted)
              TextButton(
                onPressed: _startGame,
                child: Text('Start'),
              )
            else
              TextButton(
                onPressed: _passPotato,
                child: Text('Pass Potato'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    _currentPlayerIndex == 0 ? Colors.blue :
                    _currentPlayerIndex == 1 ? Colors.red :
                    _currentPlayerIndex == 2 ? Colors.green : Colors.yellow,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}