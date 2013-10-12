//
//  SneakEnemy.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SneakEnemy.h"


@implementation SneakEnemy
+ (SneakEnemy*) sneakEnemyWithType:(EnemiesType ) type
{
    SneakEnemy *sneakEnemy = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Elf_%02d_Animation.plist",type]];
    
    NSString *firstSpriteName = [NSString stringWithFormat:@"Elf Sneak1/Elf%d_sneak_1.01.png",type];
    sneakEnemy = [[[SneakEnemy alloc] initWithSpriteFrameName:firstSpriteName] autorelease];
    sneakEnemy.type = type;
    sneakEnemy.speed = [sneakEnemy speed];
    
    CGFloat timeOneFrame = 1.0/10;//1/13
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
        for (NSUInteger i = 1; i < 7; i++)
        {
            NSString* file = [NSString stringWithFormat:@"Elf Sneak%d/Elf%d_sneak_%d.%02d.png",k,type,k, i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [animationFrames addObject:frame];
        }
        if (k == 1)
        {
            sneakEnemy.animationLowerRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 2)
        {
            sneakEnemy.animationUpperRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 3)
        {
            sneakEnemy.animationLowerLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else
        {
            sneakEnemy.animationUpperLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
    }
    return sneakEnemy;
}

- (CGPoint) anchorPoint
{
    CGPoint anchorPoint;
    if (self.type == EnemiesTypeElfSneak_1)
    {
        anchorPoint = ccp(0.5, 0.5);
    }
    else if (self.type == EnemiesTypeElfSneak_2)
    {
        anchorPoint = ccp(0.525, 0.36);
    }
    else if (self.type == EnemiesTypeElfSneak_3)
    {
        anchorPoint = ccp(0.525, 0.36);
    }
    else if (self.type == EnemiesTypeElfSneak_4)
    {
        anchorPoint = ccp(0.5, 0.5);
    }
    return anchorPoint;
}

- (CGFloat) speed
{
    CGFloat speed;
    if (self.type == EnemiesTypeElfSneak_1)
    {
        speed = 75;
    }
    else if (self.type == EnemiesTypeElfSneak_2)
    {
        speed = 40;
    }
    else if (self.type == EnemiesTypeElfSneak_3)
    {
        speed = 60;
    }
    else if (self.type == EnemiesTypeElfSneak_4)
    {
        speed = 70;
    }
    return speed;
}
@end
