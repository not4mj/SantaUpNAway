//
//  ElfSneak_2.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElfSneak_2.h"


@implementation ElfSneak_2
+ (ElfSneak_2 *) elf
{
    ElfSneak_2 *elf = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"Elf_%02d_Animation.plist",2]];
    
    elf = [[[ElfSneak_2 alloc] initWithSpriteFrameName:@"Elf Sneak1/Elf2_sneak_1.01.png"] autorelease];
    elf.speed = 40;
    elf.type = 2;
    
    CGFloat timeOneFrame = 1.0/10;//1/13
    for (NSUInteger k = 1; k < 5; k++)
    {
        NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
        for (NSUInteger i = 1; i < 7; i++)
        {
            NSString* file = [NSString stringWithFormat:@"Elf Sneak%d/Elf2_sneak_%d.%02d.png",k,k, i];
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
