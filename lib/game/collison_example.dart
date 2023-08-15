import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
class CollisonExample extends FlameGame with HasCollisionDetection {
  @override
  Future<void>? onLoad() async {
    add(Enemy());
    add(Player());

    return super.onLoad();
  }
}

class Enemy extends SpriteComponent with HasGameRef, CollisionCallbacks {
  Enemy() : super(priority: 1);

  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('DinoSpritestard.png');
    size = Vector2(100, 100);
    position = Vector2(200, gameRef.size.y / 3 * 2);
    anchor = Anchor.center;
    final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    // Add a hitbox for dino.
    add(
      RectangleHitbox.relative(
        Vector2.all(1.2),
        parentSize: size,
        collisionType: CollisionType.passive,
        position: Vector2(size.x * 0.3, size.y * 0.5) / 2,
      )..paint=hitboxPaint..renderShape=true,
    );
    return super.onLoad();
  }
}

class Player extends SpriteComponent with HasGameRef, CollisionCallbacks {
  @override
  Future<void>? onLoad() async {
    sprite = await Sprite.load('DinoSpritestard.png');
    size = Vector2(35,35);
    position = Vector2(0, gameRef.size.y / 3 * 2);
    anchor = Anchor.center;
  //  addHitbox(HitboxRectangle());
    final hitboxPaint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke;
    // Add a hitbox for dino.
    add(
      RectangleHitbox.relative(
        Vector2.all(1.2),
        parentSize: size,
        collisionType: CollisionType.passive,
        position: Vector2(size.x * 0.3, size.y * 0.5) / 2,
      )..paint=hitboxPaint..renderShape=true,
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position += Vector2(1, 0);
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Call hit only if other component is an Enemy and dino
    // is not already in hit state.
    print("==************====onCollision==************===");
    if (other is Enemy) {
      print('Player hit the Enemy!');

      remove(Enemy());  //<== Why this line is not working?
    }
    super.onCollision(intersectionPoints, other);
  }


}