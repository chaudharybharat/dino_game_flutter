import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_futter/game/dino_run.dart';
import 'package:test_futter/game/widget/main_menu.dart';

import 'game/collison_example.dart';
import 'game/model/player_data.dart';
import 'game/model/settings.dart';
import 'game/widget/game_over_menu.dart';
import 'game/widget/hud.dart';
import 'game/widget/pause_menu.dart';
import 'game/widget/settings_menu.dart';

void main() async{
 WidgetsFlutterBinding.ensureInitialized();

 // Makes the game full screen and landscape only.
 Flame.device.fullScreen();
 Flame.device.setLandscape();
 // Initializes hive and register the adapters.
 await initHive();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  late DinoRun _dinoRun=DinoRun();
  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Game',
     theme: ThemeData(
       primaryColor: Colors.red,
       visualDensity: VisualDensity.adaptivePlatformDensity
     ),
     home: Scaffold(
       body: GameWidget(
         // This will dislpay a loading bar until [DinoRun] completes
         // its onLoad method.
         loadingBuilder: (context) => const Center(
           child: SizedBox(
             width: 200,
             child: LinearProgressIndicator(),
           ),
         ),
         overlayBuilderMap: {
           MainMenu.id: (_, DinoRun gameRef) => MainMenu(gameRef),
           GameOverMenu.id: (_, DinoRun gameRef) => GameOverMenu(gameRef),
           PauseMenu.id: (_, DinoRun gameRef) => PauseMenu(gameRef),
           Hud.id: (_, DinoRun gameRef) => Hud(gameRef),
           GameOverMenu.id: (_, DinoRun gameRef) => GameOverMenu(gameRef),
           SettingsMenu.id: (_, DinoRun gameRef) => SettingsMenu(gameRef),
         },

         // By default MainMenu overlay will be active.
         //  initialActiveOverlays: const [MainMenu.id],
         initialActiveOverlays: const [MainMenu.id],
         game: _dinoRun,

       ),
     ),
   );
  }

}


Future<void> initHive() async {
  // For web hive does not need to be initialized.
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  Hive.registerAdapter<PlayerData>(PlayerDataAdapter());
  Hive.registerAdapter<Settings>(SettingsAdapter());
}

