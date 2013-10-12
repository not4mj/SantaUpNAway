//
//  NmaFacebook.h
//  NmaSHLib
//
//  Created by Hafizur Rahman on 4/18/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface NmaFacebook : NSObject<FBSessionDelegate,FBDialogDelegate, 
                                            FBRequestDelegate>{
    NSMutableArray *array;
    Facebook *facebook;
}
@property(nonatomic,retain) Facebook *facebook;
@property(nonatomic,retain) id<FBSessionDelegate> delegate;
+(NmaFacebook*)sharedInstance;
- (void)initWithApiKey:(NSString*)apiKey;

+(void) nmaShare:(NSString*)text;
+(void) nmaShare:(NSString*)text redirectUrl:(NSString*)urlString;
+(void) nmaShare:(NSString*)text redirectUrl:(NSString*)urlString imageUrl:(NSString*)imageUrlString;
+(void) nmaShare:(NSString*)text imageUrl:(NSString*)imageUrl;
+(void) nmaShowFacebookPageWithId:(NSString*)pageId;
-(void) nmaShare:(NSString*)text redirectUrl:(NSString*)urlString imageUrl:(NSString*)imageUrlString;

@end
