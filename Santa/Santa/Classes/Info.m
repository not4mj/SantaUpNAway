//
//  Info.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Info.h"
#import "AppDelegate.h"
#import "MainMenu.h"
@implementation Info
+ (id) scene
{
    CCScene *scene = [CCScene node];
    Info *layer = [Info node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init]))
	{
        self.isTouchEnabled = YES;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"Info Screen.jpg"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
    }
    return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.4 scene:[MainMenu scene]]];
}
@end
