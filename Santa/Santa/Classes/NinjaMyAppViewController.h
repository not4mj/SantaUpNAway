//
//  NinjaMyAppViewController.h
//  NinjaMyApp Skeleton
//
//  Created by Fred Radford on 9/23/12.
//  Copyright (c) 2012 Fred Radford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NmaTileMenuDelegate.h"
#import "NmaIAP.h"
#import <RevMobAds/RevMobAdsDelegate.h>
#import "GADInterstitial.h"
#import "GADBannerView.h"
#import "MobclixFullScreenAdViewController.h"
#import "NmaBasic.h"
#import "NmaSocialSharing.h"
#import "cocos2d.h"

@class NmaTileMenu;
@interface NinjaMyAppViewController : UIViewController <NmaTileMenuDelegate, NmaRestoreDelegate, RevMobAdsDelegate, FBSessionDelegate, GADInterstitialDelegate, GADBannerViewDelegate>{
    GADInterstitial * admobInterstitial;
    GADBannerView * adMobBannerView;
    MobclixFullScreenAdViewController * mobclixFullVC;
    MobclixAdView * mobclixBannerView;
}
@property(nonatomic,retain) MobclixFullScreenAdViewController* mobclixFullVC;
- (void)nmaLaunchNagScreen;
- (void)nmaLaunchMoreGames;
- (void)nmaLaunchNews;

@end
