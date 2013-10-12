//
//  AppDelegate.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameConfig.h"
#import "MainMenu.h"
#import "GameOver.h"
#import "Loading.h"
#import "SelectLevel.h"
#import "GameScene.h"
#import "RootViewController.h"
#import "Options.h"
#import "MKStoreManager.h"
#import "Info.h"
#import "SelectGame.h"

#import "SimpleAudioEngine.h"
#import "ChartBoost.h"
#import "DeviceInfo.h"
#import "InfoView.h"
#import "IntroMovieScene.h"
#import "MorePresents.h"
// 4mnow SDk Headers
//#import "SVProgressHUD.h"
#import "NinjaMyAppViewController.h"

#import <NmaMain/NmaMain.h>
#import "NmaPrivacyPolicy.h"
#import "NmaTileMenu.h"
#import "NmaFacebook.h"
#import "NmaSocialSharing.h"
#import "Mobclix.h"

#import "Chartboost.h"
#import "Apsalar.h"
#import "TapjoyConnect.h"
#import "Flurry.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import "NinjaMyAppViewController.h"
#import "GoogleConversionPing.h"

#import <NmaMain/NmaMain.h>
#import "NmaBasic.h"
#import "NmaCarousel.h"
#import "NmaLaunchPad.h"
#import "InfoViewController.h"


NSString* REVMOB_ID;
BOOL fmnowDebugIsOn;
NSDictionary *chartboostSettings;
NSObject *cb;
NSString *chartboostAppID;
NSString *chartboostAppSignature;
BOOL chartboostIsDisabled;
BOOL chartboostNagDisabled;
BOOL chartboostMoreDisabled;
BOOL nmaStartSessionCompleted;
#define NmaAccountKey @"dmapps"


@implementation AppDelegate

@synthesize window, navController, director;
@synthesize currentLevelPack;
@synthesize currentLevel;
@synthesize viewController;

- (void)playEffectClick;
{
    CGFloat randPith = (arc4random() % (3));
    randPith = 1.1 - (randPith/ 10);

    NSString *effectPath = [NSString stringWithFormat:@"Zvuk_Klika_1.caf"];

    
    [[SimpleAudioEngine sharedEngine] playEffect:effectPath pitch:randPith pan:1 gain:1];
}

- (void) showLoading
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[Loading scene]]];
}

- (void)launchMainMenu
{
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];
    [self playEffectClick];
    //NSString *nameFile = [NSString stringWithFormat:@"MainMenu.ccbi"];
    
    //CCScene *scene = [CCBReader sceneWithNodeGraphFromFile:nameFile];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[MainMenu scene]]];
}
- (void)launchMorePresents:(NSInteger) time;
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[MorePresents sceneWithTime:time]]];
}

- (void)launchGameOver
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[GameOver scene]]];
}

- (void)launchOptions
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[Options scene]]];
}

-(void)launchSelectGame
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[SelectGame scene]]];
}

- (void)launchChoiceLevelPack
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[SelectLevel scene]]];
}

- (void)launchChoiceLevel:(NSNumber*) levelNumber
{
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-hd"];
    [self playEffectClick];
    currentLevel = levelNumber;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[GameScene sceneWithLevelNumber:levelNumber]]];
}

- (void)directorViewWillAppear
{
   
    
}

- (void)launchInfo
{
    [self playEffectClick];
    
    // Leave the following line uncommented if you want the info screen dynamically downloaded from Web.
    //[[NmaNews sharedNmaNews] nmaShowNewsScreenOnViewController:director];
 
//    [[CCDirector sharedDirector] stopAnimation];
//[navController setNavigationBarHidden:NO];
//    infoVC = [[InfoViewController alloc] init];
//    
//    [navController pushViewController:infoVC animated:YES];
//    [infoVC release];
    [self launchMorePresents:0.1];    
    // Leave the following line uncommented if you'd like to show the local version of the info screen.
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.4 scene:[Info scene]]];
}

- (void)launchMoreGames
{
    [self playEffectClick];

}


- (void)openNextLevel
{   
    if ([currentLevel intValue] < 10) 
    {
        NSString *keyString = [NSString stringWithFormat:@"OpenLevelInPack_1"];
        if ([[NSUserDefaults standardUserDefaults] integerForKey:keyString] < [currentLevel intValue] + 1) 
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[currentLevel intValue] + 1 forKey:keyString];
        }  
    }
}

- (void)launchNextLevel
{
    [self playEffectClick];

    currentLevel = [NSNumber numberWithInt:[currentLevel integerValue] + 1];
    if ([currentLevel integerValue] < 11) 
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[GameScene sceneWithLevelNumber:currentLevel]]];
    }
    else
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Main_menu.mp3" loop:YES];
        [self launchChoiceLevelPack];
    }
}

- (void)launchRestartLevel
{
    [self playEffectClick];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.4 scene:[GameScene sceneWithLevelNumber:currentLevel]]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");
   
    [self applicationDidFinishLaunching];
    //[SVProgressHUD show];
[GoogleConversionPing pingWithConversionId:@"1036220099" label:@"34YLCOevnhUQw-2N7gM" value:@"0" isRepeatable:NO idfaOnly:NO];
    NmaLogDebug(@"applicationDidFinishLaunching");
    [Nma startSession:NmaAccountKey handler:^(NSDictionary *currentSettings, NSError *error) {
        if (error) {
            NmaLogDebug(@"[nma] Error in startSessionWithDomain; code: %d Domain%@", [error code], [error domain]);
            NSLog(@"[nma] Error in startSessionWithDomain; code: %d Domain%@", [error code], [error domain]);
            return ;
        }
        
        
       
        
        //NSDictionary *nmaSettings = [Nma settings]; // global variable
        //NSDictionary *nmaNmaSettings = [nmaSettings objectForKey:@"nma"]; // global variable
        NSString *nmaAppStatus = [nmaNmaSettings objectForKey:@"app_status"];
        NmaLogDebug(@"[nma] app_status: %@", nmaAppStatus); // common status: debug, in-review, {blank}=live in app store
        
        BOOL nmaDisabled = [[nmaNmaSettings objectForKey:@"Disable_NMA_Settings"] boolValue];
        BOOL tapjoyIsDisabled = [[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_Disabled"] boolValue];
        BOOL apsalarIsDisabled = [[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_Disabled"] boolValue];
        BOOL flurryIsDisabled = [[[nmaSettings objectForKey:@"Flurry"] objectForKey:@"Flurry_Disabled"] boolValue];
        BOOL mobclixIsDisabled = [[[nmaSettings objectForKey:@"Mobclix"] objectForKey:@"Mobclix_Disabled"] boolValue];
        chartboostSettings = [nmaSettings objectForKey:@"ChartBoost"];
        chartboostIsDisabled = [[chartboostSettings objectForKey:@"ChartBoost_App_Disabled"] boolValue];
        
        //NmaLogDebug(@"nmaSettings: %@", nmaSettings);
        NmaLogDebug(@"Disable_NMA_Settings: %@", nmaDisabled?@"YES":@"NO");
        NmaLogDebug(@"Tapjoy Disabled: %@", tapjoyIsDisabled?@"YES":@"NO");
        NmaLogDebug(@"Apsalar Disabled: %@", apsalarIsDisabled?@"YES":@"NO");
        NmaLogDebug(@"Flurry Disabled: %@", flurryIsDisabled?@"YES":@"NO");
        NmaLogDebug(@"Mobclix Disabled: %@", mobclixIsDisabled?@"YES":@"NO");
        NmaLogDebug(@"Chartboost Disabled: %@", chartboostIsDisabled?@"YES":@"NO");
        
        [[NmaSDK sharedNmaSDK] enableNmaPush];
        //[self nmaLaunchNagScreen];  // moved to didBecomeActive
        //[RevMobAds showFullscreenAdWithAppID:REVMOB_ID]; // moved to didBecomeActive
        if (!chartboostIsDisabled)  {
            chartboostAppID = [chartboostSettings objectForKey:@"ChartBoost_App_ID"];
            chartboostAppSignature = [chartboostSettings objectForKey:@"ChartBoost_App_Signature"];
            chartboostNagDisabled = [[chartboostSettings objectForKey:@"ChartBoost_Nag_Disabled"] boolValue];
            chartboostMoreDisabled = [[chartboostSettings objectForKey:@"ChartBoost_More_Disabled"] boolValue];
            
            NmaLogDebug(@"Chartboost Settings: id= %@  sig = %@", chartboostAppID, chartboostAppSignature);
            NmaLogDebug(@"Chartboost Nag Disabled: %@", chartboostNagDisabled?@"YES":@"NO");
            NmaLogDebug(@"Chartboost More Disabled: %@", chartboostMoreDisabled?@"YES":@"NO");
            
            Chartboost *cb = [Chartboost sharedChartboost];
            cb.appId = chartboostAppID;
            cb.appSignature = chartboostAppSignature;
            cb.delegate = self;
            [cb startSession];
            if (!chartboostMoreDisabled)  [cb cacheMoreApps];
            if (!chartboostNagDisabled)  [cb cacheInterstitial:@"Ninja Skeleton"];
            // [[ChartBoost sharedChartBoost] showInterstitial:@"launched"]; // Moved to didBecomeActive
        }
        BOOL revmobIsDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_Disabled"] boolValue];
        REVMOB_ID = [[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_APP_ID"];
        if (!revmobIsDisabled) [RevMobAds startSessionWithAppID:REVMOB_ID];
		
        if (!flurryIsDisabled) {
            [Flurry startSession:[[nmaSettings objectForKey:@"Flurry"] objectForKey:@"Flurry_SS_ID"]];
            //[FlurryAnalytics setUserID:nmaSessionID];
        }
        if (!apsalarIsDisabled) [Apsalar startSession:[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_Key"] withKey:[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_SS_ID"]];
        if (!tapjoyIsDisabled) {
            [TapjoyConnect requestTapjoyConnect:[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_APP_ID"]  secretKey:[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_Secret_Key"]];
            //[TapjoyConnect requestTapjoyConnect:@"bce7db6a-d86d-4b23-9aba-f569a9ffaee1" secretKey:@"BqwF7OZ9zRt4qpXvVYbQ"];
            NmaLogDebug(@"[TapjoyConnect requestTapjoyConnect:@\"%@\" secretKey:@\"%@\"];",[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_APP_ID"] ,[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_Secret_Key"]);
        }
        if (!mobclixIsDisabled) [Mobclix startWithApplicationId:[[nmaSettings objectForKey:@"Mobclix"] objectForKey:@"Mobclix_APP_ID"]];
        [[NmaSDK sharedNmaSDK] nmaAllPush:@"0"];  // Reset Badge on icon to blank
        
      
        
        [[NmaFacebook sharedInstance]initWithApiKey:[[nmaSettings objectForKey:@"Facebook"] objectForKey:@"Facebook_APP_ID"]];
        [NmaTileMenu preloadTileMenu];

        self.viewController = [[[NinjaMyAppViewController alloc] init] autorelease];

        //[SVProgressHUD dismiss];
        [self  nmaApplicationDidBecomeActive];
        nmaStartSessionCompleted = YES;
    }];
    
     
    return YES;

}

-(void)tjcConnectSuccess:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Succeeded");
}


- (void)tjcConnectFail:(NSNotification*)notifyObj
{
	NSLog(@"Tapjoy connect Failed");
}

-(BOOL)shouldDisplayLoadingViewForMoreApps{
    return YES;
}



- (void) applicationDidFinishLaunching
{

//    // Starting session of FMNowSDK
//	[FMNow  startSessionWithDomain:FMNowAccountKey handler:^(NSDictionary *newSettings, NSError *error) {if (error) {return;}       
//        // Enable FMnow Push Notification
//        [[FourmnowSDK sharedFourmnowSDK]enableFourmnowPush];
//        // Called the FMNow Nag Screen
//        [self fmnowlaunchNagScreen];
//	}];
//    
//    // Apsalar initialization
//    [Apsalar startSession:@"dmapps" withKey:@"76NzNtuo"];
//    
    // Configuring ChartBoost
    //Chartboost
//    Chartboost *cb = [Chartboost sharedChartboost];
//    cb.appId = @"4fc7a4a3f776593c69000017";
//    cb.appSignature = @"ac75fb17c345443abead69a046151155456f0799";
//    //[cb install];//for old version
//
//    [cb startSession];
//    [cb cacheInterstitial];
//    [cb showInterstitial];

    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"runBefore"])
    {
        [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:@"volumeMusic"];
        [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:@"volumeSoundEffects"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"runBefore"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"OpenLevelInPack_1"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"OpenLevelInPack_2"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"OpenLevelInPack_3"];
        //[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"OpenPack"];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OpenPack1"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OpenPack2"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OpenPack3"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"RooBucks"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_1"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_2"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_3"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_4"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_5"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_6"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_7"];
        [[NSUserDefaults standardUserDefaults] setInteger:NSIntegerMax forKey:@"Time_In_Level_8"];
    }
    

    
    
    [MKStoreManager sharedManager];
    
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	CCGLView *glView = [CCGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// //kEAGLColorFormatRGB565
								   depthFormat:GL_DEPTH_COMPONENT24_OES //GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director = (CCDirectorIOS*)[CCDirector sharedDirector];
    
	director.wantsFullScreenLayout = YES;
    
	// Display FSP and SPF
	[director setDisplayStats:NO];
    

    
	// set FPS at 60
	[director setAnimationInterval:1.0/60];
    
	// attach the openglView to the director
	[director setView:glView];
    
	// for rotation and other messages
	[director setDelegate:self];
    
	// 2D projection
	[director setProjection:kCCDirectorProjection2D];
    [[CCDirector sharedDirector].view setMultipleTouchEnabled:YES];
    
   DeviceInfo *deviceInfo=  [[DeviceInfo alloc] init];

    if ((deviceInfo.isIPhone && deviceInfo.generationMajor > 3) ||
        (deviceInfo.isIPad && deviceInfo.generationMajor > 2) ||
        deviceInfo.isSimulator)
    {
        [director setDepthTest: NO];
        if( ! [director enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
        [[CCDirector sharedDirector] setDepthTest: YES];
        
    }
    [deviceInfo release];

    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-hd"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	[director setProjection:kCCDirectorProjection2D];//add
    
    
	[director setAnimationInterval:1.0/60];//add
	//[director setDisplayStats:YES];//add
	

    // Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
    
	// Create a Navigation Controller with the Director
	navController = [[UINavigationController alloc] initWithRootViewController:director];
	navController.navigationBarHidden = YES;
	
	// set the Navigation Controller as the root view controller
	[window setRootViewController:navController];
	
	// make main window visible
	[window makeKeyAndVisible];
    
    [CCTMXMapInfo applyParserExtension];

}

- (void)loadingData
{
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Main_menu.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"Zvuk_Klika_1.caf"];
}


#pragma Mark Remote Notification Handling Delegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [self nmaRegisterDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self nmaHandlePush:userInfo];
}

- (void)nmaRegisterDeviceToken:(NSData*)deviceToken{
    NSLog(@"nmaRegisterDeviceToken");
    [[NmaSDK sharedNmaSDK]nmaRegisterDeviceToken:deviceToken forAccount:NmaAccountKey withDelegate:self];
}
- (void)nmaHandlePush:(NSDictionary*)pushDictionary{
    [[NmaSDK sharedNmaSDK] nmaHandlePush:pushDictionary withViewController:self];
}


#pragma Mark FMNowSDK Integration End

- (void)applicationWillResignActive:(UIApplication *)application {
    if( [navController visibleViewController] == director )
		[director pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (nmaStartSessionCompleted)
        [self  nmaApplicationDidBecomeActive];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isPaused"])
    {
        if( [navController visibleViewController] == director )
            [director resume];
    }
}

- (void)nmaApplicationDidBecomeActive{
    NmaLogDebug(@"applicationDidBecomeActive");
    [self nmaLaunchNagScreen];
    if (!chartboostIsDisabled) if (!chartboostNagDisabled) [[Chartboost sharedChartboost] showInterstitial:@"NinjaMyApp Skeleton"]; // insert your own label here, but change the caching too!//*/
    
    BOOL revmobIsDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_Disabled"] boolValue];
    BOOL revmobFullscreenDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_fullscreen_disabled"] boolValue];
    BOOL revmobPopupDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_popup_disabled"] boolValue];
    
    NmaLogDebug(@"RevMob appid: %@", REVMOB_ID);
    NmaLogDebug(@"RevMob disabled: %@", revmobIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"RevMob full-screen disabled: %@", revmobFullscreenDisabled?@"YES":@"NO");
    NmaLogDebug(@"RevMob popup disabled: %@", revmobPopupDisabled?@"YES":@"NO");
    
    if (!revmobIsDisabled && !revmobFullscreenDisabled) [RevMobAds showFullscreenAd];
    if (!revmobIsDisabled && !revmobPopupDisabled)[RevMobAds showPopup];//*/
}

- (void)nmaLaunchNagScreen{
    [viewController nmaLaunchNagScreen];
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[NmaFacebook sharedInstance].facebook handleOpenURL:url];
}

// Nma More Games Handler
- (void)nmaLaunchMoreGames{
    [self playEffectClick];
//    [navController pushViewController:viewController animated:YES];
//    navController.navigationBarHidden = NO;
    //[viewController nmaLaunchMoreGames];
    //[director.view addSubview:viewController.view];
    [self MoreGames];
}

- (void)MoreGames{
    
    BOOL chartboostIsDisabled = [[[nmaSettings objectForKey:@"ChartBoost"] objectForKey:@"ChartBoost_App_Disabled"] boolValue];
    BOOL chartboostMoreDisabled = [[[nmaSettings objectForKey:@"ChartBoost"] objectForKey:@"ChartBoost_More_Disabled"] boolValue];
    NmaLogDebug(@"CB More Disabled: %@", chartboostMoreDisabled?@"YES":@"NO");
    if (!chartboostIsDisabled && !chartboostMoreDisabled) [[Chartboost sharedChartboost] showMoreApps];
    NSArray *allMoreScreens = [nmaNmaSettings objectForKey:@"MoreScreens"];
    NmaLogDebug(@"MoreScreens: %@", allMoreScreens);
    NmaLogDebug(@"morescreens count: %d", [allMoreScreens count]);
    BOOL nmaMoreIsDisabled = ([allMoreScreens count] < 1);
    NmaLogDebug(@"More Disabled: %@", nmaMoreIsDisabled?@"YES":@"NO");
    //if (nmaMoreIsDisabled)  return;
    NmaCarouselViewController *album = [[NmaCarouselViewController alloc]init];
    NSArray *moreScreens = [NSArray arrayWithObjects: @"description", @"launchpad", @"carousel", @"tile", @"list", @"appstore", nil];
    NmaLogDebug(@"create array");
    NSString *nmaMorescreenView = [[nmaNmaSettings objectForKey:@"MoreScreen_Settings"] objectForKey:@"morescreen_viewcontroller"];
    NmaLogDebug(@"morescreen viewcontroller = %@", nmaMorescreenView);
    NSUInteger nmaMorescreenIndex = [moreScreens indexOfObject:nmaMorescreenView];
    NmaLogDebug(@"morescreen index = %i", nmaMorescreenIndex);
    BOOL nmaRandomMore = [nmaMorescreenView isEqualToString:@"random"];
    if (nmaRandomMore) {
        nmaMorescreenIndex = (arc4random() % 6);
        NmaLogDebug(@"random index = %i", nmaMorescreenIndex);
    }
    switch (nmaMorescreenIndex)
    {
            // @"description", @"launchpad", @"carousel", @"tile", @"list", @"appstore"
        case 1:
            NmaLogDebug (@"morescreen viewcontroller = launchpad");
            [[NmaLaunchPadController sharedLaunchPad]nmaShowLaunchPadOnViewController:director];
            break;
        case 2:
            NmaLogDebug (@"morescreen viewcontroller = carousel");
            [director presentModalViewController:album animated:YES];
            break;
        case 3:
            NmaLogDebug (@"morescreen viewcontroller = tile");
        case 4:
            NmaLogDebug (@"morescreen viewcontroller = list");
        case 5:
            NmaLogDebug (@"morescreen viewcontroller = appstore");
            [director presentModalViewController:album animated:YES];
            break;
        case 0:
            NmaLogDebug (@"morescreen viewcontroller = description");
        default:
            NmaLogDebug (@"morescreen viewcontroller = (blank)");
            [[NmaMoreApps shardedNmaMoreApps]nmaShowMoreAppsOnViewController:director];
            break;
    }
}

// Nma News Letter signup screen
- (void)nmaLaunchNews{
    [self playEffectClick];
    [viewController nmaLaunchNews];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	if( [navController visibleViewController] == director )
		[director stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	if( [navController visibleViewController] == director )
		[director startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    CC_DIRECTOR_END();
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
    
    [window release];
	[navController release];
	[super dealloc];
}

//
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(self.director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[self.director runWithScene: [IntroMovieScene scene]];
	}
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
