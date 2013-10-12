//
//  Arrow.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Arrow.h"


@implementation Arrow
@synthesize animationUpperLeft;
@synthesize animationLowerLeft;
@synthesize animationUpperRight;
@synthesize animationLowerRight;
@synthesize animationNone;

+ (Arrow *) arrow
{
    
    Arrow *arrow = nil;
    
    arrow = [[[Arrow alloc] initWithSpriteFrameName:@"arrow0.png"]autorelease]; 
    for (NSUInteger k = 0; k < 5; k++)
    {
        NSMutableArray *animationFrame = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        NSString* fileJump = [NSString stringWithFormat:@"arrow%d.png",k];
        CCSpriteFrame* frameJump = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
        [animationFrame addObject:frameJump];
        
        if (k == 0)
        {
            arrow.animationNone = [CCAnimation animationWithSpriteFrames:animationFrame delay:1.0 ];
        }
        if (k == 1)
        {
            arrow.animationLowerRight = [CCAnimation animationWithSpriteFrames:animationFrame delay:1.0 ];
    
        }
        else if (k == 2)
        {
            arrow.animationUpperRight = [CCAnimation animationWithSpriteFrames:animationFrame delay:1.0 ];
           
        }
        else if (k == 3)
        {
            arrow.animationLowerLeft = [CCAnimation animationWithSpriteFrames:animationFrame delay:1.0];
        }
        else
        {
            arrow.animationUpperLeft = [CCAnimation animationWithSpriteFrames:animationFrame delay:1.0];
        }
    }
    return arrow;
    
}
@end
