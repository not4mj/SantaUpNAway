//
//  GameWinLayer.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameWinLayer.h"
#import "AppDelegate.h"


@interface GameWinLayer (Private)
- (void) finishCalculate;
@end

#define priceGoldBar 100
#define priceGoldStone 50

typedef enum
{
    ObjectTypeBar,
    ObjectTypeStone,
    ObjectTypeTime,
} ObjectType;

@implementation GameWinLayer

- (id) initWithGoldBar:(NSInteger)goldBar goldStone:(NSInteger)goldStone time:(NSInteger)time
{
    if (self = [super init])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverSprites.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Coinzer.plist"];
        AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        NSString *collectedGoldKey = [NSString stringWithFormat:@"collectedGoldInPack_%d_level_%d",[delegate.currentLevelPack intValue],[delegate.currentLevel intValue]];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:collectedGoldKey] < goldBar)
            [[NSUserDefaults standardUserDefaults] setInteger:goldBar forKey:collectedGoldKey];
        
        self.isTouchEnabled = YES;  
        
        countGoldBar = goldBar;
        countGoldStone = goldStone;
        countTime = time;
        
        totalRooBucks = countTime + (countGoldStone * priceGoldStone) + (countGoldBar * priceGoldBar);
        
        [[NSUserDefaults standardUserDefaults] setInteger:
        [[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + totalRooBucks forKey:@"RooBucks"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *background = [CCSprite spriteWithFile:@"backgroundGameWin.jpg"];
        background.position = ccp(screenSize.width / 2, screenSize.height * 1.6);
        [self addChild:background];
        
        CCSprite *restartLevelNormSprite = [CCSprite spriteWithSpriteFrameName:@"restart norrmal.png"];
        CCSprite *restartLevelSelSprite = [CCSprite spriteWithSpriteFrameName:@"restart prees.png"];
        CCMenuItemSprite *restartLevelItem = [CCMenuItemSprite 
                                            itemWithNormalSprite:restartLevelNormSprite 
                                            selectedSprite:restartLevelSelSprite 
                                            target:self 
                                            selector:@selector(onRestart)];
        restartLevelItem.position = ccp(screenSize.width * 34 / 480,screenSize.height * 34 / 320);
        
        CCSprite *nextLevelNormSprite = [CCSprite spriteWithSpriteFrameName:@"next level_normal.png"];
        CCSprite *nextLevelSelSprite = [CCSprite spriteWithSpriteFrameName:@"next level_pressed.png"];
        CCMenuItemSprite *nextLevelItem = [CCMenuItemSprite 
                                            itemWithNormalSprite:nextLevelNormSprite 
                                            selectedSprite:nextLevelSelSprite 
                                            target:self 
                                            selector:@selector(onNextLevel)];
        nextLevelItem.position = ccp(screenSize.width * 378 / 480,screenSize.height * 76 / 320);
        
        CCSprite *menuSprite = [CCSprite spriteWithSpriteFrameName:@"menu_normal.png"];
        CCSprite *menuSelSprite = [CCSprite spriteWithSpriteFrameName:@"menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite 
                                      itemWithNormalSprite:menuSprite 
                                      selectedSprite:menuSelSprite 
                                      target:self 
                                      selector:@selector(onMenu)];
        menuItem.position = ccp(screenSize.width * 415 / 480,screenSize.height * 32 / 320);
    
        CCMenu *menu = [CCMenu menuWithItems:menuItem,nextLevelItem,restartLevelItem, nil];
        menu.position = ccp(0, 0);
        [background addChild:menu];

        [delegate openNextLevel];
    
        CCMoveTo *move = [CCMoveTo actionWithDuration:0.5f position:ccp(screenSize.width / 2, screenSize.height / 2)];
        CCEaseIn *easeMove = [CCEaseIn actionWithAction:move rate:0.2];
        CCCallFunc *callScoring = [CCCallFunc actionWithTarget:self selector:@selector(addCoinzer)];
        CCSequence *sequence = [CCSequence actions:easeMove,callScoring, nil];
        [background runAction:sequence];
    }
    return self;
}

- (void) addCoinzer
{
    ccTime addCoinzerTime = 0.4;
    ccColor4B black = {0,0,0,0};
    blackLayer = [CCLayerColor layerWithColor:black];
    [self addChild:blackLayer];
    [blackLayer runAction:[CCSequence actions:[CCFadeTo actionWithDuration:addCoinzerTime opacity:150],
                           [CCCallFunc actionWithTarget:self selector:@selector(scoring)],nil]];
    
    CCSprite *mamaRoo = [CCSprite spriteWithSpriteFrameName:@"mama_roo.png"];
    mamaRoo.opacity = 0;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    mamaRoo.position = ccp(screenSize.width * 233 / 480,screenSize.height * 179 / 320);
    [blackLayer addChild:mamaRoo];
    [mamaRoo runAction:[CCFadeTo actionWithDuration:addCoinzerTime opacity:254]];
    
    CCSprite *border = [CCSprite spriteWithSpriteFrameName:@"border.png"];
    border.opacity = 0;
    border.position = ccp(screenSize.width * 234 / 480,screenSize.height * 56 / 320);
    [blackLayer addChild:border];
    [border runAction:[CCFadeTo actionWithDuration:addCoinzerTime opacity:254]];
    
    CCSprite *coinzerInProgress = [CCSprite spriteWithSpriteFrameName:@"coinzer in progress.png"];
    coinzerInProgress.opacity = 0;
    coinzerInProgress.position = ccp(screenSize.width * 240 / 480,screenSize.height * 34 / 320);
    [blackLayer addChild:coinzerInProgress z:1];
    [coinzerInProgress runAction:[CCFadeTo actionWithDuration:addCoinzerTime opacity:254]];
    
    CCSprite *hat = [CCSprite spriteWithSpriteFrameName:@"hat.png"];
    hat.opacity = 0;
    hat.position = ccp(screenSize.width * 198 / 480,screenSize.height * 141 / 320);
    [blackLayer addChild:hat z:2];
    [hat runAction:[CCFadeTo actionWithDuration:addCoinzerTime opacity:254]];
    
    currentPercent = 0;
    progress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"color.png"]];
	progress.type = kCCProgressTimerTypeBar;
    progress.barChangeRate = ccp(1,0);
    progress.midpoint = ccp(0, 0.5);
	[blackLayer addChild:progress];
	[progress setPosition:ccp(screenSize.width * 236 / 480,screenSize.height * 57 / 320)];

    scorecCharges = [[SimpleAudioEngine sharedEngine] playEffect:@"ScorecCharges.caf"];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (blackLayer.opacity != 0)
    {
       [self finishCalculate]; 
    }
}

- (void) finishCalculate
{
    [[SimpleAudioEngine sharedEngine] stopEffect:scorecCharges];
    [[SimpleAudioEngine sharedEngine] playEffect:@"finichScorecCharges.caf"];
    
    [progress stopAllActions];
    [progress removeFromParentAndCleanup:NO];
    progress = nil;
    [self stopAllActions];

    CCCallBlock *removeChildren = [CCCallBlock actionWithBlock:^{
        for (CCNode *chilren in blackLayer.children) {
            [chilren runAction:[CCFadeOut actionWithDuration:0.3]];
        }
    }];
    [blackLayer runAction:[CCSequence actions:removeChildren,[CCFadeTo actionWithDuration:0.3 opacity:0], nil]];


    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    NSString *totalCoinsString = [NSString stringWithFormat:@"ROO BUCKS: %d",[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"]];
    totalCoins = [CCLabelBMFont labelWithString:totalCoinsString fntFile:@"Futura_20.fnt"];
    totalCoins.position = ccp(screenSize.width * 186 / 480,screenSize.height * 64 / 320);
    [self addChild:totalCoins];
}

-(void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"gameOverSprites.plist"];
    [super dealloc];
}
     
- (void) addObjectInHatWithType:(NSNumber*) type
{
    if (progress == nil)
    {   
        return;
    }
    
    CCSprite *object;
    if ([type intValue] == ObjectTypeBar ) 
    {
        object = [CCSprite spriteWithSpriteFrameName:@"goldBar.png"];
    }
    else if ([type intValue] == ObjectTypeStone){
        object = [CCSprite spriteWithSpriteFrameName:@"goldStone.png"];
    }
    else {
        object = [CCSprite spriteWithSpriteFrameName:@"time.png"];
    }
    object.opacity = 0;
    object.scale = 0;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGFloat posX = 90 +  arc4random() % (120);
    posX = screenSize.width * posX / 480;
    object.position = ccp(posX,screenSize.height * 270 / 320);
    [blackLayer addChild:object];
    [object runAction:[CCFadeIn actionWithDuration:0.3]];
    [object runAction:[CCScaleTo actionWithDuration:0.2 scale:1.0]];
    
    ccBezierConfig curve;
    curve.controlPoint_1 = object.position;
    curve.controlPoint_2 = ccp(screenSize.width * 198 / 480,screenSize.height * 173 / 320) ;
    curve.endPosition = ccp(screenSize.width * 201 / 480,screenSize.height * 123 /320);
    
    CCBezierTo *bezierMoveAction = [CCBezierTo actionWithDuration:0.6 bezier:curve];
    CGFloat percent = 0;
    if ([type intValue] == ObjectTypeBar ) 
    {
        percent = (priceGoldBar / totalRooBucks) * 100 /5;
    }
    else if ([type intValue] == ObjectTypeStone) {
        percent = (priceGoldStone / totalRooBucks) * 100/5;
    }
    else {
        percent = 100 - currentPercent;
    }
        currentPercent += percent;
        ccTime timeProgress = (currentPercent - progress.percentage) / 60;
        
        CCProgressTo *goProgress = [CCProgressTo actionWithDuration:timeProgress percent:currentPercent];
        [progress runAction:[CCSequence actions: goProgress, nil]];
        
        if (countTime == 0)
        {
            [self stopAllActions];
            [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:timeProgress + 0.2],[CCCallFunc actionWithTarget:self selector:@selector(finishCalculate)], nil]];
        }
    

    CCEaseOut *ease = [CCEaseOut actionWithAction:bezierMoveAction rate:0.6];
    CCCallBlock *removeCall = [CCCallBlock actionWithBlock:^{
        [object removeFromParentAndCleanup:YES];
    }];
    //CCFadeOut *fade = [CCFadeOut actionWithDuration:0.2];
    [object runAction:[CCSequence actions:ease,removeCall, nil]];
    
}

- (void) scoring
{
    CCCallFunc *callScoring = [CCCallFunc actionWithTarget:self selector:@selector(scoring)];
    if (countGoldBar > 0)
    {
        countGoldBar--;
        [self addObjectInHatWithType:[NSNumber numberWithInt:0]];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:0] afterDelay:0.1];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:0] afterDelay:0.2];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:0] afterDelay:0.3];
        
        
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],callScoring, nil]];
         //[self performSelector:@selector(scoring) withObject:self afterDelay:0.6];
    }
    else if (countGoldStone > 0)
    {
        countGoldStone--;
        [self addObjectInHatWithType:[NSNumber numberWithInt:1]];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:1] afterDelay:0.1];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:1] afterDelay:0.2];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:1] afterDelay:0.3];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:1] afterDelay:0.4];
        //[self performSelector:@selector(scoring) withObject:self afterDelay:0.6];
        [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:0.6],callScoring, nil]];
    }
    else if (countTime > 0){
        countTime = 0;
        [self addObjectInHatWithType:[NSNumber numberWithInt:2]];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:2] afterDelay:0.1];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:2] afterDelay:0.2];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:2] afterDelay:0.3];
        [self performSelector:@selector(addObjectInHatWithType:) withObject:[NSNumber numberWithInt:2] afterDelay:0.4];
    }
}

- (void) onRestart
{
    [[SimpleAudioEngine sharedEngine] stopEffect:scorecCharges];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchRestartLevel];
}

- (void) onMenu
{
    [[SimpleAudioEngine sharedEngine] stopEffect:scorecCharges];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}

- (void) onNextLevel
{
    [[SimpleAudioEngine sharedEngine] stopEffect:scorecCharges];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchNextLevel];
}

@end
