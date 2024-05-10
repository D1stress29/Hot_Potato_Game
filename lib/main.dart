import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  late Timer timer;
  int timerDuration = 10;
  bool gameStarted = false;
  int currentPlayerIndex = 0;
  //spremenljivke za igro
  AudioCache audioCache = AudioCache();
  //inicializacija zvoka

  List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    //seznam igralcev
  ];

  void startGame() {
    setState(() {
      //začetek igre (uporabljeno v gumbu start)
      gameStarted = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (timerDuration > 0) {
            timerDuration--;
            //nastavljeno odštevanje števca
          } else {
            endGame();
          }
        });
      });
    });
  }

  void endGame() {
    // koda za prekinitev igre
    timer.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('${players[currentPlayerIndex]} lost!'),
          //izpiše igralca, ki je izgubil življenje
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameStarted = false;
                  timerDuration = 10;
                  currentPlayerIndex = 0;
                  //ponastavi igro
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
void initState() {
  super.initState();
  // Metoda, ki se kliče po ustvarjanju State
  startGameOnTap();
}

void startGameOnTap() {
  
  setState(() {
    if (!gameStarted) {
      startGame();
      // Žačetek igre ob kliku ekrana, če igra že ni zagnana
    }
  });
}


  void passPotato() {
    setState(() {
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    });
    // koda za pošiljanje paketa
    //uporabimo setState, da se igralec posodobi takoj in ne čakamo na naslednji klic build funkcije
  }

Widget _buildPlayerCircle(String playerName, Color color, bool isActivePlayer) {
  return Container(
    width: 100,
    height: 100,
    margin: EdgeInsets.all(50),
    child: GestureDetector(
      //metoda za prepoznavanje dotika
      onTap: () {
        if (gameStarted && isActivePlayer) {
          passPotato();
          //ob zaznanem dotiku kroga igralca se pošlje paket
        }
      },
      child: Container(
        width: 100, 
        height: 100, 
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActivePlayer ? color : Colors.grey,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Center(
          child: Text(
            playerName,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ),
  );
} 

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: GestureDetector(
          onTap: startGameOnTap,
          //zažene funkcijo startGameOnTap ob kliku ekrana
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: players
                    .sublist(0, players.length ~/ 2)
                    .map((player) => _buildPlayerCircle(
                        player,
                        player == 'Player 1'
                        ? Colors.blue
                        : player == 'Player 2'
                        ? Colors.red
                        : player == 'Player 3'
                        ? Colors.green
                        : Colors.yellow,
                        //izbira barve glede na igralca
                        currentPlayerIndex == players.indexOf(player)))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              gameStarted ? 'Time left: $timerDuration' : 'Press HERE to begin',
              //prikaz časa
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: players
                    .sublist(players.length ~/ 2)
                    .map((player) => _buildPlayerCircle(
                        player,
                        player == 'Player 1'
                        ? Colors.blue
                        : player == 'Player 2'
                        ? Colors.red
                        : player == 'Player 3'
                        ? Colors.green
                        : Colors.yellow,
                        
                        currentPlayerIndex == players.indexOf(player)))
                    .toList(),
              ),
            ),
            
                
              
            ],
          ),
        ),
      )
    );
  }
}