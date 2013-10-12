//
//  NmaNag.h
//  NmaSDK
//
//  Created by Hafizur Rahman on 2/12/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NmaNagDelegate;

@interface NmaNag : UIViewController{
    UIInterfaceOrientation	orientation;
    UIImage *nagImage;
}
@property (nonatomic, retain) id <NmaNagDelegate>delegate;
+(NmaNag*)sharedNmaNag;
- (void)nmaShowNagScreenOnViewController:(UIViewController*)onViewController;
@end

#pragma mark NMAnowDelegate
@protocol NmaNagDelegate<NSObject>
@optional
- (void)nmaNagScreenDidLoad:(NmaNag*)nmaNagView;
- (void)nmaNagScreenDidFailedToLoad:(NmaNag*)nmaNagView;
- (void)nmaNagScreenDidCancel;
@end