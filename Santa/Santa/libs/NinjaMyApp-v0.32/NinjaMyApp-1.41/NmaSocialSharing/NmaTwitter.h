//
//  NmaTwitter.h
//  NmaSHLib
//
//  Created by Hafizur Rahman on 4/18/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NmaTwitter : NSObject{

}
+(id) nmaShare:(NSString*)text withRootController:(UIViewController*)rootViewController;

// Twitter Following Page Id
+(void) nmaShowTwitterPageWithId:(NSString*)pageId;
@end
