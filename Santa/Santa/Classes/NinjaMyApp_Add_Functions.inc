- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [self nmaRegisterDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self nmaHandlePush:userInfo];
}
- (void)nmaRegisterDeviceToken:(NSData*)deviceToken{
    NSLog(@"nmaRegisterDeviceToken");
    [[NmaSDK sharedNmaSDK]nmaRegisterDeviceToken:deviceToken forAccount:NmaAccountKey withDelegate:self];
}
- (void)nmaHandlePush:(NSDictionary*)pushDictionary{
    [[NmaSDK sharedNmaSDK] nmaHandlePush:pushDictionary withViewController:self];
}

- (void)nmaDidFinishLaunching {
    //NSDictionary *nmaSettings = [Nma settings]; // global variable
    //NSDictionary *nmaNmaSettings = [nmaSettings objectForKey:@"nma"]; // global variable
    NSString *nmaAppStatus = [nmaNmaSettings objectForKey:@"app_status"];
    NmaLogDebug(@"[nma] app_status: %@", nmaAppStatus); // common status: debug, in-review, {blank}=live in app store
    
    BOOL nmaDisabled = [[nmaNmaSettings objectForKey:@"Disable_NMA_Settings"] boolValue];
    BOOL customMoreIsDisabled = [[[nmaSettings objectForKey:@"Custom_Settings"] objectForKey:@"custom_morescreen_disabled"] boolValue];
    BOOL tapjoyIsDisabled = [[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_Disabled"] boolValue];
    BOOL apsalarIsDisabled = [[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_Disabled"] boolValue];
    BOOL flurryIsDisabled = [[[nmaSettings objectForKey:@"Flurry"] objectForKey:@"Flurry_Disabled"] boolValue];
    BOOL mobclixIsDisabled = [[[nmaSettings objectForKey:@"Mobclix"] objectForKey:@"Mobclix_Disabled"] boolValue];
    chartboostSettings = [nmaSettings objectForKey:@"ChartBoost"];
    chartboostIsDisabled = [[chartboostSettings objectForKey:@"ChartBoost_App_Disabled"] boolValue];
    
    NmaLogDebug(@"nmaSettings: %@", nmaSettings);
    NmaLogDebug(@"Disable_NMA_Settings: %@", nmaDisabled?@"YES":@"NO");
    NmaLogDebug(@"Custom Morescreen disabled: %@", customMoreIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"Tapjoy Disabled: %@", tapjoyIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"Apsalar Disabled: %@", apsalarIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"Flurry Disabled: %@", flurryIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"Mobclix Disabled: %@", mobclixIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"Chartboost Disabled: %@", chartboostIsDisabled?@"YES":@"NO");
    
    [[NmaSDK sharedNmaSDK] enableNmaPush];
    //[self nmaLaunchNagScreen];  // moved to didBecomeActive
    //[RevMobAds showFullscreenAdWithAppID:REVMOB_ID]; // moved to didBecomeActive
    if (!chartboostIsDisabled)  {
        chartboostAppID = [chartboostSettings objectForKey:@"ChartBoost_App_ID"];
        chartboostAppSignature = [chartboostSettings objectForKey:@"ChartBoost_App_Signature"];
        chartboostNagDisabled = [[chartboostSettings objectForKey:@"ChartBoost_Nag_Disabled"] boolValue];
        chartboostMoreDisabled = [[chartboostSettings objectForKey:@"ChartBoost_More_Disabled"] boolValue];
        
        NmaLogDebug(@"Chartboost Settings: id= %@  sig = %@", chartboostAppID, chartboostAppSignature);
        NmaLogDebug(@"Chartboost Nag Disabled: %@", chartboostNagDisabled?@"YES":@"NO");
        NmaLogDebug(@"Chartboost More Disabled: %@", chartboostMoreDisabled?@"YES":@"NO");
        
        Chartboost *cb = [Chartboost sharedChartboost];
        cb.appId = chartboostAppID;
        cb.appSignature = chartboostAppSignature;
        cb.delegate = self;
        [cb startSession];
        if (!chartboostMoreDisabled)  [cb cacheMoreApps];
        if (!chartboostNagDisabled)  [cb cacheInterstitial:@"didBecomeActive"];
        // [[ChartBoost sharedChartBoost] showInterstitial:@"launched"]; // Moved to didBecomeActive
    }
    BOOL revmobIsDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_Disabled"] boolValue];
    REVMOB_ID = [[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_APP_ID"];
    if (!revmobIsDisabled) [RevMobAds startSessionWithAppID:REVMOB_ID];
    
    if (!flurryIsDisabled) {
        [Flurry startSession:[[nmaSettings objectForKey:@"Flurry"] objectForKey:@"Flurry_SS_ID"]];
        //[FlurryAnalytics setUserID:nmaSessionID];
    }
    if (!apsalarIsDisabled) [Apsalar startSession:[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_SS_ID"] withKey:[[nmaSettings objectForKey:@"Apsalar"] objectForKey:@"Apsalar_Key"]];
    if (!tapjoyIsDisabled) [TapjoyConnect requestTapjoyConnect:[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_APP_ID"]  secretKey:[[nmaSettings objectForKey:@"TapJoy"] objectForKey:@"TapJoy_Secret_Key"]];
    if (!mobclixIsDisabled) [Mobclix startWithApplicationId:[[nmaSettings objectForKey:@"Mobclix"] objectForKey:@"Mobclix_APP_ID"]];
    [[NmaSDK sharedNmaSDK] nmaAllPush:@"0"];  // Reset Badge on icon to blank
    [self  nmaApplicationDidBecomeActive];
    nmaStartSessionCompleted = YES;
}


- (void)nmaApplicationDidBecomeActive{
    NmaLogDebug(@"applicationDidBecomeActive");
    [self nmaLaunchNagScreen];
    if (!chartboostIsDisabled) if (!chartboostNagDisabled) [[Chartboost sharedChartboost] showInterstitial:@"didBecomeActive"]; // you may insert your own label here, but change the caching too!
    
    BOOL revmobIsDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_Disabled"] boolValue];
    BOOL revmobFullscreenDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_fullscreen_disabled"] boolValue];
    BOOL revmobPopupDisabled = [[[nmaSettings objectForKey:@"RevMob"] objectForKey:@"RevMob_popup_disabled"] boolValue];
    
    NmaLogDebug(@"RevMob appid: %@", REVMOB_ID);
    NmaLogDebug(@"RevMob disabled: %@", revmobIsDisabled?@"YES":@"NO");
    NmaLogDebug(@"RevMob full-screen disabled: %@", revmobFullscreenDisabled?@"YES":@"NO");
    NmaLogDebug(@"RevMob popup disabled: %@", revmobPopupDisabled?@"YES":@"NO");
    
    if (!revmobIsDisabled && !revmobFullscreenDisabled) [RevMobAds showFullscreenAd];
    if (!revmobIsDisabled && !revmobPopupDisabled)[RevMobAds showPopup];
}

#pragma Mark NmaSDK Integration

// Nma Nagscreen Handler
- (void)nmaLaunchNagScreen{
    [viewController nmaLaunchNagScreen];
}

// Nma More Games Handler
- (void)nmaLaunchMoreGames{
    [viewController nmaLaunchMoreGames];
}

// Nma News Letter signup screen
- (void)nmaLaunchNews{
    [viewController nmaLaunchNews];
}