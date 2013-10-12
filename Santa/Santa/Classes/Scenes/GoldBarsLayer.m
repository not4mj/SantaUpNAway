//
//  GoldBarsLayer.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GoldBarsLayer.h"

@implementation GoldBarsLayer

- (id) initWithMaxHays:(NSInteger) hays
{
    if (self = [super init])
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *heyCounter = [CCSprite spriteWithFile:@"hey_counter.png"];
        heyCounter.position = ccp(screenSize.width * 0.1, screenSize.height * 1.2);
        [self addChild:heyCounter z:1];
        
        
        countLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"×%d",hays] fntFile:@"MuseoFont_28.fnt"];
        countLabel.position = ccp(heyCounter.boundingBox.size.width * 0.6, heyCounter.boundingBox.size.height / 2);
        [heyCounter addChild:countLabel];
        
        CGPoint moveToPoint = ccp(screenSize.width * 0.1, screenSize.height * 0.9);
        CCEaseBackOut *easeMove = [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:0.4 position:moveToPoint]];
        [heyCounter runAction:easeMove];
    }
    return  self;
}

- (void) collectedNumberBar:(NSInteger) numberBar
{
    countLabel.string = [NSString stringWithFormat:@"×%d",numberBar];
    
    CCScaleBy *scale = [CCScaleBy actionWithDuration:0.7 scale:1.5];
    CCEaseSineIn *ease = [CCEaseSineIn actionWithAction:scale];
    CCSequence *sequence = [CCSequence actions:ease, [ease reverse], nil];
    [countLabel runAction:sequence];
    
//    CCNode* goldBarNode = [self getChildByTag:numberBar];
//    NSAssert([goldBarNode isKindOfClass:[CCSprite class]], @"not a CCTMXTiledMap");
//    CCSprite* goldBar = (CCSprite*)goldBarNode;
//    
//    [goldBar runAction: [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255]];
//    CCSequence *sequence = [CCSequence actions:[CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:0.1 scale:0.2]],
//                            [CCEaseBackOut actionWithAction:[CCScaleTo actionWithDuration:1.8 scale:1.0]], nil];
//    [goldBar runAction:sequence];
//    
//    CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"GoldPaeticle.plist"];
//    particle.position = goldBar.position;
//    particle.life -= 2.5;
//    [self addChild:particle z:-1];
}
@end
