//
//  InAppPurchaseManager.h
//  Invisibles
//
//  Created by naceka on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import "NmaIAP.h"
#define PURCHASE_01 @"NMASK_1"
#define PURCHASE_02 @"NMASK_2"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"


@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSMutableDictionary * productsRequests;
    UIAlertView *alertView;
    UIActivityIndicatorView *indicator;
}

- (BOOL)canMakePurchases;
- (void)firstPurchase;
- (void)secondPurchase;
+ (id) getInstance;
- (void) clean;
@end
