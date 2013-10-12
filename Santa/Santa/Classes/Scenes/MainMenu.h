//
//  MainMenu.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/20/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface MainMenu : CCLayer 
{
    CCMenuItemSprite *infoItem;
}
+ (id) scene;
@end
