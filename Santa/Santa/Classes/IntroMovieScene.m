//
//  IntroMovieScene.m
//  Kangaroo
//
//  Created by Alexander Shestakov on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntroMovieScene.h"
#import "AppDelegate.h"

@implementation IntroMovieScene

+ (id) scene
{
    CCScene *scene = [CCScene node];
    IntroMovieScene *layer = [IntroMovieScene node];
    [scene addChild: layer];
    return scene;
}

- (id) init 
{
    if (self = [super init]) 
    {
        CGSize screenSize = [CCDirector sharedDirector].winSize;
            
        CCLayerColor *colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:colorLayer];
                
        CCSprite *introAnimationSprite = [CCSprite spriteWithFile:@"DM_00001.png"];
        [introAnimationSprite setPosition:ccp(screenSize.width / 2.f , screenSize.height / 2.f)];
        [self addChild:introAnimationSprite];

        CCAnimation *introAnimationAnimation = [CCAnimation animation];
        for (int i = 2; i <= 9; i++)
            [introAnimationAnimation addSpriteFrameWithFilename:[NSString stringWithFormat:@"DM_0000%d.png", i]];

        [introAnimationAnimation setDelayPerUnit:0.1];
        CCAnimate *introAnimationAction = [CCAnimate actionWithAnimation:introAnimationAnimation];

        CCRepeat *repeatAction = [CCRepeat actionWithAction:introAnimationAction times:3];
        
        CCCallBlock *showLoading = [CCCallBlock actionWithBlock:^(void) {
            AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
            [delegate showLoading]; 
        }];
        
        CCSequence *sequence = [CCSequence actions:repeatAction, showLoading, nil];
        
        [introAnimationSprite runAction:sequence];
        
        CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
        [sharedFileUtils setiPadSuffix:@"-ipad"];
    }
    return self;
}

@end
