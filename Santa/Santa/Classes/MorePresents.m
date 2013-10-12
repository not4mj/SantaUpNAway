//
//  MorePresents.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MorePresents.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation MorePresents
+ (id) sceneWithTime:(NSInteger) time
{
    CCScene *scene = [CCScene node];
    MorePresents *layer = [[[MorePresents alloc] initWithTime:time] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id) initWithTime:(NSInteger) time
{
	if ((self=[super init]))
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"morePresents.plist"];
        
        CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
        [sharedFileUtils setiPadSuffix:@"-ipad"];
        
        CCSprite *background;
        if (screenSize.width == 568)
        {
            background = [CCSprite spriteWithFile:@"choose stage background-5hd.png"];
        }
        else{
            background = [CCSprite spriteWithFile:@"choose stage background.png"];
        }
        
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
        
        [self addSnow];

        CCSprite *nextLevelSprite = [CCSprite spriteWithSpriteFrameName:@"mp_next level_normal.png"];
        CCSprite *nextLevelSelSprite = [CCSprite spriteWithSpriteFrameName:@"mp_next level_pressed.png"];
        CCMenuItemSprite *nextLevelItem = [CCMenuItemSprite itemWithNormalSprite:nextLevelSprite
                                                                selectedSprite:nextLevelSelSprite
                                                                        target:self
                                                                      selector:@selector(onNextLevel)];

        
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"mp_menu_normal.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"mp_menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:MenuButton
                                                             selectedSprite:MenuSelButton
                                                                     target:self
                                                                   selector:@selector(onMenu)];
        
        CCSprite *restartSprite = [CCSprite spriteWithSpriteFrameName:@"mp_restart_normal.png"];
        CCSprite *restartSelSprite = [CCSprite spriteWithSpriteFrameName:@"mp_restart_pressed.png"];
        CCMenuItemSprite *restartItem = [CCMenuItemSprite itemWithNormalSprite:restartSprite
                                                                selectedSprite:restartSelSprite
                                                                        target:self
                                                                      selector:@selector(onRestart)];

        CCSprite *timeSprite = [CCSprite spriteWithSpriteFrameName:@"time.png"];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            nextLevelItem.position = [self posIphoneToPersent:ccp(228, 475)];
            menuItem.position = [self posIphoneToPersent:ccp(248, 564)];
            restartItem.position = [self posIphoneToPersent:ccp(870, 77)];
            timeSprite.position = [self posIphoneToPersent:ccp(632, 93)];
        }
        else
        {
            nextLevelItem.position = [self posToPersent:ccp(516, 1136)];
            menuItem.position = [self posToPersent:ccp(587, 1359)];
            restartItem.position = [self posToPersent:ccp(1854, 186)];
            timeSprite.position = [self posIphoneToPersent:ccp(1339, 204)];
        }
        CCMenu *menu = [CCMenu menuWithItems:nextLevelItem, menuItem, restartItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
        
        [self addChild:timeSprite];
        
        CCLabelBMFont *timeLabel = [CCLabelBMFont labelWithString:[self updateTimeLabel:time] fntFile:@"MuseoFont_28.fnt"];
        timeLabel.position = timeSprite.position;
        [self addChild:timeLabel];
        
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        NSString *timeKey = [NSString stringWithFormat:@"Time_In_Level_%d",[delegate.currentLevel intValue]];
        
        if (time < [[NSUserDefaults standardUserDefaults] integerForKey:timeKey])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:time forKey:timeKey];
            
            CGSize screenSize = [[CCDirector sharedDirector] winSize];

            CCSprite *record = [CCSprite spriteWithSpriteFrameName:@"New Record.png"];
            record.scale = 0.1;
            
            CCScaleTo *scale = [CCScaleTo actionWithDuration:2.0 scale:1.0];
            CCEaseElasticOut *ease = [CCEaseElasticOut actionWithAction:scale period:0.2];
            
            record.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:record];
            [record runAction:ease];
        }
    

    }
    return self;
}

- (NSString*) updateTimeLabel:(NSInteger) remainingTime
{
    int minutes = remainingTime / 60;
    int seconds = remainingTime % 60;
    NSString *time;
    if (remainingTime < 0)
    {
        seconds = abs(seconds);
        time = [NSString stringWithFormat:@"-%02d:%02d",minutes,seconds];
    }
    else
    {
        time = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    return time;
}

- (void) addSnow
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCParticleSystemQuad *snowParticle = [CCParticleSystemQuad particleWithFile:@"snowMenu.plist"];
    snowParticle.position = ccp(screenSize.width / 2, screenSize.height * 1.1);
    [snowParticle setPosVar:ccp(screenSize.width, 0)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        snowParticle.scale /= 2;
    }
    
    [self addChild:snowParticle];
}

- (void) onRestart
{
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
    [sharedFileUtils setiPadSuffix:@"-hd"];
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
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
    [sharedFileUtils setiPadSuffix:@"-hd"];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchNextLevel];
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
@end
