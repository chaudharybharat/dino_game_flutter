import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:test_futter/game/widget/pause_menu.dart';

import '../model/player_data.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';

// This represents the head up display in game.
// It consists of, current score, high score,
// a pause button and number of remaining lives.
class Hud extends StatelessWidget {
  // An unique identified for this overlay.
  static const id = 'Hud';

  // Reference to parent game.
  final DinoRun gameRef;

  const Hud(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameRef.playerData,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.currentScore,
                  builder: (_, score, __) {
                    return Text(
                      'Score: $score',
                      style: const TextStyle(fontSize: 20, color: Colors.white,fontFamily: "Audiowide"),
                    );
                  },
                ),
                Selector<PlayerData, int>(
                  selector: (_, playerData) => playerData.highScore,
                  builder: (_, highScore, __) {
                    return Text(
                      'High: $highScore',
                      style: const TextStyle(color: Colors.white,fontFamily: "Audiowide"),
                    );
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                gameRef.overlays.remove(Hud.id);
                gameRef.overlays.add(PauseMenu.id);
                gameRef.pauseEngine();
                AudioManager.instance.pauseBgm();
              },
              child: const Icon(Icons.pause, color: Colors.white),
            ),
            Selector<PlayerData, int>(
              selector: (_, playerData) => playerData.lives,
              builder: (_, lives, __) {

                double life= (lives/10)*2;
               int total= (life*100).toInt();
               Color progress= Colors.greenAccent;
               if(total<=40){
                 progress=Colors.orange;
               }
               if(total<30){
                 progress=Colors.red;
               }
                String displayLife=total.toString();
                return LinearPercentIndicator(
                  width:100,
                  animation: true,
                  lineHeight: 20.0,
                  curve: Curves.bounceOut,
                  animationDuration: 1500,
                  percent: life,
                  center: Text(displayLife+"%",style: TextStyle(fontSize:12,fontFamily: "Audiowide"),),
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  progressColor: progress,
                )/*Row(
                  children: List.generate(5, (index) {
                    if (index < lives) {
                      return const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      );
                    } else {
                      return const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      );
                    }
                  }),
                )*/;
              },
            )
          ],
        ),
      ),
    );
  }
}
