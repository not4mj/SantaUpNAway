//
//  DeviceInfo.m
//  Eyeris
//
//  Created by Ivan Zezyulya on 24.01.12.
//  Copyright (c) 2012 1618Labs. All rights reserved.
//

#import "DeviceInfo.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation DeviceInfo

@synthesize platform, isIPhone, isIPad, isIPod, isSimulator, generationMajor, generationMinor;

- (void) getPlatform
{
	size_t size;
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);
	char *machine = (char*) malloc(size);
	sysctlbyname("hw.machine", machine, &size, NULL, 0);
	platform = [NSString stringWithUTF8String:machine];
    NSLog(@"platform=%@",platform);
}

- (void) getGenerationWithVersion:(NSString *)version
{
	NSArray	*comps = [version componentsSeparatedByString:@","];

	if ([comps count] >= 1) {
		generationMajor = [[comps objectAtIndex:0] intValue];
	}
	if ([comps count] >= 2) {
		generationMinor = [[comps objectAtIndex:1] intValue];
	}
}

- (void) getInfo
{
	[self getPlatform];
	
	NSString *iPhonePrefix = @"iPhone";
	NSString *iPadPrefix = @"iPad";
	NSString *iPodPrefix = @"iPod";
	NSString *simulator32Prefix = @"i386";
	NSString *simulator64Prefix = @"x86_64";

	NSArray *prefixes = [NSArray arrayWithObjects:iPhonePrefix, iPadPrefix, iPodPrefix, simulator32Prefix, simulator64Prefix, nil];
	NSString *prefix = nil;

	for (NSString *aprefix in prefixes) {
		if ([platform hasPrefix:aprefix]) {
			prefix = aprefix;
		}
	}
	
	if (!prefix)
		return;

	NSString *version = [platform substringFromIndex:[prefix length]];
	
	[self getGenerationWithVersion:version];

	if (prefix == iPhonePrefix) {
		isIPhone = YES;
	} else if (prefix == iPadPrefix) {
		isIPad = YES;
	} else if (prefix == iPodPrefix) {
		isIPod = YES;
	} else if (prefix == simulator32Prefix || prefix == simulator64Prefix) {
		isSimulator = YES;
	}
}

- (id) init
{
	if ((self = [super init])) {
		[self getInfo];
	}

	return self;
}

@end
