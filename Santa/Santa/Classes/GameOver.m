//
//  GameOver.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation GameOver
+ (id) scene
{
    CCScene *scene = [CCScene node];
    GameOver *layer = [GameOver node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init]))
	{
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"morePresents.plist"];
        
        CCSprite *background;
        if (screenSize.width == 568)
        {
            background = [CCSprite spriteWithFile:@"Up and Away-5hd.png"];
        }
        else{
            background = [CCSprite spriteWithFile:@"Up and Away.png"];
        }
        
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
        
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"mp_menu_normal.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"mp_menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:MenuButton
                                                             selectedSprite:MenuSelButton
                                                                     target:self
                                                                   selector:@selector(onMenu)];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            menuItem.position =  [self posIphoneToPersent:ccp(205, 564)];
        }
        else
        {
            menuItem.position =  [self posToPersent:ccp(429, 1390)];
        }


        CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
    }
    return self;
}

- (CGPoint) posToPersent:(CGPoint) pos
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    return ccp(screenSize.width * (pos.x / 2048),screenSize.height * (1536 - pos.y) / 1536);
}

- (CGPoint) posIphoneToPersent:(CGPoint) pos
{
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    BOOL isIphone5 = NO;
    if (screenSize.width == 568)
    {
        isIphone5 = YES;
        screenSize.width = 480;
    }
    CGPoint newPos = ccp(screenSize.width * (pos.x / 960),screenSize.height * (640 - pos.y) / 640);
    if (isIphone5)
    {
        newPos = ccpAdd(newPos, ccp(44, 0));
    }
    return newPos;
}

- (void) onMenu
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}

@end
