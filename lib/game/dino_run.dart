import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_futter/game/widget/game_over_menu.dart';
import 'package:test_futter/game/widget/hud.dart';

import 'audio_manager.dart';
import 'dino.dart';
import 'enemy.dart';
import 'enemy_manager.dart';
import 'model/enemy_data.dart';
import 'model/player_data.dart';
import 'model/settings.dart';
import 'my_parallax_component.dart';



class DinoRun extends FlameGame with TapDetector,HasCollisionDetection{


  // List of all the audio assets.
  static const _audioAssets = [
    '8BitPlatformerLoop.wav',
    'hurt7.wav',
    'jump14.wav',
  ];


  late Dino _dino;
  late EnemyManager _enemyManager;
  late EnemyData enemyData;
  late Settings settings;
  late PlayerData playerData;

  @override
  Future<void>? onLoad() async {
    /// Read [PlayerData] and [Settings] from hive.
    playerData = await _readPlayerData();
    settings = await _readSettings();
    /// Initilize [AudioManager].
    await AudioManager.instance.init(_audioAssets, settings);

    // Start playing background music. Internally takes care
    // of checking user settings.
    AudioManager.instance.startBgm('8BitPlatformerLoop.wav');



    // add(Background());
    add(ComponentParallaxGame());
    //add(Crate());
  //  enemyData=
  //  startGamePlay();
    return super.onLoad();
  }
  void startGamePlay() async{
    var dineSpriteSheet = await images.load('DinoSpritestard.png');
    _dino=Dino(images: dineSpriteSheet,);
    _enemyManager = EnemyManager();
      add(_dino);
      add(_enemyManager);
  }
  // This method reset the whole game world to initial state.
  void reset() {
    // First disconnect all actions from game world.
    _disconnectActors();
    // Reset player data to inital values.
    playerData.currentScore = 0;
    playerData.lives = 5;
  }


  @override
  void update(double dt) {
    super.update(dt);

  }
  
  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);

  }


  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    jump();
  //  hit();
  }

  // Makes the dino jump.
  void jump() {
    // Jump only if dino is on ground.
    if (_dino.isOnGround) {
      _dino.speedY = -600;
     // current = DinoAnimationStates.idle;
     // AudioManager.instance.playSfx('jump14.wav');
    }
  }

  // This method changes the animation state to
  /// [DinoAnimationStates.hit], plays the hit sound
  /// effect and reduces the player life by 1.
  void hit() {
    _dino.isHit=true;
    _dino.animation=_dino.hitAnimation.animation;
    _dino.timer.start();
    AudioManager.instance.playSfx('hurt7.wav');
    playerData.lives -= 1;


    // If number of lives is 0 or less, game is over.
    if (playerData.lives <= 0) {
      overlays.add(GameOverMenu.id);
      overlays.remove(Hud.id);
      pauseEngine();
      AudioManager.instance.pauseBgm();
    }
  }
 void run(){

 }
  // This method remove all the actors from the game.
  void _disconnectActors() {
    _dino.removeFromParent();
    _enemyManager.removeAllEnemies();
    _enemyManager.removeFromParent();
  }


  /// This method reads [PlayerData] from the hive box.
  Future<PlayerData> _readPlayerData() async {
    final playerDataBox =
    await Hive.openBox<PlayerData>('DinoRun.PlayerDataBox');
    final playerData = playerDataBox.get('DinoRun.PlayerData');

    // If data is null, this is probably a fresh launch of the game.
    if (playerData == null) {
      // In such cases store default values in hive.
      await playerDataBox.put('DinoRun.PlayerData', PlayerData());
    }

    // Now it is safe to return the stored value.
    return playerDataBox.get('DinoRun.PlayerData')!;
  }

  /// This method reads [Settings] from the hive box.
  Future<Settings> _readSettings() async {
    final settingsBox = await Hive.openBox<Settings>('DinoRun.SettingsBox');
    final settings = settingsBox.get('DinoRun.Settings');

    // If data is null, this is probably a fresh launch of the game.
    if (settings == null) {
      // In such cases store default values in hive.
      await settingsBox.put(
        'DinoRun.Settings',
        Settings(bgm: true, sfx: true),
      );
    }

    // Now it is safe to return the stored value.
    return settingsBox.get('DinoRun.Settings')!;
  }


}



