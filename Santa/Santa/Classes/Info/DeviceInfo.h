//
//  DeviceInfo.h
//  Eyeris
//
//  Created by Ivan Zezyulya on 24.01.12.
//  Copyright (c) 2012 1618Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// Known devices:
//	iPhone1,1 = iPhone 1G
//	iPhone1,2 = iPhone 3G
//	iPhone2,1 = iPhone 3GS
//	iPhone3,1 = iPhone 4
//	iPhone3,3 = Verizon iPhone 4
//	iPhone4,1 = iPhone 4S
//	iPod1,1 = iPod Touch 1G
//	iPod2,1 = iPod Touch 2G
//	iPod3,1 = iPod Touch 3G
//	iPod4,1 = iPod Touch 4G
//	iPad1,1 = iPad
//	iPad2,1 = iPad 2 (WiFi)
//	iPad2,2 = iPad 2 (GSM)
//	iPad2,3 = iPad 2 (CDMA)
//  iPad3,1 = iPad 3 (WiFi)
//  iPad3,2 = iPad 3 (GSM)
//  iPad3,3 = iPad 3 (CDMA)
//	i386 = Simulator
//	x86_64 = Simulator
//

@interface DeviceInfo : NSObject

@property (nonatomic, strong, readonly) NSString *platform;

@property (nonatomic, readonly) BOOL isIPhone;
@property (nonatomic, readonly) BOOL isIPad;
@property (nonatomic, readonly) BOOL isIPod;
@property (nonatomic, readonly) BOOL isSimulator;

@property (nonatomic, readonly) int generationMajor;
@property (nonatomic, readonly) int generationMinor;

@end
