//
//  GameWinLayer.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameWinLayer : CCLayer 
{
    CGFloat countGoldBar;
    CGFloat countGoldStone;
    CGFloat countTime;
    
    ALuint scorecCharges;
    
    CGFloat totalRooBucks;
    CCLayerColor *blackLayer;
    
    CCProgressTimer *progress;
    CGFloat currentPercent;
    
    CCLabelBMFont *typeScoreLabel;
    CCLabelBMFont *countScoreLabel;
    
    CCLabelBMFont *totalCoins;
}
- (id) initWithGoldBar:(NSInteger)goldBar goldStone:(NSInteger)goldStone time:(NSInteger)time;
@end
