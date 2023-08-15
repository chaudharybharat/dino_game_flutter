import 'dart:ui';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:test_futter/game/dino_run.dart';

import 'enemy.dart';

const groundHeight=35;
const double dinoTopBottomSpacing=10;
const int numberOfTilesAlongWidth=10;
const double GRAVITY=1000;

class Dino extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<DinoRun> {
  double yMax=0.0;
  late SpriteAnimationComponent runAnimation;
  late SpriteAnimationComponent hitAnimation;
  double speedY=0.0;
  final images;
  late Timer timer;
  bool isHit = false;
  final spriteSize = Vector2(35,24);

  Dino({this.images,}):super() {

     //debugMode=true;
    var spriteSheet = images;// images.load('DinoSpritestard.png');
    // final spriteSize = Vector2(152 * 1.4, 142 * 1.4);

    SpriteAnimationData spriteData = SpriteAnimationData.sequenced(
        amount: 10, stepTime: 0.03, textureSize: Vector2(576 / 24,24));
    SpriteAnimationData spriteDataHit = SpriteAnimationData.sequenced(
        amount: 3, stepTime: 0.1, textureSize: Vector2.all(24),
    texturePosition: Vector2((4 + 6 + 4) * 24, 0));
     runAnimation =
    SpriteAnimationComponent.fromFrameData(spriteSheet, spriteData)
      ..x = 45
      ..y = size.y-groundHeight-42
      ..size = spriteSize;


     hitAnimation =
    SpriteAnimationComponent.fromFrameData(spriteSheet, spriteDataHit)
      ..x = 45
      ..y = size.y-groundHeight-42
      ..size = spriteSize;
   //   anchor=Anchor.center;

  }
  @override
  Future<void> onLoad() async {
      await super.onLoad();
     _reset();

     this.animation=runAnimation.animation;
     this.size=spriteSize;
     final hitboxPaint = BasicPalette.white.paint()
       ..style = PaintingStyle.stroke;
     // Add a hitbox for dino.
     add(
         RectangleHitbox.relative(
           Vector2(1,1.7),
           isSolid: true,
           anchor: Anchor.center,
           parentSize: spriteSize,
         //  position: Vector2(size.x * 0.1, size.y * 0.5) / 2,
           position: Vector2(28, size.y-groundHeight+40,)
          // position: Vector2(size.x * 0.2, size.y * 0.2) / 2,
         )
     );


     yMax = y;
     timer=Timer(2);
     /// Set the callback for [_hitTimer].
     timer.onTick = () {
       this.animation=runAnimation.animation;
       isHit=false;
     };
  }

  bool get isOnGround => (y >= yMax);

  @override
  void update(double dt) {
    super.update(dt);
    speedY+=GRAVITY*dt;
    y+=speedY*dt;
  //print(y);
    if(isOnGround){
      y=this.yMax;
      speedY=0.0;
    }
    timer.update(dt);

    //227.4  without Anchor.center

  }

  // Gets called when dino collides with other Collidables.
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // Call hit only if other component is an Enemy and dino
    // is not already in hit state.
    if ((other is Enemy) && (!isHit)) {
      gameRef.hit();
    }
    super.onCollision(intersectionPoints, other);
  }


  @override
  void onGameResize(Vector2 gameSize) {

    super.onGameResize(gameSize);
    height=width=gameSize.x / numberOfTilesAlongWidth;
    x=width;
    y=gameSize.y-groundHeight-( height/2);
    this.yMax=y;
  }
  void _reset() {
    if (isMounted) {
      removeFromParent();
    }
    anchor = Anchor.center;
    size = Vector2.all(24);
    animation = runAnimation.animation;
    isHit = false;
    speedY = 0.0;
  }
}