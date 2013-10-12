//
//  TileMenuDelegate.h
//  TileMenu
//
//  Created by Andrey K on 22.19.12.
//  Copyright (c) Abby's LLC 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NmaTileMenuDelegate <NSObject>
@optional
//- (BOOL) shouldUseStandartAction: (NSString *)action;
- (void) didActionTile:(NSString *)action;
- (void) tileMenuDidDismiss;
- (void) tileMenuWillDisplay;
- (void) tileMenuDidDisplay;
@end
