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
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SelectGame.plist"];
        
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

        CCSprite *citySprite = [CCSprite spriteWithSpriteFrameName:@"city.png"];
        CCSprite *citySelSprite = [CCSprite spriteWithSpriteFrameName:@"city_pressed.png"];
        CCMenuItemSprite *cityItem = [CCMenuItemSprite itemWithNormalSprite:citySprite
                                                                selectedSprite:citySelSprite
                                                                        target:self
                                                                      selector:@selector(onSelectLevel)];

        
        CCSprite *jungleButton = [CCSprite spriteWithSpriteFrameName:@"jungle.png"];
        CCSprite *jungleSelButton = [CCSprite spriteWithSpriteFrameName:@"jungle_pressed.png"];
        CCMenuItemSprite *jungleItem = [CCMenuItemSprite itemWithNormalSprite:jungleButton
                                                             selectedSprite:jungleSelButton
                                                                     target:self
                                                                   selector:@selector(onSelectLevel)];
        

        CCSprite *BackButton = [CCSprite spriteWithSpriteFrameName:@"back normal.png"];
        CCSprite *BackSelButton = [CCSprite spriteWithSpriteFrameName:@"back pressed.png"];
        CCMenuItemSprite *BackItem = [CCMenuItemSprite itemWithNormalSprite:BackButton selectedSprite:BackSelButton target:self selector:@selector(onBack)];
        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
             BackItem.position = [self posIphoneToPersent:ccp(470, 235)];
            cityItem.position = [self posIphoneToPersent:ccp(220, 450)];
            jungleItem.position = [self posIphoneToPersent:ccp(730, 450)];
           
        }
        else
        {
            //iPad
            BackItem.position = [self posIphoneToPersent:ccp(470, 235)];
            cityItem.position = [self posToPersent:ccp(420, 1060)];
            jungleItem.position = [self posToPersent:ccp(1610, 1060)];
            
        }
        
    
        CCMenu *menu = [CCMenu menuWithItems:cityItem, jungleItem,BackItem, nil];
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
}@end
