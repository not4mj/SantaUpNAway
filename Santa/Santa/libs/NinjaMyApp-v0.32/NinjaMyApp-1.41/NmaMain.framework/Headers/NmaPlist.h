//
//  NmaPlist.m
//  PlistDownloader
//
//  Created by Hafizur Rahman on 28/04/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


extern int nma_debug_level;
#define ACCOUNT_DOMAIN @"curr_domain"
#define NmaSDKLogError(fmt, ...) if (nma_debug_level & 2) NSLog((@"-Error: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaSDKLogWarn(fmt, ...) if (nma_debug_level & 8) NSLog((@"-Warning: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaSDKLogInfo(fmt, ...) if (nma_debug_level & 32) NSLog((@"-Info: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaSDKLogDebug(fmt, ...) if (nma_debug_level & 128) NSLog((@"-Debug: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

#define NmaLogError(fmt, ...) if (nma_debug_level & 4) NSLog((@"-User Error: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaLogWarn(fmt, ...) if (nma_debug_level & 16) NSLog((@"-User Warning: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaLogInfo(fmt, ...) if (nma_debug_level & 64) NSLog((@"-User Info: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NmaLogDebug(fmt, ...) if (nma_debug_level & 256) NSLog((@"-User Debug: %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

typedef void(^StartSessionHandler)(NSDictionary* newSettings, NSError* error);
typedef  void(^AssetHandler)(BOOL success, NSError* error);

@interface Nma : NSObject

/**
 Should be run as soon as the application starts
 */
+ (void) startSession:(NSString*)domain handler:(StartSessionHandler)handler;
+ (void) startSession:(NSString*)domain settingsVersion:(NSString *) settingsVersion handler:(StartSessionHandler)handler;
+ (void) cachedAssetswithHandler:(AssetHandler)handler;
/**
 Settings retrieval methods
 */
+ (NSDictionary*) settings;

+ (BOOL) hasSettingForKey:(NSString*)key;
+ (NSObject*) objectSettingForKey:(NSString*)key;
+ (NSString*) stringSettingForKey:(NSString*)key;
+ (CGFloat) floatSettingForKey:(NSString*)key;
+ (NSInteger) intSettingForKey:(NSString*)key;
+ (void) loadSettingsFormAWS;
+ (void) loadSettingsFormSDN;
@end