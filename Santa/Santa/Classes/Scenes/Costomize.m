//
//  Costomize.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Costomize.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

#import "Satchel.h"
#import "Glasses.h"
#import "Hat.h"


@interface Costomize (Private)
- (void) addItems;
- (void) satchelSelect:(id)sender;
- (void) updateCoinsLabel;
- (void) closeWindow;
- (void) addPlayer;
- (void) addMiniPlayer;
- (void) addBuyWindowsWithTag:(BuyClothingType) buyClothingType;
- (void) addPlayerWindowsWithTag:(BuyClothingType) buyClothingType;
- (void) addWindowsContent;
- (void) onPurchaseWindowsWithClothingType:(BuyClothingType)buyClothingType;
- (void) addMarkerSelect:(CCMenuItemSprite*) item;
- (void) deleteMarkerSelect:(CCMenuItemSprite*) item;
- (NSInteger) priceWithClothingType:(BuyClothingType) buyClothingType;
- (void) buyItemWithProductID:(ProductType) productType;
@end

@implementation Costomize
+ (id) scene
{
    CCScene *scene = [CCScene node];
    Costomize *layer = [Costomize node];
    [scene addChild: layer];
    return scene;
}

- (id) init
{
	if ((self=[super init])) 
	{
        loadView = nil;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Customize.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"windows.plist"];
        
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"customizeBackground.png"];
        background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        [self addChild:background];

        currentItem = nil;
        [self addItems];
        windows = nil;
        currentRooBucks = [[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"];
        
        NSString *coinsLabelString = [NSString stringWithFormat:@"%d",currentRooBucks];
        coinsLabel = [CCLabelBMFont labelWithString:coinsLabelString fntFile:@"MuseoFont_28.fnt"];
        coinsLabel.position = ccp(screenSize.width - coinsLabel.contentSize.width /2 - 10, 31);
        [self addChild:coinsLabel z:3];
        
        CCSprite *coinSpriteNorm = [CCSprite spriteWithSpriteFrameName:@"coins_total.png"];
        CCSprite *coinSpriteSel = [CCSprite spriteWithSpriteFrameName:@"coins_total.png"];
        
        coinItem = [CCMenuItemSprite 
                                        itemWithNormalSprite:coinSpriteNorm 
                                        selectedSprite:coinSpriteSel 
                                        target:self
                                        selector:@selector(purchaseWindows)];
        
        coinItem.position = ccp(coinsLabel.position.x - coinsLabel.contentSize.width /2 - coinItem.contentSize.width /2 , 31);
                      
        CCSprite *MenuButton = [CCSprite spriteWithSpriteFrameName:@"menu_normal.png"];
        CCSprite *MenuSelButton = [CCSprite spriteWithSpriteFrameName:@"menu_pressed.png"];
        CCMenuItemSprite *menuItem = [CCMenuItemSprite 
                                      itemWithNormalSprite:MenuButton
                                      selectedSprite:MenuSelButton 
                                      target:self 
                                      selector:@selector(onMenu)];
        menuItem.position = ccp(50, 30);
        CCMenu * menuMenuButton= [CCMenu menuWithItems: menuItem,coinItem, nil];
        [menuMenuButton setPosition:ccp(0, 0)];
		[self addChild:menuMenuButton z:3];
        
        windows = [CCSprite spriteWithSpriteFrameName: @"window.png"];
                  
        windows.scale = 0;
        windows.opacity = 0;
        [windows runAction:[CCFadeIn actionWithDuration:0.2]];
        [self addChild:windows];
        CCEaseIn *ease = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:1] rate:0.2];
        [windows runAction:ease];
        windows.position = ccp(240, 160);

        [self addWindowsContent];
        
        isPlayEffectScore = NO;
        [self schedule:@selector(removeDebt)];
    }
    return self;   
}

- (void) purchaseWindows
{
    if (windows == nil)
    {
        windows = [CCSprite spriteWithSpriteFrameName: @"window.png"];
        windows.scale = 0;
        windows.opacity = 0;
        [windows runAction:[CCFadeIn actionWithDuration:0.2]];
        [self addChild:windows];
        CCEaseIn *ease = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:1] rate:0.2];
        [windows runAction:ease];
        windows.position = ccp(240, 160);
    }
    else
    {
        [windows removeAllChildrenWithCleanup:YES];
        CCEaseIn *ease = [CCEaseIn actionWithAction:[CCMoveTo actionWithDuration:0.2 position:ccp(240, 160)] rate:0.2];
        [windows runAction:ease];
    }
    
    CCSprite *cancelNorm = [CCSprite spriteWithSpriteFrameName:@"close_normal.png"];
    CCSprite *cancelSel = [CCSprite spriteWithSpriteFrameName:@"close_pressed.png"];
    CCMenuItemSprite *itemCancel = [CCMenuItemSprite itemWithNormalSprite:cancelNorm selectedSprite:cancelSel target:self selector:@selector(closeWindow)];
    itemCancel.position = ccp(windows.contentSize.width - 27  , windows.contentSize.height - 21);
    CCMenu * menu= [CCMenu menuWithItems:itemCancel, nil];
    [menu setPosition:ccp(0, 0)];
    [windows addChild:menu];
    
    [self onPurchaseWindowsWithClothingType:BuyClothingTypeNull];
}

- (void) onPurchaseWindowsWithClothingType:(BuyClothingType)buyClothingType
{
    if (buyClothingType != BuyClothingTypeNull)
    {
        NSString *priceString = [NSString stringWithFormat:@"PRICE: %d",[self priceWithClothingType:buyClothingType]];
        CCLabelBMFont *priceLabel = [CCLabelBMFont labelWithString:priceString fntFile:@"Futura_20.fnt"];
        priceLabel.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 40);
        [windows addChild:priceLabel];
    }
    CCLabelBMFont *youNeedLabel = [CCLabelBMFont labelWithString:@"DO YOU NEED MORE" fntFile:@"Futura_20.fnt"];
    youNeedLabel.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 65);
    [windows addChild:youNeedLabel];
    
    CCLabelBMFont *rooBucksLabel = [CCLabelBMFont labelWithString:@"ROO BUCKS ?" fntFile:@"Futura_20.fnt"];
    rooBucksLabel.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 90);
    [windows addChild:rooBucksLabel];
    
    
    CCLabelBMFont *buyOneLabel = [CCLabelBMFont labelWithString:@"BUY 100 ROO BUCKS" fntFile:@"Futura_20.fnt"];
    CCMenuItemLabel *buyOneItem = [CCMenuItemLabel itemWithLabel:buyOneLabel target:self selector:@selector(buyOneRooBucks)];
    buyOneItem.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 150);
    
    
    CCLabelBMFont *buyTwoLabel = [CCLabelBMFont labelWithString:@"BUY 200 ROO BUCKS" fntFile:@"Futura_20.fnt"];
    CCMenuItemLabel *buyTwoItem = [CCMenuItemLabel itemWithLabel:buyTwoLabel target:self selector:@selector(buyTwoRooBucks)];
    buyTwoItem.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 180);
    
    
    CCLabelBMFont *buyThreeLabel = [CCLabelBMFont labelWithString:@"BUY 300 ROO BUCKS" fntFile:@"Futura_20.fnt"];
    CCMenuItemLabel *buyThreeItem = [CCMenuItemLabel itemWithLabel:buyThreeLabel target:self selector:@selector(buyThreeRooBucks)];
    buyThreeItem.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 210);
    
    
    CCMenu * menu= [CCMenu menuWithItems: buyOneItem,buyTwoItem,buyThreeItem, nil];
    [menu setPosition:ccp(0, 0)];
    [windows addChild:menu];
}
            
- (void) addWindowsContent
{
    CCSprite *cancelNorm = [CCSprite spriteWithSpriteFrameName:@"close_normal.png"];
    CCSprite *cancelSel = [CCSprite spriteWithSpriteFrameName:@"close_pressed.png"];
    CCMenuItemSprite *itemCancel = [CCMenuItemSprite itemWithNormalSprite:cancelNorm selectedSprite:cancelSel target:self selector:@selector(closeWindow)];
    itemCancel.position = ccp(windows.contentSize.width - 27  , windows.contentSize.height - 21);
    CCMenu * menu= [CCMenu menuWithItems:itemCancel, nil];
    [menu setPosition:ccp(0, 0)];
    [windows addChild:menu];
    
    if (currentItem.color.r == ccGRAY.r && currentItem.color.g == ccGRAY.g && currentItem.color.b == ccGRAY.b)
    {
        //не купленно
        [self addBuyWindowsWithTag:currentItem.tag];
    }
    else
    {
        [self addPlayerWindowsWithTag:currentItem.tag];
    }
}

- (void) clothingSelect:(id)sender
{

    CCMenuItemSprite *item = (CCMenuItemSprite*)sender;
    currentItem = item;
    
    if (windows == nil)
    {
        windows = [CCSprite spriteWithSpriteFrameName: @"window.png"];
                   
        windows.scale = 0;
        windows.opacity = 0;
        [windows runAction:[CCFadeIn actionWithDuration:0.2]];
        [self addChild:windows];

        CCEaseIn *ease = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:0.2 scale:1] rate:0.2];
        [windows runAction:ease];
        
        if (item.position.x > 240)
        {
            windows.position = ccp(160, 160);
        }
        else
        {
            windows.position = ccp(320, 160);
        }

        [self addWindowsContent];
    }
    else
    {
        [windows removeAllChildrenWithCleanup:YES];
        if (item.position.x > 240)
        {
            CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:ccp(160, 160)];
            CCEaseBackOut *easeBackIn = [CCEaseBackOut actionWithAction:move];
            [windows runAction:easeBackIn];
        }
        else
        {
            CCMoveTo *move = [CCMoveTo actionWithDuration:0.5 position:ccp(320, 160)];
            CCEaseBackOut *easeBackIn = [CCEaseBackOut actionWithAction:move];
            [windows runAction:easeBackIn];
        }
        
        [self addWindowsContent];
    }
}

- (NSInteger) priceWithClothingType:(BuyClothingType) buyClothingType;
{
    NSInteger price;
    if (buyClothingType == BuySatchelTypeBlue || 
        buyClothingType == BuySatchelTypePink || 
        buyClothingType == BuySatchelTypeRed ) 
    {
        price = 750;
    }
    else if (buyClothingType == BuyHatTypeBaseball || 
             buyClothingType == BuyHatTypeCowboy || 
             buyClothingType == BuyHatTypeTop ) 
    {
        price = 500;
    }
    else if (buyClothingType == BuyGlassesTypeGreen || 
             buyClothingType == BuyGlassesTypePink || 
             buyClothingType == BuyGlassesTypeRed ) 
    {
        price = 250;
    }
    return price;
}

- (void) addBuyWindowsWithTag:(BuyClothingType) buyClothingType
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] >= [self priceWithClothingType:buyClothingType])
    {
        CCLabelBMFont *buyItemLabel = [CCLabelBMFont labelWithString:@"BUY ITEM " fntFile:@"Futura_20.fnt"];
        buyItemLabel.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 40);
        [windows addChild:buyItemLabel];
        
        NSString *rooBucksString = [NSString stringWithFormat:@"PRICE %d ROO BUCKS",[self priceWithClothingType:buyClothingType]];
        CCLabelBMFont *rooBucksLabel = [CCLabelBMFont labelWithString:rooBucksString fntFile:@"Futura_20.fnt"];
        rooBucksLabel.position = ccp(windows.contentSize.width/2 , windows.contentSize.height - 60);
        [windows addChild:rooBucksLabel];
        
        CCLabelBMFont *buy = [CCLabelBMFont labelWithString:@"BUY" fntFile:@"Futura_20.fnt"];
        
        CCMenuItemLabel *itemBuy = [CCMenuItemLabel itemWithLabel:buy target:self selector:@selector(onClothingBuy:)];
        itemBuy.tag = buyClothingType;
        itemBuy.position = ccp(windows.contentSize.width * 0.7 , windows.contentSize.height /2);
        
        CCMenu * menu= [CCMenu menuWithItems: itemBuy, nil];
        [menu setPosition:ccp(0, 0)];
        [windows addChild:menu];
    
        [self addMiniPlayer];
    }
    else
    {
        [self onPurchaseWindowsWithClothingType:(BuyClothingType)buyClothingType];

    }
}

- (void) buyOneRooBucks
{
    NSLog(@"buyOneRooBucks");
    [self buyItemWithProductID:ProductTypeOnePackRooBucks];
    //debt += 100;
    //[[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 100 forKey:@"RooBucks"];
}

- (void) buyTwoRooBucks
{
    NSLog(@"buyTwoRooBucks"); 
    [self buyItemWithProductID:ProductTypeTwoPackRooBucks];
    //debt += 200;
    //[[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 200 forKey:@"RooBucks"];
}

- (void) buyThreeRooBucks
{
    NSLog(@"buyThreeRooBucks");
    [self buyItemWithProductID:ProductTypeThreePackRooBucks];
    //debt += 300;
    //[[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 300 forKey:@"RooBucks"];
}

- (void) buyItemWithProductID:(ProductType) productType
{
    
    //need fix [loadView release];
    loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    loadView.backgroundColor = [UIColor blackColor];
    loadView.alpha = 0.0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    loadView.alpha = 0.7;
    [UIView commitAnimations];
    loadView.userInteractionEnabled = YES;
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(220, 40, 40, 40)];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicatorView startAnimating];
    [loadView addSubview:activityIndicatorView];
    [activityIndicatorView release];
    [loadView setExclusiveTouch:YES];
    //wer
    [[[CCDirector sharedDirector] view] addSubview:loadView];
    
    NSString *keyBuy = [[NSString alloc] init];
    
    if (productType == ProductTypeOnePackRooBucks) 
    {
        keyBuy = [NSString stringWithFormat:@"com.dmapplications.joeysquest.OnePackRooBucks"];
    }
    else if(productType == ProductTypeTwoPackRooBucks) 
    {
        keyBuy = [NSString stringWithFormat:@"com.dmapplications.joeysquest.TwoPackRooBucks"];
    } 
    else if(productType == ProductTypeThreePackRooBucks) 
    {
        keyBuy = [NSString stringWithFormat:@"com.dmapplications.joeysquest.ThreePackRooBucks"];
    } 
    
    NSLog(@"keyBuy=%@",keyBuy);
    
    [[MKStoreManager sharedManager] buyFeature:keyBuy onComplete:^(NSString *purchasedFeature, NSData *purchasedReceipt, NSArray *availableDownloads) 
     {
         NSLog(@"Purchased: %@", purchasedFeature);
         if (productType == ProductTypeOnePackRooBucks) 
         {
             debt += 100;
             [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 100 forKey:@"RooBucks"];
         }
         else if(productType == ProductTypeTwoPackRooBucks) 
         {
             debt += 200;
             [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 200 forKey:@"RooBucks"];
         } 
         else if(productType == ProductTypeThreePackRooBucks) 
         {
             debt += 300;
             [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] + 300 forKey:@"RooBucks"];
         }
         [loadView removeFromSuperview];
         loadView = nil;
     }
                                   onCancelled:^
     {
         [loadView removeFromSuperview];
         loadView = nil;
         NSLog(@"onCancelled");
     }];
    
    currentTime = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)onTimer:(NSTimer*)timer
{
    
    if (currentTime < 10)
    {
        currentTime++;
    }
    else
    {
        [timer invalidate];
        [self cancelPurchased];
    }
    
}

-(void) cancelPurchased
{
    if (loadView != nil)
    {
        [loadView removeFromSuperview];
    }
}

- (void) removeDebt
{
    if (debt != 0)
    {
        if (!isPlayEffectScore) 
        {
            isPlayEffectScore = YES;
           scoreEffect = [[SimpleAudioEngine sharedEngine] playEffect:@"Bonus_score_start.caf"];
        }
        if (debt > 0)
        {//добовляем
            debt--;
            currentRooBucks++;
            [self updateCoinsLabel]; 
        }
        else
        {
            debt++;
            currentRooBucks--;
            [self updateCoinsLabel]; 
        }
    }
    else {
        if (isPlayEffectScore) 
        {
            isPlayEffectScore =NO;
            [[SimpleAudioEngine sharedEngine] stopEffect:scoreEffect];
            [[SimpleAudioEngine sharedEngine] playEffect:@"Bonus_score_finish.caf"];
        }
        
    }
}

- (void) addPlayerWindowsWithTag:(BuyClothingType) buyClothingType
{
    
    if (buyClothingType == BuySatchelTypeBlue)
    {
        [self deleteMarkerSelect:wearingSatchel];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerSatchelType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PlayerSatchelType"];
            wearingSatchel = currentItem;
            [self addMarkerSelect:wearingSatchel];
        }
    }
    else if(buyClothingType == BuySatchelTypePink)
    {
        [self deleteMarkerSelect:wearingSatchel];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 2)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerSatchelType"];
        }
        else
        {
           [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"PlayerSatchelType"]; 
            wearingSatchel = currentItem;
            [self addMarkerSelect:wearingSatchel];
        }
    }
    else if(buyClothingType == BuySatchelTypeRed)
    {
        [self deleteMarkerSelect:wearingSatchel];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 3)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerSatchelType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"PlayerSatchelType"];
            wearingSatchel = currentItem;
            [self addMarkerSelect:wearingSatchel];
        }
    }
    else if(buyClothingType == BuyHatTypeBaseball)
    {
        [self deleteMarkerSelect:wearingHat];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerHatType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PlayerHatType"];
            wearingHat = currentItem;
            [self addMarkerSelect:wearingHat];
        }
    }
    else if(buyClothingType == BuyHatTypeCowboy)
    {
        [self deleteMarkerSelect:wearingHat];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 2)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerHatType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"PlayerHatType"];
            wearingHat = currentItem;
            [self addMarkerSelect:wearingHat];
        }
    }
    else if(buyClothingType == BuyHatTypeTop)
    {
        [self deleteMarkerSelect:wearingHat];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 3)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerHatType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"PlayerHatType"];
            wearingHat = currentItem;
            [self addMarkerSelect:wearingHat];
        }
    }
    else if(buyClothingType == BuyGlassesTypeGreen)
    {
        [self deleteMarkerSelect:wearingGlasses];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 1)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerGlassesType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"PlayerGlassesType"];
            wearingGlasses = currentItem;
            [self addMarkerSelect:wearingGlasses];
        }
    }
    else if(buyClothingType == BuyGlassesTypePink)
    {
        [self deleteMarkerSelect:wearingGlasses];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 2)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerGlassesType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"PlayerGlassesType"];
            wearingGlasses = currentItem;
            [self addMarkerSelect:wearingGlasses];
        }
    }
    else if(buyClothingType == BuyGlassesTypeRed)
    {
        [self deleteMarkerSelect:wearingGlasses];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 3)
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"PlayerGlassesType"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"PlayerGlassesType"];
            wearingGlasses = currentItem;
            [self addMarkerSelect:wearingGlasses];
        }
    }
    [self addPlayer];
}

- (void) addMiniPlayer
{
    CCSprite *player = [CCSprite spriteWithSpriteFrameName:@"Joey_items/Joey.png"];
    player.position = ccp(windows.contentSize.width * 0.3 , windows.contentSize.height/2);
    [windows addChild:player];
    CCSprite *clothing;

    if (currentItem.tag == BuySatchelTypeBlue)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/blue_satchel.png"];
    }
    else if(currentItem.tag == BuySatchelTypePink)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/pink_satchel.png"];
    }
    else if(currentItem.tag == BuySatchelTypeRed)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/red_stachel.png"];
    }
    
    else if(currentItem.tag == BuyHatTypeBaseball)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/cap.png"];
    }
    else if(currentItem.tag == BuyHatTypeCowboy)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/cowboy hat.png"];
    }
    else if(currentItem.tag == BuyHatTypeTop)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/top_hat.png"];
    }
    
    else if(currentItem.tag == BuyGlassesTypeGreen)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/green_glasses.png"];
    }
    else if(currentItem.tag == BuyGlassesTypePink)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/pink_glasses.png"];
    }
    else if(currentItem.tag == BuyGlassesTypeRed)
    {
        clothing = [CCSprite spriteWithSpriteFrameName:@"Joey_items/red_glasses.png"];
    }
    clothing.position = ccp(player.boundingBox.size.width / 2 , player.boundingBox.size.height / 2);
    [player addChild:clothing];
    player.scale = 0.7;
}

- (void) addPlayer
{
    CCSprite *player = [CCSprite spriteWithSpriteFrameName:@"Joey_items/Joey.png"];
    player.position = ccp(windows.contentSize.width/2 , windows.contentSize.height/2);
    [windows addChild:player];
    
    CGPoint centerPlayerPosition = ccp(player.boundingBox.size.width / 2 , player.boundingBox.size.height / 2);
//add Satchel
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 1) 
    {
        CCSprite *satchel = [CCSprite spriteWithSpriteFrameName:@"Joey_items/blue_satchel.png"];
        satchel.position = centerPlayerPosition;
        [player addChild:satchel];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 2) 
    {
        CCSprite *satchel = [CCSprite spriteWithSpriteFrameName:@"Joey_items/pink_satchel.png"];
        satchel.position = centerPlayerPosition;
        [player addChild:satchel];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 3) 
    {
        CCSprite *satchel = [CCSprite spriteWithSpriteFrameName:@"Joey_items/red_stachel.png"];
        satchel.position = centerPlayerPosition;
        [player addChild:satchel];
    }
//add Glasses
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 1) 
    {
        CCSprite *glasses = [CCSprite spriteWithSpriteFrameName:@"Joey_items/green_glasses.png"];
        glasses.position = centerPlayerPosition;
        [player addChild:glasses];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 2) 
    {
        CCSprite *glasses = [CCSprite spriteWithSpriteFrameName:@"Joey_items/pink_glasses.png"];
        glasses.position = centerPlayerPosition;
        [player addChild:glasses];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 3) 
    {
        CCSprite *glasses = [CCSprite spriteWithSpriteFrameName:@"Joey_items/red_glasses.png"];
        glasses.position = centerPlayerPosition;
        [player addChild:glasses];
    }
//add Hat
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 1) 
    {
        CCSprite *hat = [CCSprite spriteWithSpriteFrameName:@"Joey_items/cap.png"];
        hat.position = centerPlayerPosition;
        [player addChild:hat];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 2) 
    {
        CCSprite *hat = [CCSprite spriteWithSpriteFrameName:@"Joey_items/cowboy hat.png"];
        hat.position = centerPlayerPosition;
        [player addChild:hat];
    }
    else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 3) 
    {
        CCSprite *hat = [CCSprite spriteWithSpriteFrameName:@"Joey_items/top_hat.png"];
        hat.position = centerPlayerPosition;
        [player addChild:hat];
    }
}

-(void) onClothingBuy:(id)sender
{
    CCMenuItemSprite *item = (CCMenuItemSprite*)sender;
    [currentItem runAction:[CCTintTo actionWithDuration:1.0 red:255 green:255 blue:255]];
    
    debt -= [self priceWithClothingType:item.tag];
    [self closeWindow];
    [[NSUserDefaults standardUserDefaults] setInteger: [[NSUserDefaults standardUserDefaults] integerForKey:@"RooBucks"] - [self priceWithClothingType:item.tag] forKey:@"RooBucks"];
    

    
    if (item.tag == BuySatchelTypeBlue)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SatchelTypeBlue"];
    }
    else if(item.tag == BuySatchelTypePink)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SatchelTypePink"];
    }
    else if(item.tag == BuySatchelTypeRed)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SatchelTypeRed"];
    }
    
    else if(item.tag == BuyHatTypeBaseball)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HatTypeBaseball"];
    }
    else if(item.tag == BuyHatTypeCowboy)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HatTypeCowboy"];
    }
    else if(item.tag == BuyHatTypeTop)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HatTypeTop"];
    }
    
    else if(item.tag == BuyGlassesTypeGreen)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GlassesTypeGreen"];
    }
    else if(item.tag == BuyGlassesTypePink)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GlassesTypePink"];
    }
    else if(item.tag == BuyGlassesTypeRed)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"GlassesTypeRed"];
    }
    
    [self performSelector:@selector(clothingSelect:) withObject:currentItem afterDelay:0.5];
   // - (void) clothingSelect:(id)sender
    //[self clothingSelect:currentItem];
    //[self addPlayerWindowsWithTag:currentItem.tag];
}

- (void) updateCoinsLabel
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    NSString *coinsLabelString = [NSString stringWithFormat:@"%d",currentRooBucks];
    coinsLabel.string = coinsLabelString;
    coinsLabel.position = ccp(screenSize.width - coinsLabel.contentSize.width /2 - 10, 31);
    coinItem.position = ccp(coinsLabel.position.x - coinsLabel.contentSize.width /2 - coinItem.contentSize.width /2 , 31);
}

-(void) closeWindow
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate playEffectClick];
    [windows removeFromParentAndCleanup:YES];
    windows = nil;
}

- (void) glassesSelect:(id)sender
{
    
}

- (void) hatSelect:(id)sender
{
    
}

- (void) onMenu
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate launchMainMenu];
}

- (void) addMarkerSelect:(CCMenuItemSprite*) item
{
    CCSprite *selectedSprite = [CCSprite spriteWithSpriteFrameName:@"selection.png"];
    selectedSprite.position = ccp(item.contentSize.width/2, item.contentSize.height/2);
    selectedSprite.tag = 2;
    [item addChild:selectedSprite];
}

- (void) deleteMarkerSelect:(CCMenuItemSprite*) item
{
    [item removeChildByTag:2 cleanup:YES];
}

- (void) addItems
{
    //Satches
    CCSprite *pinkSatchelNorm = [CCSprite spriteWithSpriteFrameName:@"pink_satchel.png"];
    CCSprite *pinkSatchelSel = [CCSprite spriteWithSpriteFrameName:@"pink_satchel.png"];
    pinkSatchelSel.scale = 1.1;
    CCMenuItemSprite *pinkSatchelItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:pinkSatchelNorm 
                                         selectedSprite:pinkSatchelSel 
                                         target:self 
                                         selector:@selector(clothingSelect:)];
    pinkSatchelItem.tag = BuySatchelTypePink;
    pinkSatchelItem.position = ccp(66, 236); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SatchelTypePink"])
        pinkSatchelItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 2) 
    {
        wearingSatchel = pinkSatchelItem;
        [self addMarkerSelect:wearingSatchel];
    }
        
    
    CCSprite *redSatchelNorm = [CCSprite spriteWithSpriteFrameName:@"red_satchel.png"];
    CCSprite *redSatchelSel = [CCSprite spriteWithSpriteFrameName:@"red_satchel.png"];
    redSatchelSel.scale = 1.1;
    CCMenuItemSprite *redSatchelItem = [CCMenuItemSprite 
                                        itemWithNormalSprite:redSatchelNorm 
                                        selectedSprite:redSatchelSel 
                                        target:self 
                                        selector:@selector(clothingSelect:)];
    redSatchelItem.tag = BuySatchelTypeRed;
    redSatchelItem.position = ccp(165, 249); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SatchelTypeRed"])
        redSatchelItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 3) 
    {
        wearingSatchel = redSatchelItem;
        [self addMarkerSelect:wearingSatchel];
    }
        
    
    CCSprite *blueSatchelNorm = [CCSprite spriteWithSpriteFrameName:@"blue_satchel.png"];
    CCSprite *blueSatchelSel = [CCSprite spriteWithSpriteFrameName:@"blue_satchel.png"];
    blueSatchelSel.scale = 1.1;
    CCMenuItemSprite *blueSatchelItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:blueSatchelNorm 
                                         selectedSprite:blueSatchelSel 
                                         target:self 
                                         selector:@selector(clothingSelect:)];
    blueSatchelItem.tag = BuySatchelTypeBlue;
    blueSatchelItem.position = ccp(257, 254); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"SatchelTypeBlue"])
        blueSatchelItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerSatchelType"] == 1) 
    {
        wearingSatchel = blueSatchelItem;
        [self addMarkerSelect:wearingSatchel];
    }
        

    //Glasses
    CCSprite *redGlassesNorm = [CCSprite spriteWithSpriteFrameName:@"red_glasses.png"];
    CCSprite *redGlassesSel = [CCSprite spriteWithSpriteFrameName:@"red_glasses.png"];
    redGlassesSel.scale = 1.1;
    CCMenuItemSprite *redGlassesItem = [CCMenuItemSprite 
                                        itemWithNormalSprite:redGlassesNorm 
                                        selectedSprite:redGlassesSel 
                                        target:self 
                                        selector:@selector(clothingSelect:)];
    redGlassesItem.tag = BuyGlassesTypeRed;
    redGlassesItem.position = ccp(86, 141); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GlassesTypeRed"])
        redGlassesItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 3) 
    {
        wearingGlasses = redGlassesItem;
        [self addMarkerSelect:wearingGlasses];
    }
        
    
    CCSprite *pinkGlassesNorm = [CCSprite spriteWithSpriteFrameName:@"pink_glasses.png"];
    CCSprite *pinkGlassesSel = [CCSprite spriteWithSpriteFrameName:@"pink_glasses.png"];
    pinkGlassesSel.scale = 1.1;
    CCMenuItemSprite *pinkGlassesItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:pinkGlassesNorm 
                                         selectedSprite:pinkGlassesSel 
                                         target:self 
                                         selector:@selector(clothingSelect:)];
    pinkGlassesItem.tag = BuyGlassesTypePink;
    pinkGlassesItem.position = ccp(174, 190); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GlassesTypePink"])
        pinkGlassesItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 2) 
    {
        wearingGlasses = pinkGlassesItem;
        [self addMarkerSelect:wearingGlasses];
    }
        
    
    CCSprite *greenGlassesNorm = [CCSprite spriteWithSpriteFrameName:@"green_glasses.png"];
    CCSprite *greenGlassesSel = [CCSprite spriteWithSpriteFrameName:@"green_glasses.png"];
    greenGlassesSel.scale = 1.1;
    CCMenuItemSprite *greenGlassesItem = [CCMenuItemSprite 
                                          itemWithNormalSprite:greenGlassesNorm 
                                          selectedSprite:greenGlassesSel 
                                          target:self 
                                          selector:@selector(clothingSelect:)];
    greenGlassesItem.tag = BuyGlassesTypeGreen;
    greenGlassesItem.position = ccp(51, 190); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"GlassesTypeGreen"])
        greenGlassesItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerGlassesType"] == 1) 
    {
        wearingGlasses = greenGlassesItem;
        [self addMarkerSelect:wearingGlasses];
    }
        
    
    //Hat
    CCSprite *baseballHatNorm = [CCSprite spriteWithSpriteFrameName:@"cap.png"];
    CCSprite *baseballHatSel = [CCSprite spriteWithSpriteFrameName:@"cap.png"];
    baseballHatSel.scale = 1.1;
    CCMenuItemSprite *baseballHatItem = [CCMenuItemSprite 
                                         itemWithNormalSprite:baseballHatNorm 
                                         selectedSprite:baseballHatSel 
                                         target:self 
                                         selector:@selector(clothingSelect:)];
    baseballHatItem.tag = BuyHatTypeBaseball;
    baseballHatItem.position = ccp(311, 204); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HatTypeBaseball"])
        baseballHatItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 1) 
    {
        wearingHat = baseballHatItem;
        [self addMarkerSelect:wearingHat];
    }
    
    CCSprite *cowboyHatNorm = [CCSprite spriteWithSpriteFrameName:@"cowboy_hat.png"];
    CCSprite *cowboyHatSel = [CCSprite spriteWithSpriteFrameName:@"cowboy_hat.png"];
    cowboyHatSel.scale = 1.1;
    CCMenuItemSprite *cowboyHatItem = [CCMenuItemSprite 
                                       itemWithNormalSprite:cowboyHatNorm 
                                       selectedSprite:cowboyHatSel 
                                       target:self 
                                       selector:@selector(clothingSelect:)];
    cowboyHatItem.tag = BuyHatTypeCowboy;
    cowboyHatItem.position = ccp(370, 232); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HatTypeCowboy"])
        cowboyHatItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 2) 
    {
        wearingHat = cowboyHatItem;
        [self addMarkerSelect:wearingHat];
    }
    
    CCSprite *topHatNorm = [CCSprite spriteWithSpriteFrameName:@"top_hat.png"];
    CCSprite *topHatSel = [CCSprite spriteWithSpriteFrameName:@"top_hat.png"];
    topHatSel.scale = 1.1;
    CCMenuItemSprite *topHatItem = [CCMenuItemSprite 
                                    itemWithNormalSprite:topHatNorm 
                                    selectedSprite:topHatSel 
                                    target:self 
                                    selector:@selector(clothingSelect:)];
    topHatItem.tag = BuyHatTypeTop;
    topHatItem.position = ccp(430, 210); 
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HatTypeTop"])
        topHatItem.color = ccGRAY;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerHatType"] == 3) 
    {
        wearingHat = topHatItem;
        [self addMarkerSelect:wearingHat];
    }
        
    
    CCMenu * menuMenuButton = [CCMenu menuWithItems: pinkSatchelItem,redSatchelItem,blueSatchelItem,
                               pinkGlassesItem,greenGlassesItem,redGlassesItem,
                               cowboyHatItem,baseballHatItem, topHatItem,   nil];
    [menuMenuButton setPosition:ccp(0, 0)];
    [self addChild:menuMenuButton];
}

@end
