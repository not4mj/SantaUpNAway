//
//  GamePauseLayer.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GamePauseLayer : CCLayer 
{
    CCSprite *background;
    CCLayerColor *layerBlack;
}
- (void) removeLayer;

@end
