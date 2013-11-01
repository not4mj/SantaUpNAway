//
//  SelectLevel.m
//  Kangaroo
//
//  Created by Roman Semenov on 11/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectLevel.h"
#import "AppDelegate.h"

@implementation SelectLevel
+ (id) scene
{
    CCScene *scene = [CCScene node];
    SelectLevel *layer = [SelectLevel node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init]))
	{
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selectLevel.plist"];
      
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile:@"selectLevelBackgound.jpg"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];
        [self addSnow];
        
        CCSprite *BackButton = [CCSprite spriteWithSpriteFrameName:@"back normal.png"];
        CCSprite *BackSelButton = [CCSprite spriteWithSpriteFrameName:@"back pressed.png"];
        CCMenuItemSprite *BackItem = [CCMenuItemSprite itemWithNormalSprite:BackButton selectedSprite:BackSelButton target:self selector:@selector(onBack)];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            BackItem.position = [self posIphoneToPersent:ccp(214, 71)];
        }
        else
        {
            BackItem.position = [self posToPersent:ccp(412, 155)];
        }
        

        NSMutableArray *items = [NSMutableArray arrayWithObject:BackItem];
        
        for (int i = 1; i < 9; i++)
        {
            [items addObject:[self itemWithLevel:i]];
        }
        
        
        CCMenu * menuBackButton= [CCMenu menuWithArray:items];
        [menuBackButton setPosition:CGPointZero];
		[self addChild:menuBackButton];
        
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

- (CCMenuItemSprite*) itemWithLevel:(NSInteger) level
{
    NSString *name = [NSString stringWithFormat:@"city level%d.png",level];
    CCSprite *itemSprite = [CCSprite spriteWithSpriteFrameName:name];
    CCSprite *itemNormalSprite = [CCSprite spriteWithFile:@"onePixel.png" rect:CGRectMake(0, 0, itemSprite.boundingBox.size.width, itemSprite.boundingBox.size.height)];
    itemNormalSprite.opacity = 0;
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:itemNormalSprite
                            selectedSprite:itemSprite
                                    target:self
                                    selector:@selector(selectLevel:)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        item.position = [self posIPhoneWithLevel:level];
    }
    else
    {
        item.position = [self posIPadWithLevel:level];
    }
    
    item.tag = level;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"OpenLevelInPack_1"] < level)
    {
        item.isEnabled = NO;
        
        CCSprite *key = [CCSprite spriteWithSpriteFrameName:@"city level8_key.png"];
        key.scale = itemSprite.boundingBox.size.height / key.boundingBox.size.height;
        key.position = ccp(itemSprite.boundingBox.size.width * 0.1, itemSprite.boundingBox.size.height / 2);
        [item addChild:key];
        
        
    }
    return item;
}

- (CGPoint) posIPhoneWithLevel:(NSInteger) level
{
    CGPoint pos;
    if (level == 1)
    {
        pos = [self posIphoneToPersent:ccp(226, 594)];
    }
    else if (level == 2)
    {
        pos = [self posIphoneToPersent:ccp(431, 492)];
    }
    else if (level == 3)
    {
        pos = [self posIphoneToPersent:ccp(557, 573)];
    }
    else if (level == 4)
    {
        pos = [self posIphoneToPersent:ccp(715, 523)];
    }
    else if (level == 5)
    {
        pos = [self posIphoneToPersent:ccp(852, 573)];
    }
    else if (level == 6)
    {
        pos = [self posIphoneToPersent:ccp(103, 468)];
    }
    else if (level == 7)
    {
        pos = [self posIphoneToPersent:ccp(225, 416)];
    }
    else if (level == 8)
    {
        pos = [self posIphoneToPersent:ccp(337, 407)];
    }
    return pos;
}

- (CGPoint) posIPadWithLevel:(NSInteger) level
{
    CGPoint pos;
    if (level == 1)
    {
        pos = [self posToPersent:ccp(412, 1430)];
    }
    else if (level == 2)
    {
        pos = [self posToPersent:ccp(908, 1177)];
    }
    else if (level == 3)
    {
        pos = [self posToPersent:ccp(1213, 1377)];
    }
    else if (level == 4)
    {
        pos = [self posToPersent:ccp(1584, 1251)];
    }
    else if (level == 5)
    {
        pos = [self posToPersent:ccp(1928, 1377)];
    }
    else if (level == 6)
    {
        pos = [self posToPersent:ccp(116, 1131)];
    }
    else if (level == 7)
    {
        pos = [self posToPersent:ccp(409, 997)];
    }
    else if (level == 8)
    {
        pos = [self posToPersent:ccp(685, 979)];
    }
    return pos;
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

- (void) selectLevel:(CCMenuItemSprite*) sender
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchChoiceLevel:[NSNumber numberWithInteger:sender.tag]];
}

- (void) onBack
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchSelectGame];
}
@end
