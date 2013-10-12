//
//  NmaBanner.h
//  NmaSDK
//
//  Created by Hafizur Rahman on 2/12/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_BANNER_TAG 9898

@protocol NmaBannerDelegate;


@interface NmaBanner : UIView<UIWebViewDelegate> {
	UIInterfaceOrientation	fmOrientation;
    UIImage *fmBannerImage;
    NSInteger fmBnIndex;
}
@property (nonatomic, retain) id <NmaBannerDelegate>delegate;
+(NmaBanner*)sharedNmaBanner;
- (void)nmaShowBannerScreenOnViewController:(UIViewController*)onViewController;
@end

#pragma mark PopupControllerDelegate
@protocol NmaBannerDelegate<NSObject>
@optional
- (void)mmaBannerScreenDidLoad:(NmaBanner*)NmaBannerView;
- (void)nmaBannerScreenDidFailedToLoad:(NmaBanner*)NmaBannerView;
- (void)nmaBannerScreenDidCancel;

@end

