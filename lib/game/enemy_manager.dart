import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:test_futter/game/constant_key.dart';

import '/game/dino_run.dart';
import 'enemy.dart';
import 'model/enemy_data.dart';

// This class is responsible for spawning random enemies at certain
// interval of time depending upon players current score.
class EnemyManager extends PositionComponent with HasGameRef<DinoRun> {
  // A list to hold _data for all the enemies.

   List<EnemyData> _data = [];
  // Random generator required for randomly selecting enemy type.
  final Random _random = Random();

  // Timer to decide when to spawn next enemy.
  final Timer _timer = Timer(7, repeat: true);
  bool isEnemyReady=false;
  EnemyManager() {
    _timer.onTick = spawnRandomEnemy;
  }
  late Enemy enemy ;
  // This method is responsible for spawning a random enemy.
  void spawnRandomEnemy() {
  if(_data.isEmpty){
    return;
  }

    /// Generate a random index within [_data] and get an [Enemy_data].
    final randomIndex = _random.nextInt(_data.length);
    final enemyData = _data.elementAt(randomIndex);
    enemy= Enemy(enemyData: enemyData);

    // Help in setting all enemies on ground.
     enemy.anchor = Anchor.bottomLeft;
    enemy.position = Vector2(
      gameRef.size.x + 32,
      gameRef.size.y - (13+enemyData.textureSize.y),
    );

    // If this enemy can fly, set its y position randomly.
    if (enemyData.canFly) {
      final newHeight = _random.nextDouble() * 2 * enemyData.textureSize.y;
      enemy.position.y -= newHeight;
     // return;
    }
    //here add -20 own me
    enemy.position.y= enemy.position.y;
    // Due to the size of our viewport, we can
    // use textureSize as size for the components.
    enemy.size = enemyData.textureSize;

    gameRef.add(enemy);
    isEnemyReady=true;
  }

  @override
  void onMount()async {
    if (isMounted) {
      removeFromParent();
    }
    print("=====onMount===========");

    // Don't fill list again and again on every mount.
    if (_data.isEmpty) {
      // As soon as this component is mounted, initilize all the _data.
      _data.addAll([
        EnemyData(
          image:await gameRef.images.load('AngryPig/Walk(36x30).png') ,
          nFrames: 16,
          stepTime: 0.1,
          textureSize: Vector2(36, 32),
          speedX: 80,
          canFly: false,
        ),
        EnemyData(
          image: await gameRef.images.load('Bat/Flying(46x30).png') ,
          nFrames: 7,
          stepTime: 0.1,
          textureSize: Vector2(46, 32),
          speedX: 80,
          canFly: true,
        ),
        EnemyData(
          image: await gameRef.images.load('Rino/Run(52x34).png') ,
          nFrames: 6,
          stepTime: 0.09,
          textureSize: Vector2(52, 34),
          speedX: 150,
          canFly: false,
        ),
      ]);
    }
    _timer.start();
    super.onMount();
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    if(isEnemyReady) {
     // print("===enemy.y==${enemy.y}===${enemy.x}===");
    }
    super.update(dt);
  }

  void removeAllEnemies() {
    final enemies = gameRef.children.whereType<Enemy>();
    for (var enemy in enemies) {
      enemy.removeFromParent();
    }
  }
}
