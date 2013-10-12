//
//  Glasses.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Glasses.h"


@implementation Glasses

+ (Glasses *) glassesWithType:(GlassesType)type
{
    Glasses *glasses = nil;
    
    NSString *jumpGlasse = [NSString stringWithFormat:@"glassesJumpAnimations_%02d.plist",type];
 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:jumpGlasse];
    NSString *idleGlasse = [NSString stringWithFormat:@"glassesIdleAnimations_%02d.plist",type];
 
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:idleGlasse];
    
    glasses = [[[Glasses alloc] initWithSpriteFrameName:@"glasses1/move_1.01.png"] autorelease];
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationJumpFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationIdleFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        for (NSUInteger i = 1; i < 10; i++)
        {
            NSString* fileJump = [NSString stringWithFormat:@"glasses%d/move_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameJump = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
            [animationJumpFrames addObject:frameJump];
            
            NSString* fileIdle = [NSString stringWithFormat:@"glasses%d/idle_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileIdle];
            [animationIdleFrames addObject:frameIdle];
        }
        if (k == 1)
        {
            glasses.animationJumpLowerRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            glasses.animationIdleLowerRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 2)
        {
            glasses.animationJumpUpperRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            glasses.animationIdleUpperRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 3)
        {
            glasses.animationJumpLowerLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            glasses.animationIdleLowerLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
            
        }
        else
        {
            glasses.animationJumpUpperLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            glasses.animationIdleUpperLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
    }
    return glasses;
}
@end
