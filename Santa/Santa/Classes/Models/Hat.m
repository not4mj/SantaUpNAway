//
//  Hat.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Hat.h"


@implementation Hat


+ (Hat *) hatWithType:(HatType)type
{
    Hat *hat = nil;
    
    NSString *jumpHat = [NSString stringWithFormat:@"hatJumpAnimations_%02d.plist",type];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:jumpHat];
    NSString *idleHat = [NSString stringWithFormat:@"hatIdleAnimations_%02d.plist",type];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:idleHat];
    
    hat = [[[Hat alloc] initWithSpriteFrameName:@"cap1/cap_move_1.01.png"] autorelease];
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationJumpFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationIdleFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        for (NSUInteger i = 1; i < 10; i++)
        {
            NSString* fileJump = [NSString stringWithFormat:@"cap%d/cap_move_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameJump = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
            [animationJumpFrames addObject:frameJump];
            
            NSString* fileIdle = [NSString stringWithFormat:@"idle_cap%d/cap_idle_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileIdle];
            [animationIdleFrames addObject:frameIdle];
        }
        if (k == 1)
        {
            hat.animationJumpLowerRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            hat.animationIdleLowerRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 2)
        {
            hat.animationJumpUpperRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            hat.animationIdleUpperRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 3)
        {
            hat.animationJumpLowerLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            hat.animationIdleLowerLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
            
        }
        else
        {
            hat.animationJumpUpperLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            hat.animationIdleUpperLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
    }
    return hat;
}
@end
