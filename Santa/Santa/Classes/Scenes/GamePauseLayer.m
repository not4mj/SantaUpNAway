//
//  GamePauseLayer.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePauseLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation GamePauseLayer

- (id) init
{
   NSLog(@"init pause");
    if (self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverSprites.plist"];
        
        ccColor4B blackColor = {0, 0, 0, 0};
        layerBlack = [CCLayerColor layerWithColor:blackColor];
        [self addChild:layerBlack];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];

        background = [CCSprite spriteWithSpriteFrameName:@"pause_window.png"];
        background.position = ccp(screenSize.width * 1.5, screenSize.height / 2);
        [self addChild:background];
        
        CCSprite *restartSprite = [CCSprite spriteWithSpriteFrameName:@"restart norrmal.png"];
        CCSprite *restartSelSprite = [CCSprite spriteWithSpriteFrameName:@"restart prees.png"];
        CCMenuItemSprite *restartItem = [CCMenuItemSprite itemWithNormalSprite:restartSprite
                                                                selectedSprite:restartSelSprite
                                                                        target:self
                                                                      selector:@selector(onRestart)];
        
        CCMenu *restartMenu = [CCMenu menuWithItems:restartItem, nil];
        restartMenu.position = ccp(background.boundingBox.size.width * 0.85,background.boundingBox.size.height * 0.2);
        [background addChild:restartMenu];
        
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"menu_normal.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:MenuButton selectedSprite:MenuSelButton target:self selector:@selector(onMenu)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
        menu.position = ccp(background.boundingBox.size.width * 0.28,background.boundingBox.size.height * 0.5);
        [background addChild:menu];
        
        [layerBlack runAction:[CCFadeTo actionWithDuration:0.3 opacity:100]];
        
        CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:0.3f position:ccp(screenSize.width / 2, screenSize.height / 2)];
        
        CCCallFuncN *callStopDirector = [CCCallBlock actionWithBlock:^{
            [[CCDirector sharedDirector] pause];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPaused"];
        
        [background runAction:[CCSequence actions:[CCEaseBackOut actionWithAction:moveLeft],callStopDirector, nil]];
        
    }
    return self;
}

- (void) removeLayer
{
    NSLog(@"removeLayer pause");
    [[CCDirector sharedDirector] resume];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPaused"];
    [layerBlack runAction:[CCFadeTo actionWithDuration:0.4 opacity:0]];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCMoveTo *moveLeft = [CCMoveTo actionWithDuration:0.4f position:ccp( - screenSize.width / 2, screenSize.height / 2)];
    CCCallBlock *remove = [CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }];
    CCSequence *sequence = [CCSequence actions:[CCEaseOut actionWithAction:moveLeft rate:0.2],remove, nil];
    [background runAction: sequence];
}

- (void) dealloc
{
    NSLog(@"dealloc pause");
    [super dealloc];
}
- (void) onRestart
{
    [[CCDirector sharedDirector] resume];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPaused"];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchRestartLevel];
    
}

- (void) onMenu
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector] resume];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isPaused"];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}
@end
