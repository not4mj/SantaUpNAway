//
//  TileMenu4mnow.h
//  TileMenu
//
//  Created by Andrey K on 20.19.12.
//  Copyright (c) Abby's LLC 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NmaTileMenuDelegate.h"
#import "NmaTMProtocol.h"
@class NmaTileMenuController;
@interface NmaTileMenu : UIViewController<NmaTMProtocol>{
@private
    BOOL initMenu;
    BOOL rotationActive;
    CGPoint menuPosition;
}

@property (strong, nonatomic) NmaTileMenuController *tileController;
@property (nonatomic, strong) id<NmaTileMenuDelegate> delegate;
+ (id)sharedInstance;
- (void)showTileMenu:(UIViewController *) viewController_ delegate:(id<NmaTileMenuDelegate>)delegate_;
+ (void) preloadTileMenu;
@end
