//
//  NmaEmail.h
//  NmaSHLib
//
//  Created by Lion User on 7/14/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface NmaEmail : NSObject<MFMailComposeViewControllerDelegate>
+(NmaEmail*)sharedInstance;
@property(nonatomic,assign) id<MFMailComposeViewControllerDelegate> delegate;
- (void) nmaSend:(NSString*)text subject:(NSString *)subject image:(UIImage *)image emailAddress:(NSString *)emailAddress withRootController:(UIViewController*)rootViewController;
- (void) nmaSend:(NSString*)text subject:(NSString *)subject emailAddress:(NSString *)emailAddress withRootController:(UIViewController*)rootViewController;
- (void) nmaSend:(NSString*)text subject:(NSString *)subject emailAddresses:(NSArray*)emailAddresses withRootController:(UIViewController*)rootViewController;
- (void) nmaSend:(NSString*)text subject:(NSString *)subject images:(NSArray *)images emailAddresses:(NSArray*)emailAddresses withRootController:(UIViewController*)rootViewController;
@end
