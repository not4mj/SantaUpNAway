//
//  ElfSneak_3.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElfSneak_3.h"


@implementation ElfSneak_3
+ (ElfSneak_3 *) elf
{
    ElfSneak_3 *elf = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Elf_%02d_Animation.plist",2]];
    
    elf = [[[ElfSneak_3 alloc] initWithSpriteFrameName:@"Elf Sneak1/Elf3_sneak_1.01.png"] autorelease];
    elf.speed = 60;
    elf.type = 2;
    
    CGFloat timeOneFrame = 1.0/10;//1/13
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
        for (NSUInteger i = 1; i < 7; i++)
        {
            NSString* file = [NSString stringWithFormat:@"Elf Sneak%d/Elf3_sneak_%d.%02d.png",k,k, i];
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
            elf.animationLowerLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
        else
        {
            elf.animationUpperLeft = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
        }
    }
    return elf;
}
@end
