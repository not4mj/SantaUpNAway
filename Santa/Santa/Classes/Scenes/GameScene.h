//
//  GameScene.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SneakJoystickDelegate.h"
#import "cocos2d.h"
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "ThrowDelegate.h"
#import "CCLabelBMFont+AnimatedUpdate.h"

@class Player,
SneakyJoystick,
SneakyJoystickSkinnedBase,
Reindeer,
GamePauseLayer,
GoldBarsLayer,
ElfLaugh;

@interface GameScene : CCLayer <SneakJoystickDelegate, ThrowDelegate>
{
    ALuint river;
    CDSoundSource *soundSource;
    NSInteger currentLevel;
    Player *player;
    Reindeer *reindeer;
    SneakyJoystick *leftJoystick;
    SneakyJoystickSkinnedBase *leftJoy;
    NSMutableArray *enemies;
    NSMutableArray *crocodiles;
    NSMutableArray *projectiles;
    
    CGPoint playableAreaMin, playableAreaMax;
    
	CGPoint screenCenter;
	CGPoint moveOffsets[MAX_MoveDirections];
	EMoveDirection currentMoveDirection;
    
    int countCollectedGoldBar;
    int countCollectedGoldStone;
    NSInteger maxHeysInLevel;
    GoldBarsLayer *goldBarsLayer;
    
    CCMenuItemSprite *jumpButtonItem;

    CCMenu * menuResumButton;
    GamePauseLayer *pauseLayer;
    NSInteger remainingTime;
    CCLabelBMFont *timeLabel;
    
    CCMenu *menuSkip;
    ElfLaugh *elfLaugh;
    BOOL isPlay;
    
    BOOL isMoveScreen;
    CGPoint startMovePosition;
    CGPoint startMapPosition;
    CGPoint startWorldPosition;
    CGPoint mapBackPosition;
    CGPoint worldBackPosition;
    
    CCMenuItemToggle *pauseToggle;
    
    BOOL hayIsCollected;
}

+ (id) sceneWithLevelNumber:(NSNumber*)levelNumber;
- (void) updateJoystikDirection:(EMoveDirection) direction;
- (void) stopUpdate;
@end
