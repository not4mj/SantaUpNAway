//
//  NmaPrivacyPolicy.h
//  NmaPrivacyPolicy
//
//  Created by Aleksandar Trpeski on 9/5/12.
//  Copyright (c) 2012 Aleksandar Trpeski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NmaPrivacyPolicy : NSObject

+ (void)nmaCheckForNewPolicy;

+ (void)nmaRemoveLocalData;

@end
