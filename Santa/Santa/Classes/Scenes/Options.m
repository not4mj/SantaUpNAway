//
//  Options.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Options.h"
#import "AppDelegate.h"
#import "CCSlider.h"
#import "SimpleAudioEngine.h"

@implementation Options

+ (id) scene
{
    CCScene *scene = [CCScene node];
    Options *layer = [Options node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init])) 
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        
        CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
        [sharedFileUtils setiPadSuffix:@"-ipad"];
        CCSprite *background = [CCSprite spriteWithFile:@"optionsBackground.jpg"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
        

        [self addSnow];
        
        [sharedFileUtils setiPadSuffix:@"-hd"];

        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameOverSprites.plist"];
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"menu_normal.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"menu_pressed.png"];
        CCMenuItemSprite *MenuItem = [CCMenuItemSprite 
                                      itemWithNormalSprite:MenuButton
                                      selectedSprite:MenuSelButton
                                      target:self 
                                      selector:@selector(onMenu)];
        MenuItem.position = ccp(MenuButton.boundingBox.size.width * 0.6,MenuButton.boundingBox.size.height * 0.7);
        
        CCMenu * menuMenuButton= [CCMenu menuWithItems: MenuItem, nil];
        [menuMenuButton setPosition:CGPointZero];
		[self addChild:menuMenuButton];
        
        
        CGFloat sliderWidth;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            sliderWidth = 269;
        }
        else
        {
            sliderWidth = 580;
        }
        CCSprite *sliderMusicBKG = [CCSprite spriteWithFile:@"onePixel.png" rect:CGRectMake(0, 0, screenSize.width/2, 1)];
        sliderMusicBKG.opacity = 0;

        CCSlider *musicSlider = [CCSlider 
                                 sliderWithTrackImage:sliderMusicBKG
                                 knobImage:[CCSprite spriteWithSpriteFrameName:@"slider.png"]
                                 target:self 
                                 selector:@selector(volumeMusic:)];
		
		musicSlider.height = screenSize.height * 100 / 320;
    
		musicSlider.horizontalPadding = 50;
		musicSlider.trackTouchOutsideContent = YES;
		musicSlider.evaluateFirstTouch = NO;
		musicSlider.minValue = 0;
		musicSlider.maxValue = 1;
		musicSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeMusic"];

        
        CCSprite *sliderSoundBKG = [CCSprite spriteWithFile:@"onePixel.png" rect:CGRectMake(0, 0, screenSize.width/2, 1)];
        sliderSoundBKG.opacity = 0;
        CCSlider *soundEffectsSlider = [CCSlider 
                                        sliderWithTrackImage:sliderSoundBKG
                                        knobImage:[CCSprite spriteWithSpriteFrameName:@"slider.png"]
                                        target:self 
                                        selector:@selector(volumeSoundEffects:)];
		
		soundEffectsSlider.height = screenSize.height * 100 / 320;;
        
		soundEffectsSlider.horizontalPadding = 50;
		soundEffectsSlider.trackTouchOutsideContent = YES;
		soundEffectsSlider.evaluateFirstTouch = NO;
		soundEffectsSlider.minValue = 0;
		soundEffectsSlider.maxValue = 1;
		soundEffectsSlider.value = [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSoundEffects"];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            musicSlider.position = [self posIphoneToPersent:ccp(482, 367)];
            soundEffectsSlider.position = [self posIphoneToPersent:ccp(482, 270)];
            
        }
        else
        {
            musicSlider.position = [self posToPersent:ccp(1025, 936)];
            soundEffectsSlider.position = [self posToPersent:ccp(1025, 725)];
            
        }
        
        
        [self addChild:musicSlider];
		[self addChild:soundEffectsSlider];
        
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

- (void) volumeMusic:(CCSlider *) slider{
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"volumeMusic"];
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:
    [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeMusic"]];
}

- (void) volumeSoundEffects:(CCSlider *) slider{
    [[NSUserDefaults standardUserDefaults] setFloat:slider.value forKey:@"volumeSoundEffects"];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:[[NSUserDefaults standardUserDefaults] floatForKey:@"volumeSoundEffects"]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_PickingHay.caf"];
}

- (void) dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"Options.plist"];
    [super dealloc];
}

- (void) onMenu
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}

@end
