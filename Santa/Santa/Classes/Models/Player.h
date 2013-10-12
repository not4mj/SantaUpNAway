//
//  Player.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "Animal.h"


@interface Player : Animal 
{
    EMoveDirection playerDirection;
    NSInteger stepJump;
    CCAnimate *currentAnimate;
}
@property (nonatomic, assign) EMoveDirection playerDirection;
@property (nonatomic, assign) NSInteger stepJump;
@property (nonatomic, assign) BOOL isStunned;
@property (nonatomic, assign) BOOL isMovePlay;
@property (nonatomic, assign) BOOL isJump;
@property (nonatomic, assign) BOOL withBucket;

@property (nonatomic, assign) CGPoint positionMapRespawn;

@property (nonatomic, retain) CCAnimation *animationIdleUpperLeft;
@property (nonatomic, retain) CCAnimation *animationIdleLowerLeft;
@property (nonatomic, retain) CCAnimation *animationIdleUpperRight;
@property (nonatomic, retain) CCAnimation *animationIdleLowerRight;

@property (nonatomic, retain) CCAnimation *animationBucketWalkUpperLeft;
@property (nonatomic, retain) CCAnimation *animationBucketWalkLowerLeft;
@property (nonatomic, retain) CCAnimation *animationBucketWalkUpperRight;
@property (nonatomic, retain) CCAnimation *animationBucketWalkLowerRight;

@property (nonatomic, retain) CCAnimation *animationBucketIdleUpperLeft;
@property (nonatomic, retain) CCAnimation *animationBucketIdleLowerLeft;
@property (nonatomic, retain) CCAnimation *animationBucketIdleUpperRight;
@property (nonatomic, retain) CCAnimation *animationBucketIdleLowerRight;

+ (Player *) player;

- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
- (void) animateJumpPlayerWithDirection:(EMoveDirection)direction;
- (void) animateLaughPlayerWithDirection:(EMoveDirection)direction;
- (void) animateIdlePlayerWithDirection:(EMoveDirection)direction;
- (void) rotationPlayerInDirection:(EMoveDirection)direction;
- (void) stunPlayer;
@end
