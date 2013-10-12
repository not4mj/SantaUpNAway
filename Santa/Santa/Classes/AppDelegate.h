//
//  AppDelegate.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Chartboost.h"
#import <RevMobAds/RevMobAdsDelegate.h>

typedef enum
{
    ProductTypeOnePackRooBucks = 1,
    ProductTypeTwoPackRooBucks,
    ProductTypeThreePackRooBucks,
} ProductType;

@class NinjaMyAppViewController, InfoViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, CCDirectorDelegate, RevMobAdsDelegate, ChartboostDelegate> {
	UIWindow *window;
	UINavigationController *navController;
	CCDirectorIOS	*director;
    NinjaMyAppViewController * viewController;
    NSNumber *currentLevel;
    NSNumber *currentLevelPack;//need delete
    InfoViewController *infoVC;
}
@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;
@property (nonatomic, retain) NinjaMyAppViewController *viewController;

@property (nonatomic, retain) NSNumber *currentLevelPack;
@property (nonatomic, retain) NSNumber *currentLevel;

- (void)directorViewWillAppear;
- (void)loadingData;
- (void)showLoading;
- (void)launchMainMenu;
- (void)launchOptions;
- (void)launchChoiceLevelPack;
- (void)launchMorePresents:(NSInteger) time;
- (void)launchChoiceLevel:(NSNumber*) levelNumber;
- (void)launchGameOver;
-(void)launchSelectGame;

- (void)launchInfo;
- (void)launchMoreGames;
- (void)launchNextLevel;
- (void)launchRestartLevel;
- (void)openNextLevel;
- (void)playEffectClick;

#pragma Mark FMNow SDK Methods
- (void)nmaLaunchMoreGames;
- (void)nmaLaunchNews;

//- (void)fmnowlaunchNagScreen;
//- (void)fmnowLaunchMoreGames;
//- (void)fmnowLaunchNews;

@end
