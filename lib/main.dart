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
      title: 'Pošlji paket',
      
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
  bool gameStarted = false;
  int currentPlayerIndex = 0;
  int minSeconds = 5;
  int maxSeconds = 15;
  final random = Random();
  int timerDuration = 10;
  //spremenljivke za igro
  final clockPlayer = AudioPlayer();
  final explosionPlayer = AudioPlayer();
  final victoryPlayer = AudioPlayer();
  //inicializacija zvoka
  String clockSoundPath = "clock_sound.mp3";
  String explosionSoundPath = "explosion.mp3";
  String victorySoundPath = "victory.mp3";
  //deklaracija poti za zvok ure
  
  

  List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    //seznam igralcev
  ];

Map<String, int> playerLives = {
'Player 1': 3,
'Player 2': 3,
'Player 3': 3,
'Player 4': 3,
};


  void startGame() {
      clockPlayer.setVolume(1);
    clockPlayer.play(AssetSource(clockSoundPath));
      //začetek igre (uporabljeno v gumbu start)
      gameStarted = true;
      
      
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (timerDuration >  1) {
            timerDuration--;
            //nastavljeno odštevanje števca
          } 
          else 
          {
            endGame();
            clockPlayer.stop();
          }
        });
      });
    
  }

void gameWinner() {
 //funkcija za izpis zmagovalca
 victoryPlayer.play(AssetSource(victorySoundPath));
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
                    timerDuration = minSeconds + random.nextInt(maxSeconds - minSeconds + 1);
                    currentPlayerIndex = 0;
                    players = ['Player 1', 'Player 2', 'Player 3', 'Player 4'];
                    playerLives = {'Player 1': 3, 'Player 2': 3, 'Player 3': 3, 'Player 4': 3,};
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
    String deletedPlayer = players[currentPlayerIndex];
    //ustvarimo novo spremenljivko, da lahko pozneje izpišemo ime igralca, ki je izgubil
    playerLives[players[currentPlayerIndex]] = playerLives[players[currentPlayerIndex]] !- 1;
    //odstrani življenje igralcu

    print('${players[currentPlayerIndex]} lost a life. Lives left: ${playerLives[players[currentPlayerIndex]]}');
  
    if (playerLives[players[currentPlayerIndex]] == 0) {
      //če igralec izgubi vsa življenja, ga izbriše
        players.removeAt(currentPlayerIndex);
        
    }
    //odstrani igralca, če je izgubil življenje
    currentPlayerIndex = 0;

    if (players.length == 1) 
      {
        gameWinner();
        //če je igralec zadnji v igri, se uporabi gameWinner funkcija
      }
      else
      {
    timer.cancel();
     explosionPlayer.play(AssetSource(explosionSoundPath));
    showDialog(
      barrierDismissible: false,
      //obvezen klik na OK gumb
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          
          content: Text('$deletedPlayer lost a life!',
          style: TextStyle(fontSize: 15)),
          //izpiše igralca, ki je izgubil življenje
          actions: [
            TextButton
            (
              child: Text('Continue'),
              onPressed: () 
              {
                explosionPlayer.stop();
                //prekinitev zvoka eksplozije
                Navigator.of(context).pop();
                setState(() 
                {
                  gameStarted = false;
                  timerDuration = minSeconds + random.nextInt(maxSeconds - minSeconds + 1);
                  //ponastavi igro 
                  });
                },
              ),
            ],
          );
        },
      ); 
    } 
  }

  @override
void initState() {
  super.initState();
  // Metoda, ki se kliče po ustvarjanju State

}

void startGameOnTap() {
  
  setState(() {
    if (!gameStarted) {
      startGame();
      // Žačetek igre ob kliku ekrana, če igra že ni zagnana
    }
  });
}



  void passPackage() {
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

Widget _buildPlayerCircle(String playerName, Color color, bool isActivePlayer, int lives) {
  List<Widget> children = [
    GestureDetector(
      onTap: () {
        if (gameStarted && isActivePlayer) {
          passPackage();
          color = color.withOpacity(0.1);
          
          //podajanje paketa
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Center(
          child: Text(
            playerName,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  ];

  for (int i = 0; i < lives; i++) {
    children.add(
      Positioned(
        top: 70,
        right: 20 + i*20 ,
        child: Image.asset(
          'assets/heart.png',
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  if (isActivePlayer) {
    children.add(
      AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        top: -15,
        right: -15,
        child: GestureDetector(
          onTap: () {
            if (gameStarted && isActivePlayer) {
              passPackage();
            
            }
          },
          child: Image.asset(
            'assets/paket.png',
            width: 75,
            height: 75,
          ),
        ),
      ),
    );
  }

  return Container(
    width: 100,
    height: 100,
    margin: EdgeInsets.all(50),
    child: Stack(
      alignment: Alignment.center,
      children: children,
    ),
  );
}

  

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
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
                        currentPlayerIndex == players.indexOf(player),
                        playerLives[player] ?? 0)).toList(),
              ),
            ),
            SizedBox(height: 20),
           
              gameStarted ? Text('Time left: $timerDuration',
              style: TextStyle(fontFamily: 'Orbitron', fontSize: 24
              
                ),
              ) : ElevatedButton(onPressed: startGameOnTap, child: Text('START GAME'),
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
                        ? Colors.blue.withOpacity(0.9)
                        : player == 'Player 2'
                        ? Colors.red.withOpacity(0.9)
                        : player == 'Player 3'
                        ? Colors.green.withOpacity(0.9)
                        : Colors.yellow.withOpacity(0.9),
                        
                        currentPlayerIndex == players.indexOf(player),
                        playerLives[player] ?? 0)).toList(),
              ),
            ),
            
                
              
            ],
          ),
        ),
      );
  
  }
}