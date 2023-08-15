import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import '/game/dino_run.dart';
import 'constant_key.dart';
import 'model/enemy_data.dart';

// This represents an enemy in the game world.
class Enemy extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<DinoRun> {
  // The data required for creation of this enemy.
  final EnemyData enemyData;


  Enemy({required this.enemyData}) {
    //debugMode=true;
    animation = SpriteAnimation.fromFrameData(
      enemyData.image,
      SpriteAnimationData.sequenced(
        amount: enemyData.nFrames,
        stepTime: enemyData.stepTime,
        textureSize: enemyData.textureSize,
      ),
    );
    this.anchor=Anchor.center;
  }

  @override
  void onMount() {
    // Reduce the size of enemy as they look too
    // big compared to the dino.
    size *= 0.9;
    final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    // Add a hitbox for this enemy.
    add(
      RectangleHitbox.relative(
        Vector2.all(0.8),
        parentSize: size,
        position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
      ) /*..paint = hitboxPaint
        ..renderShape = true,*/
    );

    super.onMount();
  }

  @override
  void update(double dt) {
    position.x -= enemyData.speedX * dt;
    // Remove the enemy and increase player score
    // by 1, if enemy has gone past left end of the screen.
    // Remove the enemy and increase player score
    // by 1, if enemy has gone past left end of the screen.
    if (position.x < -enemyData.textureSize.x) {
      removeFromParent();
      gameRef.playerData.currentScore += 1;
    }
    super.update(dt);
  }

}
