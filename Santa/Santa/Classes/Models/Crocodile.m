//
//  Crocodile.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Crocodile.h"
#import "MapCoordinationHelper.h"

@implementation Crocodile
@synthesize trajectory;
@synthesize gold;
@synthesize speed;
@synthesize goToFinish;
@synthesize startPosition;
@synthesize withPlayer;

@synthesize animationRotationToUpperLeft;
@synthesize animationRotationToLowerRight;

+ (Crocodile*) crocodile
{
    Crocodile *crocodile = nil;
  
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"WalrusAnimation.plist"];
    

    crocodile = [Crocodile spriteWithSpriteFrameName:@"walrus run1.swf/0000"];
        

    
    NSMutableArray *animationUpperLeftFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    NSMutableArray *animationLowerRightFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
    for (NSUInteger i = 0; i < 8; i++)
    {
        NSString* fileUpperLeft = [NSString stringWithFormat:@"walrus run1.swf/%04d", i];
        NSString* fileLowerRight = [NSString stringWithFormat:@"walrus run2.swf/%04d", i];
       
        
        CCSpriteFrame* frameUpperLeft = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileUpperLeft];
        [animationUpperLeftFrames addObject:frameUpperLeft];
        
        CCSpriteFrame* frameLowerRight = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileLowerRight];
        [animationLowerRightFrames addObject:frameLowerRight];
    }
    CGFloat moveWolkTime = 0.125;
  
    crocodile.animationRotationToUpperLeft = [CCAnimation animationWithSpriteFrames:animationUpperLeftFrames delay:moveWolkTime];
    crocodile.animationRotationToLowerRight = [CCAnimation animationWithSpriteFrames:animationLowerRightFrames delay:moveWolkTime];
    
    crocodile.vertexZ = -800;
    crocodile.speed = 50;
    crocodile.goToFinish = NO;
    crocodile.withPlayer = NO;
    return crocodile;
}

- (void) rotationUpperLeft
{
    [self stopActionByTag:10];
    [self stopActionByTag:11];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:self.animationRotationToUpperLeft];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
    repeat.tag = 10;

    
    [self runAction:repeat];
}

- (void) rotationLowerRight
{
    [self stopActionByTag:10];
    [self stopActionByTag:11];
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:self.animationRotationToLowerRight];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
    repeat.tag = 11;
    
    [self runAction:repeat];
}
@end