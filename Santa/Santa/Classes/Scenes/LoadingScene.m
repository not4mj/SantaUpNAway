//
//  LoadingScene.m
//  ElementTD
//
//  Created by Roman Semenov on 07.02.11.
//  Copyright 2011 TRASD. All rights reserved.
//

#import "LoadingScene.h"
#import "SimpleAudioEngine.h"
#import "MainMenuScene.h"
#import "GameStates.h"
#import "MKStoreManager.h"
#import "SimpleAudioEngine.h"

@implementation LoadingScene

- (id)init {
	
    if ((self = [super init])) {
        LoadingLayer *layer = [[LoadingLayer alloc] init];
        [self addChild:layer];
        [layer release];
    }
    return self;
    
}

@end

@interface LoadingLayer (Private) 
- (NSString *) pathAudioFile:(NSString *) fileName;
@end

@implementation LoadingLayer

@synthesize defaultImage;
@synthesize batchNode;
@synthesize mainBkgrnd;
@synthesize mainTitle;
@synthesize tapToCont;
@synthesize loadingLebel;
@synthesize isLoading;
@synthesize imagesLoaded;
@synthesize scenesLoaded;

- (id) init {
    
    if ((self = [super init])) {
		//инициализация переменых
		self.isLoading = YES;
        self.imagesLoaded = NO;
        self.scenesLoaded = NO;
		
		// включить touch 
        self.isTouchEnabled = YES;
		
		//перейти на Default.png когда загрузимся
		CGSize winSize = [CCDirector sharedDirector].winSize;
		self.defaultImage = [CCSprite spriteWithFile:@"Default.png"];
		defaultImage.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:defaultImage];  
		
        //загружаем sprites
		[[CCTextureCache sharedTextureCache] addImageAsync:@"MenuSprite.png" target:self selector:@selector(spritesLoaded:)];

		//переодический метод чтоб проверить статус
        [self schedule: @selector(tick:)];
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) onExit
{
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [super onExit];
}

-(void) spritesLoaded: (CCTexture2D*) tex {
	
    // Remove existing image
    [self removeChild:defaultImage cleanup:YES];
    self.defaultImage = nil;
    
    // Store sprite texture in cache and initialize sprite frames
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MenuSprite.plist"];
    
    // Add a sprite sheet based on the loaded texture and add it to the scene
    self.batchNode = [CCSpriteBatchNode batchNodeWithTexture:tex];
    [self addChild:batchNode];
    
    // Add main background to scene
    CGSize winSize = [CCDirector sharedDirector].winSize;
    self.mainBkgrnd = [CCSprite spriteWithSpriteFrameName:@"menu_main_960x640.jpg"];
    mainBkgrnd.position = ccp(winSize.width/2, winSize.height/2);
    [batchNode addChild:mainBkgrnd];
    
	self.mainTitle = [CCSprite spriteWithSpriteFrameName:@"titles.png"];
	self.mainTitle.position = ccp(winSize.width/2, winSize.height/2 + 50);
	 [batchNode addChild:mainTitle];
    
    ccColor3B c = {0, 0, 0};
    loadingLebel = [CCLabelTTF labelWithString:@"loading..." fontName:@"KristenITC" fontSize:24];
    loadingLebel.position = ccp(winSize.width/2 , 50);
    [loadingLebel setColor:c];
    [self addChild:loadingLebel];
    
    [loadingLebel runAction:[CCRepeatForever actionWithAction:
                         [CCSequence actions:
						  [CCFadeOut actionWithDuration:1.0f],
						  [CCFadeIn actionWithDuration:1.0f],
                          nil]]];
    
    self.imagesLoaded = YES;
	
    
    NSInvocationOperation* sceneLoadOp = [[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadScenes:) object:nil] autorelease];
    NSOperationQueue *opQ = [[[NSOperationQueue alloc] init] autorelease]; 
    [opQ addOperation:sceneLoadOp];
}

-(void) loadScenes:(NSObject*) data {
    NSAutoreleasePool *autoreleasepool = [[NSAutoreleasePool alloc] init];
    
    [[GameStates sharedState] init];
    // Preloading sounds
    [MKStoreManager sharedManager]; 
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[self pathAudioFile:@"menu_music.mp3"]];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:[self pathAudioFile:@"ingame_music.mp3"]];
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"air_baloon.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"gele_block.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"glass_block.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"ice_block.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"pet_fall.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"stone_block.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"teleport.wav"]];
    [[SimpleAudioEngine sharedEngine] preloadEffect:[self pathAudioFile:@"wood_cage.wav"]];
    
    self.scenesLoaded = YES;
    [autoreleasepool release];
}

- (NSString *) pathAudioFile:(NSString *) fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentDBFolderPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if(![fileManager fileExistsAtPath: documentDBFolderPath])
    {
        NSLog(@"no file:%@",fileName);
        NSString *resourceDBFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        [fileManager copyItemAtPath:resourceDBFolderPath toPath:documentDBFolderPath
                              error:&error];
        return 0;
    }
    else
    {
        return documentDBFolderPath;
    } 
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isLoading) {
		NSLog(@"выход в меню");
        [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
    }
}

-(void) tick: (ccTime) dt {
    if (imagesLoaded && scenesLoaded && isLoading) {
        
        self.isLoading = NO;
        
        [self removeChild:loadingLebel cleanup:YES];
        self.loadingLebel = nil;

        CGSize winSize = [CCDirector sharedDirector].winSize;

        ccColor3B c = {0, 0, 0};
        CCLabelTTF *tapToContLebel = [CCLabelTTF labelWithString:@"tap to continue" fontName:@"KristenITC" fontSize:24];
        tapToContLebel.position = ccp(winSize.width/2 , 50);
        [tapToContLebel setColor:c];
        [self addChild:tapToContLebel];
        
        [tapToContLebel runAction:[CCRepeatForever actionWithAction:
							   [CCSequence actions:
								[CCFadeOut actionWithDuration:1.0f],
								[CCFadeIn actionWithDuration:1.0f],
								nil]]];
        
    }
}





@end