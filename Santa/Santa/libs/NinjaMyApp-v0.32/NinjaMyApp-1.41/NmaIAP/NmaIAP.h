//
//  NmaIAP.h
//  InAppCheckLib
//
//  Created by Andrey K on 22.07.12.
//  Copyright (c) Abby's LLC 2012. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@protocol NmaRestoreDelegate <NSObject>
-(void)nmaRestoredProduct:(NSString *) productID receptVerified:(BOOL)receiptVerified;
-(void)nmaRestoreCompleted:(int) productsCount;
@end

@interface NmaIAP : NSObject<SKPaymentTransactionObserver>
+ (BOOL)nmaIsVerifyServerAvailable;
+ (BOOL)nmaIsReceiptValid:(SKPaymentTransaction *)transaction;
- (void)nmaRestoreCompletedTransactions:(id<NmaRestoreDelegate>) delegate_;
@property (nonatomic, strong) id<NmaRestoreDelegate> delegate;
@end
