//
//  NmaSMS.h
//  NmaSHLib
//
//  Created by Andrey K on 7/14/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface NmaSMS : NSObject<MFMessageComposeViewControllerDelegate>
+(NmaSMS*)sharedInstance;
@property(nonatomic,assign) id<MFMessageComposeViewControllerDelegate> delegate;
-(void) nmaSend:(NSString*)text phoneNumber:(NSString*)phoneNumber withRootController:(UIViewController*)rootViewController;
-(void) nmaSend:(NSString*)text phoneNumbers:(NSArray*)phoneNumbers withRootController:(UIViewController*)rootViewController;
@end
