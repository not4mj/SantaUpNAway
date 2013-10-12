//
//  ThrowEnemy.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ThrowEnemy.h"
#import "MapCoordinationHelper.h"

@implementation ThrowEnemy
+ (ThrowEnemy*) throwEnemyWithType:(EnemiesType) type
{
    ThrowEnemy *enemy = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Elf_%02d_Animation.plist",type]];
    NSString *firstSpriteName = [NSString stringWithFormat:@"Elf Throw1/Elf%d_throw_1.01.png",type - EnemiesTypeElfSneak_4];
    enemy = [[[ThrowEnemy alloc] initWithSpriteFrameName:firstSpriteName] autorelease];
    enemy.speed = 100;
    enemy.breakTime = 0;
    enemy.type = type;
    
    CGFloat timeOneFrame = 1.0/12;//1/13
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:16] autorelease];
        for (NSUInteger i = 1; i < 17; i++)
        {
            NSString* file = [NSString stringWithFormat:@"Elf Throw%d/Elf%d_throw_%d.%02d.png",k,type - EnemiesTypeElfSneak_4,k, i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [animationFrames addObject:frame];
        }
        if (k == 1)
        {
            enemy.animationLowerRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 2)
        {
            enemy.animationUpperRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 3)
        {
            enemy.animationLowerLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else
        {
            enemy.animationUpperLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
    }
    return enemy;
}

- (void) playAnimations
{
    [self schedule:@selector(anim) interval:self.breakTime];
}

- (void) anim{
    CGPoint startPoint = CGPointFromString([self.trajectory objectAtIndex:0]);
    startPoint = [MapCoordinationHelper mapConvertToWorldCoord:startPoint];
    CGPoint finishPoint =CGPointFromString([self.trajectory objectAtIndex:1]);
    finishPoint = [MapCoordinationHelper mapConvertToWorldCoord:finishPoint];
    
    CGFloat angleDirection = CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(finishPoint, startPoint)));
    EMoveDirection direction = [self directionWithAngle:angleDirection];
    
    CCCallFunc *callPlayEffect = [CCCallFunc actionWithTarget:self selector:@selector(playEffect)];
    CCSequence *sequence = [CCSequence actions:callPlayEffect,
                            [self animateWithDirection:direction],
                            //callThrowStone,
                            //[CCActionInterval actionWithDuration:self.breakTime],
                            nil];
    
    CCCallFunc *func = [CCCallFunc actionWithTarget:self selector:@selector(throwStone)];
    CCSequence *seq = [CCSequence actions:[CCDelayTime actionWithDuration:1.2],func, nil];
    [self runAction:seq];
    //[self performSelector:@selector(throwStone) withObject:self afterDelay:1.2];
    //CCRepeatForever *repeatForever = [CCRepeatForever actionWithAction:sequence];
    [self runAction:sequence];
    CGPoint offset = [self getOffsetStonePosition];
    if ([[CCDirector sharedDirector] contentScaleFactor] == 2)
    {
        offset = ccpMult(offset, 2);
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        offset = ccpMult(offset, 0.5);
    }
    
    ccBezierConfig curve;
    curve.controlPoint_1 = ccpAdd(ccpMult(finishPoint, 0.3 ), ccp(0, 5)) ;
    curve.controlPoint_2 = ccpAdd( ccpMult(finishPoint, 0.6 ), ccp(0, 10)) ;
    curve.endPosition = ccpAdd(finishPoint, ccpMult(offset, -1)) ;
    self.stoneCurve = curve;
}

- (void) playEffect
{
    [self.delegate playStoneEffect:self.position];
}

- (void) throwStone
{
    CGPoint finishPoint =CGPointFromString([self.trajectory objectAtIndex:1]);
    finishPoint = [MapCoordinationHelper mapConvertToWorldCoord:finishPoint];
    
    CGPoint offset = [self getOffsetStonePosition];
    if ([[CCDirector sharedDirector] contentScaleFactor] == 2)
    {
        offset = ccpMult(offset, 2);
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        offset = ccpMult(offset, 0.5);
    }
    
    CCSprite *stone = [CCSprite spriteWithFile:@"snowBoll.png"];
    stone.anchorPoint = ccp(0.5 - offset.x / stone.boundingBox.size.width /[[CCDirector sharedDirector] contentScaleFactor],
                            0.5 - offset.y / stone.boundingBox.size.height/[[CCDirector sharedDirector] contentScaleFactor]);

    stone.position = self.position;
    stone.vertexZ = self.vertexZ - 1;
    
    CGFloat speed = 400;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        speed *= 2;
    }
    ccTime timeMove = ccpDistance(stone.position, ccpAdd(stone.position, finishPoint)) / speed;
    
    CCMoveTo *move = [CCMoveTo actionWithDuration:timeMove position:ccpAdd(stone.position, finishPoint)];
    //CCBezierBy *move = [CCBezierBy actionWithDuration:timeMove bezier:self.stoneCurve];
    CCEaseSineOut *ease = [CCEaseSineOut actionWithAction:move];
    
    CCCallFuncN * finish = [CCCallFuncN actionWithTarget:self selector:@selector(finishMove:)];
    [stone runAction:[CCSequence actions: ease ,finish, nil]];
    [stone runAction:[CCEaseOut actionWithAction:[CCFadeOut actionWithDuration:timeMove] rate:0.1]];
    
    [self.delegate addProjectile:stone];
}

-(void) finishMove:(id)sender
{
    [self.delegate deleteProjectile:sender];
    [sender removeFromParentAndCleanup:YES];
}

-(CGPoint) getOffsetStonePosition
{
    CGPoint offset;
    CGPoint startPoint = CGPointFromString([self.trajectory objectAtIndex:0]);
    startPoint = [MapCoordinationHelper mapConvertToWorldCoord:startPoint];
    
    CGPoint finishPoint = CGPointFromString([self.trajectory objectAtIndex:1]);
    finishPoint = [MapCoordinationHelper mapConvertToWorldCoord:finishPoint];
    
    CGFloat angleDirection = CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(finishPoint, startPoint)));
    EMoveDirection direction = [self directionWithAngle:angleDirection];
    if (direction == MoveDirectionUpperRight)
    {
        offset = ccp(56, 73);
    }
    else if (direction == MoveDirectionUpperLeft)
    {
        offset = ccp(-27, 87);
    }
    else if (direction == MoveDirectionLowerLeft)
    {
        offset = ccp(-48, 43);
    }
    else if (direction == MoveDirectionLowerRight)
    {
        offset = ccp(11, 3);
    }
    return offset;
}

@end
