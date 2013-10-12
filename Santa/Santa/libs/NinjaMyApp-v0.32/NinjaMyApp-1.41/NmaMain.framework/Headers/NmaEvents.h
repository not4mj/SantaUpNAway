//
//  NmaEvents.h
//  PlistDownloaderf
//
//  Created by Hafiz on 6/9/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//Nma Events
#define AppLaunch @"AppLaunch"
#define ResignActive @"ResignActive"
#define DidBecomeActive @"DidBecomeActive"
#define SessionError @"SessionError"
#define AppTerminate @"AppTerminate"
#define AppSigTimeChanged @"AppSigTimeChanged"


@interface NmaEvents : NSObject

// Singleton Instance
+(NmaEvents*)sharedEvents;

+ (void)setNmaEvent:(NSString*)eventName withSUDID:(NSString*)sudid;
// Set Nma Start Event
+ (void)setNmaId:(NSString*)eventId setNmaEvent:(NSString*)event;

//Set Nma End Event
+ (void)setNmaId:(NSString*)eventId setNmaEvent:(NSString*)event setNmaEndEvent:(NSString*)event;

// Set Nma Event with Various Parameter
+ (void)setNmaId:(NSString*)eventId setNmaEventDictionary:(NSDictionary*)eventDictionary;

//Set Nma End Event With Various Parameter
+ (void)setNmaId:(NSString*)eventId setNmaEndEvent:(NSString*)event setNmaEndEventDictionary:(NSDictionary*)eventDictionary;


@end
