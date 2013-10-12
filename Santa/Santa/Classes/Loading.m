//
//  Loading.m
//  Kangaroo
//
//  Created by Роман Семенов on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Loading.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@implementation Loading
@synthesize isLoadedData;

+ (id) scene
{
    CCScene *scene = [CCScene node];
    Loading *layer = [Loading node];
    [scene addChild: layer];
    return scene;
}

- (id) init 
{
    if (self = [super init]) 
    {
        self.isLoadedData = NO;
        
        //перейти на Default.png когда загрузимся
		CGSize winSize = [CCDirector sharedDirector].winSize;
		CCSprite *defaultImage; 
        if (winSize.width == 568)
        {
            defaultImage = [CCSprite spriteWithFile:@"SplashScreen-5hd.png"];
        }
        else
        {
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad &&
                [[CCDirector sharedDirector] contentScaleFactor] == 1)
            {
                defaultImage = [CCSprite spriteWithFile:@"SplashScreen-ipad.png"];
            }
            else
            {
                defaultImage = [CCSprite spriteWithFile:@"SplashScreen.ong"];
            }
        }
        //defaultImage.rotation = -90;
		defaultImage.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:defaultImage];  
        
        [self schedule: @selector(tick:)];
        // Kick off an operation to load the scenes now that our textures are loaded
        NSInvocationOperation* sceneLoadOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadData:) object:nil] autorelease];
        NSOperationQueue *opQ = [[[NSOperationQueue alloc] init] autorelease]; 
        [opQ addOperation:sceneLoadOp];
    }
    return self;
}

- (void) onEnter
{
    NSLog(@"onEnter");
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) 
    {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Main_menu.mp3" loop:YES];
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:
         [[NSUserDefaults standardUserDefaults] floatForKey:@"volumeMusic"]];
    }
    
    [super onEnter];
}

-(void) loadData:(NSObject*) data {
    
    NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate loadingData];
    
    self.isLoadedData = YES;
    [autoreleasepool release];
}

-(void) tick: (ccTime) dt {
    
    if (isLoadedData) 
    {
        [self unscheduleAllSelectors];
       
        [self performSelector:@selector(showMainMenu) withObject:self afterDelay:4.0f];
    }
}
- (void) showMainMenu
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    //[delegate addViewController];
    [delegate launchMainMenu];
}
@end
