//
//  ElfLaugh.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ElfLaugh.h"


@implementation ElfLaugh
@synthesize animationLaugh;
@synthesize bundle;

+ (ElfLaugh*) elfLaugh
{
    ElfLaugh *elfLaugh = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ElfLaugh.plist"];
    
    elfLaugh = [[[ElfLaugh alloc] initWithSpriteFrameName:@"elf_laugh.swf/0000"] autorelease];

    elfLaugh.opacity = 0;
    
    elfLaugh.bundle = [CCSprite spriteWithFile:@"bubble.png"];
    elfLaugh.bundle.opacity = 0;
    elfLaugh.bundle.position = ccp(elfLaugh.boundingBox.size.width, elfLaugh.boundingBox.size.height);
    elfLaugh.bundle.anchorPoint = ccp(0.5, 0.5);
    [elfLaugh addChild:elfLaugh.bundle];
    
    CGFloat timeOneFrame = 1.0/8;//1/13
 
    NSMutableArray *animationFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
    for (NSUInteger i = 0; i < 24; i++)
    {
        NSString* file = [NSString stringWithFormat:@"elf_laugh.swf/%04d", i];
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [animationFrames addObject:frame];
    }
    
        elfLaugh.animationLaugh = [CCAnimation animationWithSpriteFrames:animationFrames delay:timeOneFrame];
    return elfLaugh;
}

- (void) show
{
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:1.0];
    CCAnimate *animate = [CCAnimate actionWithAnimation:self.animationLaugh];
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1.0];
    
    CCSequence *sequence = [CCSequence actions:fadeIn,animate,fadeOut, nil];
    [self runAction:sequence];
    
    CCSequence *sequenceBundle = [CCSequence actions:[CCFadeIn actionWithDuration:1.0],[CCDelayTime actionWithDuration:3.125],[CCFadeOut actionWithDuration:1.0], nil];
    [self.bundle  runAction:sequenceBundle];
}

@end
