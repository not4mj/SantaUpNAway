//
//  Elf.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Elf.h"


@implementation Elf
+ (Elf *) elf:(EnemiesType) type
{
    Elf *elf = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Elf_%02d_Animation.plist",type]];
    
    elf = [[[Elf alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"Elf Sneak%d/elf%d_walk_1.01.png",type,type]] autorelease];
    elf.speed = 40;
    elf.type = type;
    if (elf.type == EnemiesTypeElf_1)
    {
        elf.anchorPoint = ccp(0.525,1- 0.6275);
    }
    else if (elf.type == EnemiesTypeElf_2)
    {
        elf.anchorPoint = ccp(0.55,1- 0.64);
    }
    else if (elf.type == EnemiesTypeElf_3)
    {
        elf.anchorPoint = ccp(0.52,1- 0.62);
    }
    
    CGFloat timeOneFrame = 1.0/16;//1/13
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
        for (NSUInteger i = 1; i < 14; i++)
        {
            NSString* file = [NSString stringWithFormat:@"elf%d_%d/elf%d_walk_%d.%02d.png",type,k,type,k, i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [animationFrames addObject:frame];
        }
        if (k == 1)
        {
            elf.animationLowerRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 2)
        {
            elf.animationUpperRight = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else if (k == 3)
        {
            elf.animationLowerLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:1.0 / 13];
        }
        else
        {
            elf.animationUpperLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:1.0 / 13];
        }
    }
    return elf;
}
@end
