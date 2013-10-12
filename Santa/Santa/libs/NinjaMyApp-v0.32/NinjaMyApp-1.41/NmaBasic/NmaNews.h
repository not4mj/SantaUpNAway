//
//  NmaNews.h
//  NmaSDK
//
//  Created by Hafizur Rahman on 2/12/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NmaNewsDelegate;


@interface NmaNews : UIViewController<UIWebViewDelegate, UITextFieldDelegate> {
    id <NmaNewsDelegate>    delegate;
	UIInterfaceOrientation	orientation;
    UIImage *bgImage;
    NSInteger bnIndex;
    UITextField  *textField, *nameField;
    BOOL isNonCustom;
}
@property (nonatomic, retain) id <NmaNewsDelegate>delegate;
@property(nonatomic, retain)IBOutlet UIWebView  *webview;

+(NmaNews*)sharedNmaNews;
- (void)nmaShowNewsScreenOnViewController:(UIViewController*)onViewController;
- (void)nmaShowNewsLetterScreenOnViewController:(UIViewController*)onViewController;
- (void)nmaShowCustomNewsLetterScreenOnViewController:(UIViewController*)onViewController;

@end

#pragma mark PopupControllerDelegate
@protocol NmaNewsDelegate<NSObject>
@optional
- (void)nmaNewsScreenDidCancel;
@end
