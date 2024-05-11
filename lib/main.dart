import 'dart:async';
import 'dart:math';
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
          if (timerDuration >  0) {
            timerDuration--;
            //nastavljeno odštevanje števca
          } 
          else 
          {
            endGame();
          }
        });
      });
    });
  }

void gameWinner() {
 //funkcija za izpis zmagovalca
timer.cancel();
showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${players[0]} is the winner!'),
              //izpiše ime zmagovalca
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    gameStarted = false;
                    timerDuration = 10;
                    currentPlayerIndex = 0;
                    players = ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
                    //igralce, ki so izgubili doda nazaj v igro
                  
                  });
                },
                child: Text('Play Again'),
              ),
            ],
          ),
        );
      },
    );
}



  void endGame() {
    // koda za prekinitev igre
    timer.cancel();
    showDialog(
      barrierDismissible: false,
      //obvezen klik na OK gumb
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          content: Text('${players[currentPlayerIndex]} lost!'),
          //izpiše igralca, ki je izgubil življenje
          actions: [
            TextButton
            (
              child: Text('OK'),
              onPressed: () 
              {
                Navigator.of(context).pop();
                setState(() 
                {
                  players.removeAt(currentPlayerIndex);
                  //odstrani igralca, če je izgubil življenje
                  
                  gameStarted = false;
                  timerDuration = 10;
                  currentPlayerIndex = 0;
                  //ponastavi igro
                  if (players.length == 1) 
                  {
                    gameWinner();
                    //če je igralec zadnji v igri, se uporabi gameWinner funkcija
                  }
                  
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
    int newIndex;
    
    do 
    {
      newIndex = Random().nextInt(players.length);
      //funkcija generira naključno število glede na število igralcev v do stavku
    } 
    while (newIndex == currentPlayerIndex);
    //while pogoj se izpolnjuje ko je generiran index enak indexu trenutnega igralca
    currentPlayerIndex = newIndex;
    //nastavimo igralcu nov index, ki je drugačen od trenutnega
  });
}

Widget _buildPlayerCircle(String playerName, Color color, bool isActivePlayer) {
  return Container(
    width: 100,
    height: 100,
    margin: EdgeInsets.all(50),
    child: Stack(
    alignment: Alignment.center,
    children: [ 
      GestureDetector(
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
    if (isActivePlayer)
      Positioned (
        right: -50,
              child: Image.asset(
                'assets/paket.png',
                width: 50,
                height: 50,
              ),
            ),
        ],
      ),
    );
  }

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        
          //zažene funkcijo startGameOnTap ob kliku ekrana
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: players.sublist(0, players.length ~/ 2).map((player) => _buildPlayerCircle
                (
                        player,
                        player == 'Player 1'
                        ? Colors.blue
                        : player == 'Player 2'
                        ? Colors.red
                        : player == 'Player 3'
                        ? Colors.green
                        : Colors.yellow,
                        //izbira barve glede na igralca
                        currentPlayerIndex == players.indexOf(player))).toList(),
              ),
            ),
            SizedBox(height: 20),
           
              gameStarted ? Text('Time left: $timerDuration') : ElevatedButton(onPressed: startGameOnTap, child: Text('START GAME'),
              //prikaz časa in gumba za začetek igre
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row
              (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: players.sublist(players.length ~/ 2).map((player) => _buildPlayerCircle(
                        player,
                        player == 'Player 1'
                        ? Colors.blue
                        : player == 'Player 2'
                        ? Colors.red
                        : player == 'Player 3'
                        ? Colors.green
                        : Colors.yellow,
                        
                        currentPlayerIndex == players.indexOf(player))).toList(),
              ),
            ),
            
                
              
            ],
          ),
        ),
      );
  
  }
}