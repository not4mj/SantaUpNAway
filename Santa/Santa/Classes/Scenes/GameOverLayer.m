//
//  GameOverLayer.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation GameOverLayer

- (id) init
{
    if (self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverSprites.plist"];

        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"backgroundGameLose.jpg"];
        background.position = ccp(screenSize.width / 2, screenSize.height * 1.5);
        [self addChild:background];
        
  
    
        CCSprite *restartSprite = [CCSprite spriteWithSpriteFrameName:@"restart norrmal.png"];
        CCSprite *restartSelSprite = [CCSprite spriteWithSpriteFrameName:@"restart prees.png"];
        CCMenuItemSprite *restartItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:restartSprite 
                                         selectedSprite:restartSelSprite 
                                         target:self
                                         selector:@selector(onRestart)];
        restartItem.position = ccp(screenSize.width * (-196) / 480,screenSize.height * (-126) / 320);
        
        CCSprite *menuSprite = [CCSprite spriteWithSpriteFrameName:@"menu_normal.png"];
        CCSprite *menuSelSprite = [CCSprite spriteWithSpriteFrameName:@"menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:menuSprite 
                                         selectedSprite:menuSelSprite 
                                         target:self 
                                         selector:@selector(onMenu)];
        menuItem.position = ccp(screenSize.width * 117 / 480,screenSize.height * (-127) / 320);
        
        CCMenu *menu = [CCMenu menuWithItems:restartItem,menuItem, nil];
        [background addChild:menu];
        
        CCMoveTo *moveDown = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width / 2, screenSize.height / 2)];
        [background runAction:[CCEaseIn actionWithAction:moveDown rate:0.2]];
    }
    return self;
}

- (void) onRestart
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchRestartLevel];
}

- (void) onMenu
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}

- (void) onNextLevel
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchNextLevel];
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"gameOverSprites.plist"];
    [super dealloc];
}
@end
