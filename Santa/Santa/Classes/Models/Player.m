//
//  Player.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "SimpleAudioEngine.h"

@interface Player (Private)
- (CCSequence*) fadeInOutAction;
@end

@implementation Player
@synthesize playerDirection;
@synthesize stepJump;
@synthesize isStunned;
@synthesize isMovePlay;
@synthesize animationIdleUpperLeft;
@synthesize animationIdleLowerLeft;
@synthesize animationIdleUpperRight;
@synthesize animationIdleLowerRight;

@synthesize animationBucketWalkUpperLeft;
@synthesize animationBucketWalkLowerLeft;
@synthesize animationBucketWalkUpperRight;
@synthesize animationBucketWalkLowerRight;

@synthesize animationBucketIdleUpperLeft;
@synthesize animationBucketIdleLowerLeft;
@synthesize animationBucketIdleUpperRight;
@synthesize animationBucketIdleLowerRight;

@synthesize positionMapRespawn;
@synthesize isJump;
@synthesize withBucket;

+ (Player *) player
{
    Player *player = nil;
    NSString *startSpriteName;
 
    startSpriteName = [NSString stringWithFormat:@"Santa walk1/Santa_walk_1.01.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SantaAnimationJump_00.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SantaAnimationIdle_00.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SantaAnimationBucket.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SantaAnimationIdleBucket.plist"];
    
    player = [[[Player alloc] initWithSpriteFrameName:startSpriteName]autorelease];

    player.playerDirection = MoveDirectionLowerRight;
    player.stepJump = 3;
    player.isStunned = NO;
    player.isMovePlay = NO;
    player.isJump = NO;
    player.withBucket = NO;
    
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationJumpFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationIdleFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationBucketWalkFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationBucketIdleFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        for (NSUInteger i = 1; i < 10; i++)
        {
            NSString* fileJump = [NSString stringWithFormat:@"Santa walk%d/Santa_walk_%d.%02d.png",k,k, i];
            NSString* fileIdle = [NSString stringWithFormat:@"Santa idle%d/Santa_idle_%d.%02d.png",k,k, i];
            NSString* fileBucketWalk = [NSString stringWithFormat:@"bucket walk%d.swf/%04d",k, i];
            NSString* fileBucketIdle = [NSString stringWithFormat:@"bucket idle%d.swf/%04d",k, i];
            
            CCSpriteFrame* frameJump = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
            [animationJumpFrames addObject:frameJump];
            
            CCSpriteFrame* frameIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileIdle];
            [animationIdleFrames addObject:frameIdle];
            if (i < 8)
            {
                CCSpriteFrame* frameBucketWalk = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileBucketWalk];
                [animationBucketWalkFrames addObject:frameBucketWalk];
                
                CCSpriteFrame* frameBucketIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileBucketIdle];
                [animationBucketIdleFrames addObject:frameBucketIdle];
            }
        }
        CGFloat moveWolkTime = 0.0333;
        CGFloat moveIdleTime = 0.1;
        CGFloat moveBucketTime = 0.04286;
        
        if (k == 1)
        {
            player.animationLowerRight =[[CCAnimation alloc] initWithSpriteFrames:animationJumpFrames delay:moveWolkTime];
            player.animationIdleLowerRight =[[CCAnimation alloc] initWithSpriteFrames:animationIdleFrames delay:moveIdleTime];
            player.animationBucketWalkLowerRight = [[CCAnimation alloc] initWithSpriteFrames:animationBucketWalkFrames delay:moveBucketTime];
            player.animationBucketIdleLowerRight = [[CCAnimation alloc] initWithSpriteFrames:animationBucketIdleFrames delay:moveBucketTime];
        }
        else if (k == 2)
        {
            player.animationUpperRight = [[CCAnimation alloc] initWithSpriteFrames:animationJumpFrames delay:moveWolkTime];
            player.animationIdleUpperRight = [[CCAnimation alloc] initWithSpriteFrames:animationIdleFrames delay:moveIdleTime];
            player.animationBucketWalkUpperRight = [[CCAnimation alloc] initWithSpriteFrames:animationBucketWalkFrames delay:moveBucketTime];
            player.animationBucketIdleUpperRight = [[CCAnimation alloc] initWithSpriteFrames:animationBucketIdleFrames delay:moveBucketTime];
        }
        else if (k == 3)
        {
            player.animationLowerLeft = [[CCAnimation alloc] initWithSpriteFrames:animationJumpFrames delay:moveWolkTime];
            player.animationIdleLowerLeft = [[CCAnimation alloc] initWithSpriteFrames:animationIdleFrames delay:moveIdleTime];
            player.animationBucketWalkLowerLeft = [[CCAnimation alloc] initWithSpriteFrames:animationBucketWalkFrames delay:moveBucketTime];
            player.animationBucketIdleLowerLeft = [[CCAnimation alloc] initWithSpriteFrames:animationBucketIdleFrames delay:moveBucketTime];
        }
        else
        {
            player.animationUpperLeft = [[CCAnimation alloc] initWithSpriteFrames:animationJumpFrames delay:moveWolkTime];
            player.animationIdleUpperLeft = [[CCAnimation alloc] initWithSpriteFrames:animationIdleFrames delay:moveIdleTime];
            player.animationBucketWalkUpperLeft = [[CCAnimation alloc] initWithSpriteFrames:animationBucketWalkFrames delay:moveBucketTime];
            player.animationBucketIdleUpperLeft = [[CCAnimation alloc] initWithSpriteFrames:animationBucketIdleFrames delay:moveBucketTime];
        }
    }
    
    return player;
}

- (void) stunPlayer
{
    if (self.isStunned == NO)
    {
        self.isStunned = YES;

        CCCallBlock *currentCall = [CCCallBlock actionWithBlock:^{
            self.isStunned = NO;
        }];

        [self runAction:[CCSequence actions:[self fadeInOutAction],currentCall, nil]];
    }
}

- (CCSequence*) fadeInOutAction
{
    //CCFadeOut *fade = [CCFadeOut actionWithDuration:0.25];
    //CCFadeTo *fade =
    
    CCFadeOut *fade = [CCFadeOut actionWithDuration:0.25];
    CCSequence *sequenceOneSec = [CCSequence actions:fade, [fade reverse],fade, [fade reverse],nil];
    CCSequence *sequenceFourSec = [CCSequence actions:sequenceOneSec,sequenceOneSec,sequenceOneSec,sequenceOneSec, nil];
    return sequenceFourSec;
}

- (void) rotationPlayerInDirection:(EMoveDirection)direction;
{
    if (self.playerDirection != direction && !self.isStunned ) 
    {
        self.playerDirection = direction;
        [self stopAllActions];
        [self animateIdlePlayerWithDirection:direction];
    }

}

- (void) animateJumpPlayerWithDirection:(EMoveDirection)direction
{
    if (direction==MoveDirectionNone) {
        direction = MoveDirectionUpperRight;
    }
    CCAnimate *animate;
  
    if (direction == MoveDirectionUpperLeft ) 
    {

        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketWalkUpperLeft];
        }
        else
        {
           animate = [CCAnimate actionWithAnimation:self.animationUpperLeft]; 
        }
    }
    else if(direction == MoveDirectionLowerLeft ) 
    {
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketWalkLowerLeft];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationLowerLeft];
        }
    }
    else if(direction == MoveDirectionUpperRight ) 
    {
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketWalkUpperRight];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationUpperRight];
        }
    }
    else if(direction == MoveDirectionLowerRight ) 
    {
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketWalkLowerRight];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationLowerRight];
        }
    }
    [self stopActionByTag:10];
    [self stopActionByTag:11];
    animate.tag = 11;
    [self runAction:animate];
}

- (void) animateLaughPlayerWithDirection:(EMoveDirection)direction
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_Hohoho.caf"];
    NSString *nameFile = [NSString stringWithFormat:@"SantaAnimationLaugh_%02d.plist",direction];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:nameFile];

    NSMutableArray *animationLaughFrames = [[[NSMutableArray alloc] initWithCapacity:34] autorelease];
    for (NSUInteger i = 0; i < 35; i++)
    {
        NSString* fileLaugh = [NSString stringWithFormat:@"Santa laugh%d.swf/%04d",direction,i];
       // NSLog(@"fileLaugh =%@",fileLaugh);
        
        CCSpriteFrame* frameLaugh = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileLaugh];
        [animationLaughFrames addObject:frameLaugh];
    }
  
    CGFloat moveTime = 0.125;
    CCAnimate *animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:animationLaughFrames delay: moveTime]];;
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];

    [self stopAllActions];
    repeat.tag = 12;
    
//    [self stopActionByTag:10];
//    [self stopActionByTag:11];
//    [self stopActionByTag:12];
    [self runAction:repeat];
}

- (void) animateIdlePlayerWithDirection:(EMoveDirection)direction
{
    if (direction==MoveDirectionNone) {
        self.playerDirection = MoveDirectionUpperRight;
        direction = MoveDirectionUpperRight;
    }
    CCAnimate *animate;
    if (direction == MoveDirectionUpperLeft) 
    {
        playerDirection = MoveDirectionUpperLeft;
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketIdleUpperLeft];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationIdleUpperLeft];
        }
        
    }
    else if(direction == MoveDirectionLowerLeft) 
    {
        playerDirection = MoveDirectionLowerLeft;
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketIdleLowerLeft];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationIdleLowerLeft];
        }
    }
    else if(direction == MoveDirectionUpperRight) 
    {
        playerDirection = MoveDirectionUpperRight;
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketIdleUpperRight];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationIdleUpperRight];
        }
    }
    else if(direction == MoveDirectionLowerRight) 
    {
        playerDirection = MoveDirectionLowerRight;
        if (self.withBucket)
        {
            animate = [CCAnimate actionWithAnimation:self.animationBucketIdleLowerRight];
        }
        else
        {
            animate = [CCAnimate actionWithAnimation:self.animationIdleLowerRight];
        }
    }

        [self stopActionByTag:10];
        [self stopActionByTag:11];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
        repeat.tag = 10;
        
        [self runAction:repeat];


}

- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
{
	float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
	float currentZ = tilePos.x + tilePos.y;
	self.vertexZ = lowestZ + currentZ - 1.5f;//0.5

}

- (void) dealloc
{
    [self.animationIdleUpperLeft release];
    [self.animationIdleLowerLeft release];
    [self.animationIdleUpperRight release];
    [self.animationIdleLowerRight release];
    
    [self.animationBucketWalkUpperLeft release];
    [self.animationBucketWalkLowerLeft release];
    [self.animationBucketWalkUpperRight release];
    [self.animationBucketWalkLowerRight release];
    
    [self.animationUpperLeft release];
    [self.animationLowerLeft release];
    [self.animationUpperRight release];
    [self.animationLowerRight release];
    
    [self.animationBucketIdleUpperLeft release];
    [self.animationBucketIdleLowerLeft release];
    [self.animationBucketIdleUpperRight release];
    [self.animationBucketIdleLowerRight release];
    [super dealloc];
}


@end
