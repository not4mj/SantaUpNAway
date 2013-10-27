//
//  SelectGame.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectGame.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation SelectGame
+ (id) scene
{
    CCScene *scene = [CCScene node];
    SelectGame *layer = [SelectGame node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init]))
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selectGame.plist"];
        
//        CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
//        [sharedFileUtils setiPadSuffix:@"-ipad"];
        
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

        CCSprite *nextLevelSprite = [CCSprite spriteWithSpriteFrameName:@"city.png"];
        CCSprite *nextLevelSelSprite = [CCSprite spriteWithSpriteFrameName:@"city_pressed.png"];
        CCMenuItemSprite *nextLevelItem = [CCMenuItemSprite itemWithNormalSprite:nextLevelSprite
                                                                selectedSprite:nextLevelSelSprite
                                                                        target:self
                                                                      selector:@selector(onSelectLevel)];

        
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"jungle.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"jungle_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemWithNormalSprite:MenuButton
                                                             selectedSprite:MenuSelButton
                                                                     target:self
                                                                   selector:@selector(onSelectLevel)];
        

        CCSprite *BackButton = [CCSprite spriteWithSpriteFrameName:@"back normal.png"];
        CCSprite *BackSelButton = [CCSprite spriteWithSpriteFrameName:@"back pressed.png"];
        CCMenuItemSprite *BackItem = [CCMenuItemSprite itemWithNormalSprite:BackButton selectedSprite:BackSelButton target:self selector:@selector(onBack)];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            nextLevelItem.position = [self posIphoneToPersent:ccp(228, 475)];
            menuItem.position = [self posIphoneToPersent:ccp(248, 564)];
            BackItem.position = [self posIphoneToPersent:ccp(214, 71)];
        }
        else
        {
            nextLevelItem.position = [self posToPersent:ccp(516, 1136)];
            menuItem.position = [self posToPersent:ccp(587, 1359)];
            BackItem.position = [self posIphoneToPersent:ccp(412, 155)];
        }
        
    
        CCMenu *menu = [CCMenu menuWithItems:nextLevelItem, menuItem,BackItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu z:10];
}
    return self;
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


- (void) onSelectLevel
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchChoiceLevelPack];
}


- (void) onBack
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
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
