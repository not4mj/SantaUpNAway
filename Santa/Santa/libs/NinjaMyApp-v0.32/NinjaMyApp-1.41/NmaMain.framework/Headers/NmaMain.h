//
//  NmaMain.h
//  NmaSDK
//
//  Created by Hafizur Rahman on 2/12/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NmaPlist.h"
#import <GameKit/GameKit.h>
#import "NmaEvents.h"


/*#ifdef DEBUG
#   define CILog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define CILog(...)
#endif*/

#define k_SDK_VERSION @"1.41"


#define k_NMA_SETTINGS_VERSION @"NMA_SETTINGS_VERSION"
#define k_NMA    [[NSUserDefaults standardUserDefaults]objectForKey:k_ACCOUNT_KEY]
#define k_ScrWidth [[UIScreen mainScreen] bounds].size.width
#define k_ScrHeight [[UIScreen mainScreen] bounds].size.height
#define k_ScrCenterP CGPointMake(k_ScrWidth / 2,k_ScrHeight / 2)
#define k_ScrCenterL CGPointMake(k_ScrHeight / 2, k_ScrWidth / 2)

#define k_ScreenSize CGSizeMake(k_ScrWidth,k_ScrHeight)

//#define k_PLIST_KEY @"PLIST_SETTINGS"
//#define nmaSettings [[NSUserDefaults standardUserDefaults]objectForKey:k_PLIST_KEY]

#define nmaSettings [Nma settings]
#define nmaNmaSettings [nmaSettings objectForKey:@"nma"]
#define nmaCustomSettings [nmaSettings objectForKey:@"Custom_Settings"]

@protocol PushRegisterProtocol <NSObject>

- (void)pushDidRegisterWithToken:(NSString*)token forSUUDID:(NSString*)sudid;

@end

@interface NmaSDK : NSObject

+(NmaSDK*)sharedNmaSDK;

- (NSDictionary*) settings;

// Initialize nma Push
- (void)enableNmaPush;

// For Registering Device Token for Push Notification
- (void)nmaRegisterDeviceToken:(NSData*)deviceToken forAccount:(NSString*)account withDelegate:(id)delegate1;
// For Getting Push Device Token as string
- (NSString*)getPushTokenFromNma;

// For Getting Push Device Token as string
- (NSData*)getRawPushTokenFromNma;

// For Parsing push Notification
- (void)nmaHandlePush:(NSDictionary*)pushDictionary withViewController:(id)viewController;

// Access nmapushMessage
- (NSDictionary*)nmaPushMessages;

// Set Application Icon Badge Number
- (void)nmaAllPush:(NSString*)badgeString;
@end



