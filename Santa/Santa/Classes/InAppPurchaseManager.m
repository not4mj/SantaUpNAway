//
//  InAppPurchaseManager.m
//  Invisibles
//
//  Created by naceka on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"
#import <StoreKit/StoreKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "NmaIAP.h"
#import <NmaMain/NmaPlist.h>
#import <NmaMain/NmaMain.h>
@implementation InAppPurchaseManager
InAppPurchaseManager * purchase = nil;


#pragma -
#pragma Public methods

//
// call this method once on startup
//
- (void)loadStore
{
    // restarts any purchases if they were interrupted last time the app was open
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // get the product description (defined in early sections)
    NSSet *productIdentifiers = [NSSet setWithObject:PURCHASE_01];
    SKProductsRequest * tmp;
    
    tmp = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    [productsRequests setValue:tmp forKey:PURCHASE_01];
    tmp.delegate = self;
    [tmp start];
    
    productIdentifiers = [NSSet setWithObject:PURCHASE_02];
    tmp = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    [productsRequests setValue:tmp forKey:PURCHASE_02];
    tmp.delegate = self;
    [tmp start];
    
}

+ (id) getInstance{
    if (!purchase){ 
        purchase = [[InAppPurchaseManager alloc] init];
        [purchase loadStore];
    }
    return purchase;
}
- (void) clean{
    [productsRequests release];
    [purchase release];
    purchase = nil;
}
- (void) stillPurchasing {
    
    alertView  = [[UIAlertView alloc]initWithTitle: @"In App Purchase" message: @"Processing your purchase..." delegate: nil cancelButtonTitle: nil otherButtonTitles: nil];
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    [alertView addSubview: indicator];
    [alertView show];
    CGRect frame = indicator.frame;
    frame.origin.x = alertView.frame.size.width / 2 - indicator.frame.size.width;
    frame.origin.y = alertView.frame.size.height / 2 - indicator.frame.size.height / 6;
    indicator.frame = frame;//*/
}
-(void) releasePurchasing{
    if (indicator && alertView) {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [alertView release];
        [indicator release]; 
        indicator = nil;
        alertView = nil;        
    }
}

-(id)init{
    if((self = [super init])){
        productsRequests = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (BOOL) checkNetwork {
    // Create zero addy
    struct sockaddr zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sa_len = sizeof(zeroAddress);
    zeroAddress.sa_family = AF_INET;
	
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
	
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
	
    if (!didRetrieveFlags)
    {
        NmaLogError("Error. Could not recover network reachability flags\n");
        return 0;
    }
	
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    if(!(isReachable && !needsConnection) ? YES : NO){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection." 
                                                        message:@"Cannot connect to the iTunes Store." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark SKProductsRequestDelegate methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    for (SKProduct * product in products) {
        if (product)
        {
            NmaLogInfo(@"Product title: %@" , product.localizedTitle);
            NmaLogInfo(@"Product description: %@" , product.localizedDescription);
            NmaLogInfo(@"Product price: %@" , product.price);
            NmaLogInfo(@"Product id: %@" , product.productIdentifier);
            SKProductsRequest * tmp = [productsRequests objectForKey:product.productIdentifier];
            [tmp release];
        }
    }
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        NmaLogError(@"Invalid product id: %@ check your In-App Purchases settings", invalidProductId);
        /*NSString * error = [NSString stringWithFormat:@"Invalid product id: \"%@\" check your In-App Purchases settings", invalidProductId];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"AppStore Error:" message: error
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];//*/
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}




//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

//
// kick off the upgrade transaction
//
- (void)firstPurchase
{

    NmaLogInfo(@"firstPurchase");
    if([[NSUserDefaults standardUserDefaults] boolForKey:PURCHASE_01]){
        NSLog(@"Purchase %@ already made", PURCHASE_01);
        return;
    }
    if (![NmaIAP nmaIsVerifyServerAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Verify Server unavailable."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if(![self checkNetwork]){
        NmaLogInfo(@"checkNetwork error");
        return;
    }
    if([purchase canMakePurchases]){
        NmaLogInfo(@"Purchasing %@ in progress", PURCHASE_01);
        [self stillPurchasing];

        SKPayment *payment = [SKPayment paymentWithProductIdentifier:PURCHASE_01];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Purchases unavailable right now."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)secondPurchase
{
    NmaLogInfo(@"secondPurchase");
    if([[NSUserDefaults standardUserDefaults] boolForKey:PURCHASE_02]){
        NmaLogWarn(@"Purchase %@ already made", PURCHASE_02);
        return;
    }
    if (![NmaIAP nmaIsVerifyServerAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Verify Server unavailable."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if(![self checkNetwork])
        return;
    if([purchase canMakePurchases]){
        NmaLogInfo(@"Purchasing %@ in progress", PURCHASE_02);
        [self stillPurchasing];
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:PURCHASE_02];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Purchases unavailable right now."
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

#pragma -
#pragma Purchase helpers

//
// saves a record of the transaction by storing the receipt to disk
//
- (void)recordTransaction:(SKPaymentTransaction *)transaction
{
    NmaLogInfo(@"recordTransaction");
    if ([transaction.payment.productIdentifier isEqualToString:PURCHASE_01] || 
        [transaction.payment.productIdentifier isEqualToString:PURCHASE_02]){
        // save the transaction receipt to disk
        
        
        NmaLogInfo(@"Receipt: %@", transaction.payment.productIdentifier);
        [[NSUserDefaults standardUserDefaults] setValue:transaction.transactionReceipt forKey:[NSString stringWithFormat: @"%@ TransactionReceipt", transaction.payment.productIdentifier]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Done! Your new them with ID:%@ is installed!", transaction.payment.productIdentifier] message: transaction.payment.accessibilityLabel
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey: transaction.payment.productIdentifier];
    }else {
        NmaLogError(@"productIdentifier %@ was not found", transaction.payment.productIdentifier);
    }
}

//
// enable pro features
//
- (void)provideContent:(NSString *)productId
{
    NmaLogInfo(@"provideContent");
    if ([productId isEqualToString:PURCHASE_01] || [productId isEqualToString:PURCHASE_02])
    {
        // enable the pro features
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productId];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//
// removes the transaction from the queue and posts a notification with the transaction result
//
- (void)finishTransaction:(SKPaymentTransaction *)transaction wasSuccessful:(BOOL)wasSuccessful
{
    NmaLogInfo(@"finishTransaction");
    // remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:transaction, @"transaction" , nil];
    if (wasSuccessful)
    {
        // send out a notification that we’ve finished the transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionSucceededNotification object:self userInfo:userInfo];
    }
    else
    {
        // send out a notification for the failed transaction
        [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerTransactionFailedNotification object:self userInfo:userInfo];
    }
}

//
// called when the transaction was successful
//
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NmaLogInfo(@"completeTransaction");
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has been restored and and successfully completed
//
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NmaLogInfo(@"restoreTransaction");
    [self recordTransaction:transaction.originalTransaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];
    [self finishTransaction:transaction wasSuccessful:YES];
}

//
// called when a transaction has failed
//
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NmaLogError(@"failedTransaction");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // error!
        [self finishTransaction:transaction wasSuccessful:NO];
    }
    else
    {
        // this is fine, the user just cancelled, so don’t notify
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver methods

//
// called when the transaction status is updated
//
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NmaLogInfo(@"SKPaymentTransactionStatePurchased");
                [NmaIAP nmaIsReceiptValid: transaction.originalTransaction];
                [self releasePurchasing];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NmaLogInfo(@"SKPaymentTransactionStateFailed");
                [self releasePurchasing];
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                NmaLogInfo(@"SKPaymentTransactionStateRestored");
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

@end
