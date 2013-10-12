//
//  NmaLaunchPad.h
//  NmaMarketplaceSDK
//
//  Created by Hafiz on 2/27/12.
//  Copyright 2012 Abby's LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NmaLaunchPadController : UIViewController

@property (nonatomic, retain) NSMutableArray *nmaItems;
@property (nonatomic, strong) NSArray *nmaObjectArray;
+(NmaLaunchPadController*)sharedLaunchPad;
- (void)nmaShowLaunchPadOnViewController:(UIViewController*)viewController;
@end
