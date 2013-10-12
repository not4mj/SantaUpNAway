//
//  Costomize.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

typedef enum
{
    BuyClothingTypeNull,
    
    BuySatchelTypeBlue,
    BuySatchelTypePink,
    BuySatchelTypeRed,
 
    BuyHatTypeBaseball,
    BuyHatTypeCowboy,
    BuyHatTypeTop,
    
    BuyGlassesTypeGreen,
    BuyGlassesTypePink,
    BuyGlassesTypeRed,
    
} BuyClothingType;


@interface Costomize : CCLayer {
    NSInteger currentRooBucks;
    CCLabelBMFont *coinsLabel;
    CCMenuItemSprite *coinItem;
    CCSprite *windows;
    CCMenuItemSprite *currentItem;
    NSInteger debt;
    
    CCMenuItemSprite *wearingHat;
    CCMenuItemSprite *wearingSatchel;
    CCMenuItemSprite *wearingGlasses;
    
    BOOL isPlayEffectScore;
    ALuint scoreEffect;
    NSInteger currentTime;
    UIView *loadView;
}
+ (id) scene;
@end
