//
//  MainMenu.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "AppDelegate.h"

@interface MainMenu ()

@end

@implementation MainMenu

- (void) didLoadFromCCB
{
    
}

+ (id) scene
{
    CCScene *scene = [CCScene node];
    MainMenu *layer = [MainMenu node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init])) 
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenu.plist"];
      
        CCSprite *background = [CCSprite spriteWithFile:@"MenuScreen_background.png"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];

//        CCSprite *itemNormalSprite = [CCSprite spriteWithFile:@"onePixel.png" rect:CGRectMake(0, 0, itemSprite.boundingBox.size.width, itemSprite.boundingBox.size.height)];
//        itemNormalSprite.opacity = 0;
        
        CCSprite *startGameSelSprite = [CCSprite spriteWithSpriteFrameName:@"start game_pressed.png"];
        CCSprite *startGameNormSprite = [CCSprite spriteWithFile:@"start game_pressed.png" rect:CGRectMake(0, 0, startGameSelSprite.boundingBox.size.width, startGameSelSprite.boundingBox.size.height)];
        startGameNormSprite.opacity = 0;
        CCMenuItemSprite *startGameItem = [CCMenuItemSprite itemWithNormalSprite:startGameNormSprite selectedSprite:startGameSelSprite
                                                                          target:self
                                                                        selector:@selector(onSelectGame)];
        startGameItem.normalImage = [CCSprite spriteWithSpriteFrameName:@"start game.png"];
        
        CCSprite *infoSelSprite = [CCSprite spriteWithSpriteFrameName:@"info_pressed.png"];
        CCSprite *infoNormSprite = [CCSprite spriteWithFile:@"info_pressed.png" rect:CGRectMake(0, 0, infoSelSprite.boundingBox.size. width, infoSelSprite.boundingBox.size.height)];
        infoNormSprite.opacity = 0;
       CCMenuItemSprite *infoItem = [CCMenuItemSprite itemWithNormalSprite:infoNormSprite selectedSprite:infoSelSprite
                                                                    target:self
                                                                  selector:@selector(onInfo)];
        
       // if (![[NSUserDefaults standardUserDefaults] boolForKey:@"noDistinguishInfo"])
        //{
            infoItem.normalImage = [CCSprite spriteWithSpriteFrameName:@"info.png"];
            
//            CCScaleBy *scale = [CCScaleBy actionWithDuration:0.5 scale:1.2];
//            CCSequence *sequence = [CCSequence actions:scale, [scale reverse], nil];
//            CCRepeatForever *repeat = [CCRepeatForever actionWithAction:sequence];
//            
//            [infoItem runAction:repeat];
        //}
        
        
        CCSprite *optionsSelSprite = [CCSprite spriteWithSpriteFrameName:@"time machine pressed.png"];
        CCSprite *optionsNormSprite = [CCSprite spriteWithFile:@"time machine pressed.png" rect:CGRectMake(0, 0, optionsSelSprite.boundingBox.size.width, optionsSelSprite.boundingBox.size.height)];
        optionsNormSprite.opacity = 0;
        CCMenuItemSprite *optionsItem = [CCMenuItemSprite itemWithNormalSprite:optionsNormSprite selectedSprite:optionsSelSprite
                                                                        target:self
                                                                      selector:@selector(onOptions)];
        optionsItem.normalImage = [CCSprite spriteWithSpriteFrameName:@"time machine.png"];
        
        CCSprite *moreGamesSelSprite = [CCSprite spriteWithSpriteFrameName:@"more games_presssed.png"];
        CCSprite *moreGamesNormSprite = [CCSprite spriteWithFile:@"more games_presssed.png" rect:CGRectMake(0, 0, moreGamesSelSprite.boundingBox.size.width, moreGamesSelSprite.boundingBox.size.height)];
        moreGamesNormSprite.opacity = 1;
        CCMenuItemSprite *moreGamesItem = [CCMenuItemSprite itemWithNormalSprite:moreGamesNormSprite selectedSprite:moreGamesSelSprite
                                                                          target:self
                                                                        selector:@selector(onMoreGames)];
        moreGamesItem.normalImage=[CCSprite spriteWithSpriteFrameName:@"more games.png"];
        
        
        CCSprite *removeAdsSelSprite = [CCSprite spriteWithSpriteFrameName:@"remove ads_pressed.png"];
        CCSprite *removeAdsNormSprite = [CCSprite spriteWithFile:@"remove ads_pressed.png" rect:CGRectMake(0, 0, removeAdsSelSprite.boundingBox.size.width, removeAdsSelSprite.boundingBox.size.height)];
        removeAdsNormSprite.opacity = 1;
        CCMenuItemSprite *removeAdsItem = [CCMenuItemSprite itemWithNormalSprite:removeAdsNormSprite selectedSprite:removeAdsSelSprite
                                                                          target:self
                                                                        selector:@selector(onRemoveAdsGames)];
        
        removeAdsItem.normalImage=[CCSprite spriteWithSpriteFrameName:@"remove ads.png"];
        
        CCSprite *restorePurchaseSelSprite = [CCSprite spriteWithSpriteFrameName:@"restore purchase_pressed.png"];
        CCSprite *restorePurchaseNormSprite = [CCSprite spriteWithFile:@"restore purchase_pressed.png" rect:CGRectMake(0, 0, restorePurchaseSelSprite.boundingBox.size.width, restorePurchaseSelSprite.boundingBox.size.height)];
        restorePurchaseNormSprite.opacity = 1;
        CCMenuItemSprite *restorePurchaseItem = [CCMenuItemSprite itemWithNormalSprite:restorePurchaseNormSprite selectedSprite:restorePurchaseSelSprite target:self selector:@selector(onMoreGames)];
        
        restorePurchaseItem.normalImage=[CCSprite spriteWithSpriteFrameName:@"restore purchase.png"];
        
        CCSprite *soundsSelSprite = [CCSprite spriteWithSpriteFrameName:@"sound_pressed.png"];
        CCSprite *soundsNormSprite = [CCSprite spriteWithFile:@"sound_pressed.png" rect:CGRectMake(0, 0, soundsSelSprite.boundingBox.size.width, soundsSelSprite.boundingBox.size.height)];
        soundsNormSprite.opacity = 1;
        CCMenuItemSprite *soundsItem = [CCMenuItemSprite itemWithNormalSprite:soundsNormSprite selectedSprite:soundsSelSprite target:self selector:@selector(onMoreGames)];
        
        soundsItem.normalImage=[CCSprite spriteWithSpriteFrameName:@"sound.png"];
        

        
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            infoItem.position = [self posIphoneToPersent:ccp(62, 447)];
            optionsItem.position = [self posIphoneToPersent:ccp(67, 576)];
            startGameItem.position = [self posIphoneToPersent:ccp(622, 590)];
            moreGamesItem.position = [self posIphoneToPersent:ccp(882, 580)];
            removeAdsItem.position=[self posIphoneToPersent:ccp(992,600)];
            restorePurchaseItem.position=[self posIphoneToPersent:ccp(1000,610)];
            soundsItem.position=[self posIphoneToPersent:ccp(1100,630)];
            
        }
        else
        {
            infoItem.position = [self posToPersent:ccp(1200, 750)];
            optionsItem.position = [self posToPersent:ccp(1200, 965)];
            startGameItem.position = [self posToPersent:ccp(1200, 530)];
            moreGamesItem.position = [self posToPersent:ccp(1700, 1150)];
            removeAdsItem.position=[self posToPersent:ccp(1750,230)];
            restorePurchaseItem.position=[self posToPersent:ccp(1720,510)];
            soundsItem.position=[self posToPersent:ccp(200,1210)];
        }
        CCMenu *menu = [CCMenu menuWithItems:soundsItem,restorePurchaseItem,removeAdsItem,moreGamesItem,startGameItem,optionsItem,infoItem, nil];
        menu.position = ccp(0, 0);
        [self addChild:menu];
        
        //[[DDGameKitHelper sharedGameKitHelper] authenticateLocalPlayer];
        [self addSnow];
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

- (void) onEnter
{
    NSLog(@"onEnter");
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) 
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Main_menu.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:
         [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeMusic"]];
    }

    [super onEnter];
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"MainMenu.plist"];
    [super dealloc];
}

- (void) onStartGame
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchChoiceLevelPack];
}

-(void)onSelectGame
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchSelectGame];
    
}

- (void) onInfo
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"noDistinguishInfo"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noDistinguishInfo"];
        [infoItem stopAllActions];
        CCSprite *infoSelSprite = [CCSprite spriteWithSpriteFrameName:@"info.png"];
        CCSprite *infoNormSprite =  [CCSprite spriteWithFile:@"onePixel.png" rect:CGRectMake(0, 0, infoSelSprite.boundingBox.size.width, infoSelSprite.boundingBox.size.height)];
        infoNormSprite.opacity = 0;
        infoItem.normalImage = infoNormSprite;
    }
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchInfo];
    
    //4mnow News Letter Signup
    //[delegate fmnowLaunchNews];
}

- (void) onOptions
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchOptions];
}


- (void) onMoreGames
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate nmaLaunchMoreGames];

    // Launch 4mnow More Screen
    //[delegate fmnowLaunchMoreGames];
}
@end
