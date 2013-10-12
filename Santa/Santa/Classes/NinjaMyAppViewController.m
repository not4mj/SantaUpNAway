//
//  NinjaMyAppViewController.m
//  NinjaMyApp Skeleton
//
//  Created by Fred Radford on 9/23/12.
//  Copyright (c) 2012 Fred Radford. All rights reserved.
//

#import "NinjaMyAppViewController.h"
#import "Facebook.h"
#import "Chartboost.h"
#import "Mobclix.h"
#import "MobclixFullScreenAdViewController.h"
#import "GADInterstitial.h"
#import "GADBannerView.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdvertiser.h>
#import <NmaMain/NmaMain.h>
#import "NmaBasic.h"
#import "NmaCarousel.h"
#import "NmaLaunchPad.h"
#import "NmaTileMenu.h"
#import "NmaPrivacyPolicy.h"
#import "NmaSocialSharing.h"
#import "InAppPurchaseManager.h"

@interface NinjaMyAppViewController ()

@end

@implementation NinjaMyAppViewController
@synthesize mobclixFullVC;
- (IBAction)nmaLaunchTileMenu:(UIButton *)sender {
    NSLog(@"nmaLaunchTileMenu");
    [self showMenu];
}

- (void)showMenu{
    NmaLogInfo(@"[nma] showMenu");
    [[NmaTileMenu sharedInstance] showTileMenu:self delegate:self];
}
- (BOOL) shouldUseStandartAction: (NSString *)action{
    return NO;
}

- (void) didActionTile:(NSString *)action{
    NmaSDKLogDebug(@"Launched action: %@", action);
    if([action isEqualToString:@"buy_one"]){
        if(![[InAppPurchaseManager getInstance] canMakePurchases])
            return;
        [[InAppPurchaseManager getInstance] firstPurchase];
    }else if([action isEqualToString:@"buy_two"]){
        if(![[InAppPurchaseManager getInstance] canMakePurchases])
            return;
        [[InAppPurchaseManager getInstance] secondPurchase];
    }else if([action isEqualToString:@"restore"]){
        if (![NmaIAP nmaIsVerifyServerAvailable]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Verification Server Unavailable" message:@"Check your Internet Connection or Try Again Later"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        NSLog(@"Restore reqest");
        [[InAppPurchaseManager getInstance] clean];
        [[[NmaIAP alloc] init] nmaRestoreCompletedTransactions:self];
    }else if([action isEqualToString:@"app_launch"]){
        [NmaEvents setNmaId:@"Level_1" setNmaEvent:@"Start at app_launch"];
    }else if([action isEqualToString:@"resign_active"]){
        [NmaEvents setNmaId:@"Level_1" setNmaEvent:@"End at resign_active"];
    }else if([action isEqualToString:@"facebook_like"]){
        [NmaFacebook nmaShowFacebookPageWithId:[[nmaSettings objectForKey:@"Facebook"] objectForKey:@"Facebook_Key"]];
    }else if([action isEqualToString:@"facebook_post"]){
        [NmaFacebook sharedInstance].delegate = self;
        [NmaFacebook nmaShare:@"Message" redirectUrl:@"Signup now for NinjaMyApp at http://www.NinjaMyApp.com/" imageUrl:@"http://static.ninjamyapp.com/img/NinjaMyApp_icon_144.png"];
    }else if([action isEqualToString:@"twitter_msg"]){
        [NmaTwitter nmaShare:@"Check out what @NinjaMyApp is doing!" withRootController:self];
    }else if([action isEqualToString:@"twitter_like"]){
        [NmaTwitter nmaShowTwitterPageWithId:[[nmaSettings objectForKey:@"Twitter"] objectForKey:@"Twitter_Username"]];
    }else if([action isEqualToString:@"sms"]){
        [[NmaSMS sharedInstance] nmaSend:@"NinjaMyApp is Cool!!!  Signup for access now: http://NinjaMyApp.com" phoneNumber:@"" withRootController:self];
    }else if([action isEqualToString:@"mail"]){
        [[NmaEmail sharedInstance] nmaSend:@"" subject:@"NinjaMyApp is Cool!!!" emailAddress:@"support@ninjamyapp.net" withRootController:self];
    }else if([action isEqualToString:@"nag_screen"]){
        [self nmaLaunchNagScreen];
    }else if([action isEqualToString:@"more_games"]){
        [self nmaLaunchMoreGames];
    }else if([action isEqualToString:@"news"]){
        [self nmaLaunchNews];
    }else if([action isEqualToString:@"launch_pad"]){
        [[NmaLaunchPadController sharedLaunchPad] nmaShowLaunchPadOnViewController:self];
    }else if([action isEqualToString:@"start_Level_1"]){
        [NmaEvents setNmaId:@"Start_Level_1" setNmaEvent:@"Ninja Skeleton START"];
    }else if([action isEqualToString:@"end_level_1"]){
        [NmaEvents setNmaId:@"End_Level_1" setNmaEvent:@"Ninja Skeleton END" setNmaEndEvent:@"Start_Level_1"];
    }else if([action isEqualToString:@"cb_full_screen"]){
        [[Chartboost sharedChartboost] showInterstitial:@"Ninja Skeleton"];
    }else if([action isEqualToString:@"cb_more_games"]){
        [[Chartboost sharedChartboost] showMoreApps];
    }else if([action isEqualToString:@"rm_full_screen"]){
        [RevMobAds showFullscreenAd];
    }else if([action isEqualToString:@"rm_more_games"]){
        [RevMobAds showPopup];
    }else if([action isEqualToString:@"policy"]){
        NmaLogInfo(@"Launched CLEAR %@", action);
        [NmaPrivacyPolicy nmaRemoveLocalData];
        [NmaPrivacyPolicy nmaCheckForNewPolicy];
    }else if ([action isEqualToString:@"rm_banner"]){
        [RevMobAds showBannerAdWithDelegate:self];
    }else if ([action isEqualToString:@"rm_banner_remove"]){
        [RevMobAds deactivateBannerAd];
    }else if ([action isEqualToString:@"mobclix_fullscreen"]){
        [mobclixFullVC requestAndDisplayAdFromViewController:self];
    }else if ([action isEqualToString:@"admob_fullscreen"]){
        NSString *admobId = [[nmaSettings objectForKey:@"AdMob"] objectForKey:@"AdMob_Publisher_ID"];
        NmaLogDebug(@"AdMob ID: %@", admobId);
        if(admobInterstitial)
            [admobInterstitial release];
        admobInterstitial = [[GADInterstitial alloc] init];
        admobInterstitial.adUnitID = admobId;
        admobInterstitial.delegate = self;
        [admobInterstitial loadRequest:[GADRequest request]];
    }else if ([action isEqualToString:@"admob_banner"]){
        if(!adMobBannerView){
            NSString *admobId = [[nmaSettings objectForKey:@"AdMob"] objectForKey:@"AdMob_Publisher_ID"];
            adMobBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
            adMobBannerView.adUnitID = admobId;
            adMobBannerView.delegate = self;
            adMobBannerView.rootViewController = self;
            [self.view addSubview:adMobBannerView];
            [adMobBannerView loadRequest:[GADRequest request]];
        }
    }else if ([action isEqualToString:@"admob_remove"]){
        if(adMobBannerView){
            [adMobBannerView removeFromSuperview];
            [adMobBannerView release];
            adMobBannerView = nil;
        }
    }else if ([action isEqualToString:@"mobclix_banner"]){
        if(!mobclixBannerView){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
                mobclixBannerView= [[MobclixAdViewiPad_728x90 alloc] init];
            else
                mobclixBannerView= [[MobclixAdViewiPhone_320x50 alloc] init];
            [self.view addSubview:mobclixBannerView];
            [mobclixBannerView resumeAdAutoRefresh];
        }
    }else if ([action isEqualToString:@"mobclix_remove"]){
        if(mobclixBannerView){
            [mobclixBannerView removeFromSuperview];
            [mobclixBannerView release];
            mobclixBannerView = nil;
        }
    }else if([action isEqualToString:@"nmahomepage"]){
        [self openLink: @"http://NinjaMyApp.com"];
    }else if([action isEqualToString:@"nmasupport"]){
        [self openLink: @"http://support.NinjaMyApp.com"];
    }else if([action isEqualToString:@"nmadocs"]){
        [self openLink: @"http://docs.NinjaMyApp.com"];
    }else if([action isEqualToString:@"nmalogin"]){
        [self openLink: @"http://NinjaMyApp.com/login"];
    }else if([action isEqualToString:@"more_list"]){
        [[NmaMoreApps shardedNmaMoreApps] nmaShowMoreAppsOnViewController:self];
    }else if([action isEqualToString:@"carousel"]){
        NmaCarouselViewController *nmaAlbum = [[NmaCarouselViewController alloc]init];
        [self presentModalViewController:nmaAlbum animated:YES];
    }else if([action isEqualToString:@"banner"]){
        [[NmaBanner sharedNmaBanner] nmaShowBannerScreenOnViewController:self];
    }else{
        NmaSDKLogDebug(@"Error - Action %@ Not Found", action);
    }
}

-(void)openLink:(NSString *) link{
    NSString * url = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
}
-(void)nmaRestoredProduct:(NSString *) productID receptVerified:(BOOL)receiptVerified{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"NinjaMyApp IAP ID: %@ purchase completed", productID] message: @""
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)nmaRestoreCompleted:(int)productsCount{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d purchases were restored!", productsCount] message: @""
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [InAppPurchaseManager getInstance];
    mobclixFullVC = [[MobclixFullScreenAdViewController alloc] init];
}
#pragma Admob
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    NSLog(@"interstitialDidReceiveAd");
    [admobInterstitial presentFromRootViewController:self];
}
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"didFailToReceiveAdWithError %@", error);
}

- (void)adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"adViewDidReceiveAd");
}
- (void)adView:(GADBannerView *)view
didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"interstitialWillLeaveApplication %@", error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Mark NmaSDK Integration

// Nma Nagscreen Handler
- (void)nmaLaunchNagScreen{
    [[NmaNag sharedNmaNag]nmaShowNagScreenOnViewController:self];
}

// Nma More Games
- (void)nmaLaunchMoreGames{
    
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
            [[NmaLaunchPadController sharedLaunchPad]nmaShowLaunchPadOnViewController:self];
            break;
        case 2:
            NmaLogDebug (@"morescreen viewcontroller = carousel");
            [self presentModalViewController:album animated:YES];
            break;
        case 3:
            NmaLogDebug (@"morescreen viewcontroller = tile");
        case 4:
            NmaLogDebug (@"morescreen viewcontroller = list");
        case 5:
            NmaLogDebug (@"morescreen viewcontroller = appstore");
            [self presentModalViewController:album animated:YES];
            break;
        case 0:
            NmaLogDebug (@"morescreen viewcontroller = description");
        default:
            NmaLogDebug (@"morescreen viewcontroller = (blank)");
            [[NmaMoreApps shardedNmaMoreApps]nmaShowMoreAppsOnViewController:self];
            break;
    }
}

//Nma News Screen
- (void)nmaLaunchNews{
    
    [[NmaNews sharedNmaNews] nmaShowNewsScreenOnViewController:self];
}
- (BOOL)shouldAutorotate {
    return [self shouldAutorotateToInterfaceOrientation:self.interfaceOrientation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    UIButton * btn = (UIButton *)[self.view viewWithTag:33];
    if (!btn) 
        return YES;
    [[NmaTileMenu sharedInstance] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    if(UIInterfaceOrientationIsPortrait(interfaceOrientation)){
        btn.frame = CGRectMake(screenBound.size.width / 2 - btn.frame.size.width / 2, screenBound.size.height / 2 - btn.frame.size.height / 2, btn.frame.size.width, btn.frame.size.height);
    }else{
        btn.frame = CGRectMake(screenBound.size.height / 2 - btn.frame.size.height / 2, screenBound.size.width / 2 - btn.frame.size.width / 2,btn.frame.size.width, btn.frame.size.height);
    }
    NSLog(@"Curr pos %d",interfaceOrientation);
    return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}
- (void)fbDidLogin{
    [self didActionTile:@"facebook_post"];
}
- (void)fbDidNotLogin:(BOOL)cancelled{
    
}
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt{
    
}
- (void)fbDidLogout{
    
}
- (void)fbSessionInvalidated{
    
}
@end
