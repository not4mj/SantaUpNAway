//
//  Satchel.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Satchel.h"


@implementation Satchel

+ (Satchel *) satchelWithType:(SatchelType)type
{
    Satchel *satchel = nil;
    
    NSString *jumpSatchel = [NSString stringWithFormat:@"satchelJumpAnimations_%02d.plist",type];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:jumpSatchel];
    NSString *idleSatchel = [NSString stringWithFormat:@"satchelIdleAnimations_%02d.plist",type];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:idleSatchel];
    
    satchel = [[[Satchel alloc] initWithSpriteFrameName:@"satchel1/satchle_jump_1.01.png"] autorelease];
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationJumpFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSMutableArray *animationIdleFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        for (NSUInteger i = 1; i < 10; i++)
        {
            NSString* fileJump = [NSString stringWithFormat:@"satchel%d/satchle_jump_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameJump = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
            [animationJumpFrames addObject:frameJump];
            
            NSString* fileIdle = [NSString stringWithFormat:@"satchel%d/satchle_idle_%d.%02d.png",k,k, i];
            CCSpriteFrame* frameIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileIdle];
            [animationIdleFrames addObject:frameIdle];
        }
        if (k == 1)
        {
            satchel.animationJumpLowerRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            satchel.animationIdleLowerRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 2)
        {
            satchel.animationJumpUpperRight = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            satchel.animationIdleUpperRight = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
        else if (k == 3)
        {
            satchel.animationJumpLowerLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            satchel.animationIdleLowerLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
            
        }
        else
        {
            satchel.animationJumpUpperLeft = [CCAnimation animationWithSpriteFrames:animationJumpFrames delay:1.0 / 15];
            satchel.animationIdleUpperLeft = [CCAnimation animationWithSpriteFrames:animationIdleFrames delay:1.0 / 15];
        }
    }
    return satchel;
}
@end
