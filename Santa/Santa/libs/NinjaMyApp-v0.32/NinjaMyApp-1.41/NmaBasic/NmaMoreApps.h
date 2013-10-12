//
//  NmaMoreApps.h
//  NmaSDK
//
//  Created by Hafizur Rahman on 2/12/12.
//  Copyright (c) 2012 Abby's LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_TABLEVIEW_ROW_HEIGHT  135
#define k_TABLEVIEW_ROW_HEIGHT_PAD 135

@protocol NmaMoreAppsDelegate <NSObject>
@optional
- (void)nmaMoreScreenDidCancel;
@end

@interface NmaMoreApps : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
}
@property (nonatomic, strong)UITableView *moreTableView;
@property (nonatomic, strong)id<NmaMoreAppsDelegate> delegate;
@property (nonatomic, strong) NSArray *objectArray;

+(NmaMoreApps*)shardedNmaMoreApps;
- (void)nmaShowMoreAppsOnViewController:(UIViewController*)viewController;
@end

