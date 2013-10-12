//
//  GoldBarsLayer.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
	CollectedBar = 1,
};

@interface GoldBarsLayer : CCLayer 
{
    CCLabelBMFont *countLabel;
}
- (id) initWithMaxHays:(NSInteger) hays;
- (void) collectedNumberBar:(NSInteger) numberBar;
@end
