//
//  Reindeer.m
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Reindeer.h"


@implementation Reindeer

+ (Reindeer*) reindeerWithDirection:(EMoveDirection)direction
{
    Reindeer *reindeer = nil;
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:[NSString stringWithFormat:@"ReindeerAnimations_%02d.plist",direction] ];
    reindeer = [[[Reindeer alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"reindeer%d.swf/0000",direction]]autorelease];
    
//   x больле левее Y больше ниже
    reindeer.anchorPoint = ccp(0.43, 0.58);
    NSMutableArray *animationStandFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease] ;
    for (NSUInteger i = 0; i < 12; i++)
    {
        NSString* file = [NSString stringWithFormat:@"reindeer%d.swf/%04d",direction,i];
        CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
        [animationStandFrames addObject:frame];
    }
    
    CCAnimation *animationStand = [CCAnimation animationWithSpriteFrames:animationStandFrames delay:1.0 / 5.0];
    CCAnimate *animateStand = [CCAnimate actionWithAnimation:animationStand];
    [reindeer runAction: [CCRepeatForever actionWithAction:animateStand]];
    

    return reindeer;
}
- (CGPoint) anchorPointWithDirection:(EMoveDirection) direction
{
    CGPoint point = CGPointZero;
    if (direction == MoveDirectionUpperLeft )
    {
        
    }
    else if(direction == MoveDirectionLowerLeft )
    {
        
    }
    else if(direction == MoveDirectionUpperRight )
    {
        
    }
    else if(direction == MoveDirectionLowerRight )
    {
        
    }
    return point;
}
@end
