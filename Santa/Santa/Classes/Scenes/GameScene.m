//
//  GameScene.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "Player.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "MapCoordinationHelper.h"
#import "GamePauseLayer.h"
#import "GoldBarsLayer.h"

#import "Crocodile.h"
#import "Reindeer.h"
#import "Enemies.h"
#import "AppDelegate.h"
#import "SneakEnemy.h"
#import "ElfLaugh.h"
#import "ThrowEnemy.h"
#import "CDXPropertyModifierAction.h"
#import "CCTMXTiledMap.h"

#define BeforeTime 10

@interface GameScene (Private)
- (void) addMap;
- (void) addWorldLayer;
- (void) addPlayer;
- (void) addObjects;
- (void) addEnemie:(EnemiesType)type inPosition:(CGPoint) position trajectory:(NSMutableArray*)trajectory property:(CGFloat)property;
- (void) addJoystick;
- (void) addJumpButton;
- (void) addScoreLabel;
- (void) addTimeLabel;
- (void) addPauseButton;
- (void) addGameOverLayerIsWin:(BOOL)isWin;
- (void) updateTimeLabel;
- (void) focusToMum;
- (void) showJoystick;
- (void) hideJoystick;
- (void) hideJumpButton;
- (void) showJumpButton;
- (void) playGame;
- (void) touchesEnded;
- (void) moveMapBack;
- (CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap;
- (CGPoint) ensureTilePosIsWithinBounds:(CGPoint)tilePos;
- (CGPoint)jumpPositionWithStep:(NSInteger)step;
- (NSMutableArray*) getTrajectoryObject:(NSMutableDictionary*)object;
- (void)collisionWithEnemys;
- (void)collisionWithprojectiles;
- (void) reorderEnemies;
- (void) moveByCrocodile:(Crocodile*)crocodile Point:(CGPoint)point;
- (id) initWithLevelNumber:(NSNumber*)levelNumber;
- (void)focusToPlayerWithSpeed:(CGFloat) speed;
- (CGPoint) positionFocusObjectName:(NSString*)name;
- (void) respawnPlayer;
- (void) skip;
- (NSInteger) distanceToWater:(CGPoint) tilePos;
- (void) playWaterEffectWithDistance:(NSInteger)distance;
- (void) playWaterEffect;
- (BOOL) restrictionRotation:(CCTMXTiledMap*)tileMap;
@end

@implementation GameScene

#pragma mark -
#pragma mark init dealloc metods

+ (id) sceneWithLevelNumber:(NSNumber*)levelNumber;
{
    CCScene *scene = [CCScene node];
    GameScene *layer = [[[GameScene alloc]initWithLevelNumber:levelNumber]autorelease] ;
    [scene addChild: layer];
    return scene;
}

- (id) initWithLevelNumber:(NSNumber*)levelNumber;
{
	if ((self=[super init])) 
	{
        mapBackPosition = CGPointZero;
        worldBackPosition = CGPointZero;
        river = -2;
        currentLevel = [levelNumber integerValue];
        countCollectedGoldBar = 0;
        countCollectedGoldStone = 0;
        isMoveScreen = NO;
        isPlay = NO;
        hayIsCollected = NO;
        projectiles = [[NSMutableArray alloc] init];
        enemies = [[NSMutableArray alloc] init];
        crocodiles = [[NSMutableArray alloc] init];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Pause.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"buttonsSpritesSheets.plist"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);

        [self addWorldLayer];
        [self addMap];
        
        [self addObjects];
        [self addPlayer];
        [self addSky];

		// to move in any of these directions means to add/subtract 1 to/from the current tile coordinate
		moveOffsets[MoveDirectionNone] = CGPointZero;
		moveOffsets[MoveDirectionUpperLeft] = CGPointMake(-1, 0);
		moveOffsets[MoveDirectionLowerLeft] = CGPointMake(0, 1);
		moveOffsets[MoveDirectionUpperRight] = CGPointMake(0, -1);
		moveOffsets[MoveDirectionLowerRight] = CGPointMake(1, 0);
        
		currentMoveDirection = MoveDirectionNone;

        self.isTouchEnabled = YES;        
    }
    return self;
}

- (void) onExit
{
    [[SimpleAudioEngine sharedEngine] stopEffect:river];
    [super onExit];
}
- (void) onEnter
{
    remainingTime = BeforeTime;
    [self addTimeLabel];

    CCSprite *skipSpriteNorm = [CCSprite spriteWithSpriteFrameName:@"skip_normal.png"];
    CCSprite *skipSpriteSel = [CCSprite spriteWithSpriteFrameName:@"skip_pressed.png"];
    CCMenuItemSprite *skipItem = [CCMenuItemSprite itemWithNormalSprite:skipSpriteNorm
                                                         selectedSprite:skipSpriteSel
                                                                 target:self
                                                               selector:@selector(skip)];

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    menuSkip = [CCMenu menuWithItems:skipItem, nil];
    menuSkip.position = ccp(screenSize.width * 415 / 480,screenSize.height * 290 /320);
    [self addChild:menuSkip z:2];
    
    [self schedule:@selector(timeBefore) interval:1.0];
    [self schedule:@selector(updateCrocodile:)];
    [self schedule:@selector(reorderEnemies)];
    
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* worldNode = [self getChildByTag:WorldLayer];
    NSAssert([worldNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)worldNode;
    
    CGPoint tilePos = [MapCoordinationHelper floatingTilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) tileMap:tileMap];
	[player updateVertexZ:tilePos tileMap:tileMap];
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    NSString *levelString =[NSString stringWithFormat:@"Level - %d",[[delegate currentLevel] intValue]];
    CCLabelBMFont *levelLabel = [CCLabelBMFont labelWithString:levelString fntFile:@"MuseoFont_42.fnt"];
    levelLabel.position = ccp(screenSize.width * 240 / 480, screenSize.height * 350 / 320);
    [self addChild:levelLabel];
    
    CCMoveTo *moveToCenter = [CCMoveTo actionWithDuration:0.8 position:ccp(screenSize.width /2, screenSize.height /2)];
    CCEaseBackOut *easqBack = [CCEaseBackOut actionWithAction:moveToCenter];
    
    CCDelayTime *interval = [CCDelayTime actionWithDuration:0.5];
    [levelLabel runAction:[CCSequence actions:interval,easqBack,interval,[CCFadeOut actionWithDuration:0.4], nil]];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Game_track.mp3" loop:YES];
    
    CGPoint cenerPos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) tileMap:tileMap];
    [self playWaterEffectWithDistance:[self distanceToWater:cenerPos]];
    
    [super onEnter];
}


- (void) dealloc
{
    [enemies removeAllObjects];
    [enemies release];
    
    [crocodiles removeAllObjects];
    [crocodiles release];
    
    [projectiles removeAllObjects];
    [projectiles release];
    
    [leftJoystick release];
    //[[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile: @"buttonsSpritesSheets.plist"];
    [super dealloc];
}



#pragma mark -
#pragma mark add object

- (void) addMap
{
    [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
    NSString *mapPath = [NSString stringWithFormat:@"mapLevel_1_%d.tmx",currentLevel];
    
    CCTMXTiledMap* tileMap = [CCTMXTiledMap tiledMapWithTMXFile:mapPath];
    
    CCTMXLayer* Objectslayer = [tileMap layerNamed:@"ObjectsOverPlayer"];
    
    for( CCSpriteBatchNode* child in [Objectslayer children] ) {		
        
        [child setBlendFunc:(ccBlendFunc){GL_ONE,GL_ZERO}];
    }

    //NSMutableDictionary *mapProperties = [tileMap properties];
   // NSInteger snowValue = [[mapProperties valueForKey:@"Snow"] intValue];
//    if (snowValue != 0)
//        [self addSnowWithTotalParticles:snowValue];

    [self addSnow];
    maxHeysInLevel = [MapCoordinationHelper heysInLevel:tileMap];
    
    [self addChild:tileMap z:-1 tag:TileMapNode];
    CCTMXLayer* layer = [tileMap layerNamed:@"Meta"];
    layer.visible = NO;

    CGPoint newPosition = [self positionFocusObjectName:@"SpawnPlayer"];
    newPosition = ccpSub(newPosition, tileMap.position);
    tileMap.position = ccpAdd(newPosition, tileMap.position);
    
    const int borderSize = 4;
    playableAreaMin = CGPointMake(borderSize, borderSize);
    playableAreaMax = CGPointMake(tileMap.mapSize.width - 1 - borderSize, tileMap.mapSize.height - 1 - borderSize);
}

- (void) addSnow
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCParticleSystemQuad *snowParticle = [CCParticleSystemQuad particleWithFile:@"snowMenu.plist"];
    snowParticle.positionType =kCCPositionTypeFree;
    
    snowParticle.position = ccp(screenSize.width / 2, screenSize.height * 1.1);
    [snowParticle setPosVar:ccp(screenSize.width, 0)];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        snowParticle.scale /= 2;
    }
    
    [self addChild:snowParticle];
}

- (void) addSnowWithTotalParticles:(NSUInteger)particles
{
    NSLog(@"particles=%d",particles);
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCParticleSystemQuad *snowParticle = [CCParticleSystemQuad particleWithFile:@"snow.plist"];
    snowParticle.position = ccp(screenSize.width / 2, screenSize.height * 1.1);
    [snowParticle setPosVar:ccp(screenSize.width, 0)];
    [snowParticle setTotalParticles:particles];
    [snowParticle setEmissionRate:particles/snowParticle.life];
    [snowParticle setStartSpinVar:360];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        snowParticle.scale /= 2;
    }
    if ([[CCDirector sharedDirector] contentScaleFactor] == 2) {
        snowParticle.scale *= 2;
    }
    
    [self addChild:snowParticle];
}

- (void) addSky
{
    CCSprite *sky;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad &&
        [[CCDirector sharedDirector] contentScaleFactor] == 1)
    {
        sky = [CCSprite spriteWithFile:@"sky-ipad.jpg"];
    }
    else
    {
        sky = [CCSprite spriteWithFile:@"sky.jpg"];
    }
    sky.position = screenCenter;
    [sky setVertexZ:-1001];
    [self addChild:sky z:-2];
}

- (void) addWorldLayer
{
    CCLayer *worldLayer = [CCLayer node];
    [self addChild:worldLayer z:0 tag:WorldLayer];
}

- (void) addPlayer
{
    CCNode* node = [self getChildByTag:WorldLayer];
    NSAssert([node isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)node;
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    player = [Player player];
    player.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    player.anchorPoint = CGPointMake(0.5f, 0.4f);
    [worldLayer addChild:player z:1]; 
}

- (NSMutableArray*) getTrajectoryObject:(NSMutableDictionary*)object
{
    NSMutableArray *trajectory = [NSMutableArray arrayWithCapacity:1];
    NSString *pointsString;
    NSArray *pointsArray;
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString: @", "];

        pointsString = [object valueForKey:@"polygonPoints"];
        if (pointsString != NULL)
        {
            pointsArray = [pointsString componentsSeparatedByCharactersInSet:characterSet];
        
            for (int i = 0; i < [pointsArray count]; i++)
            {
                NSString *stringPointX = [pointsArray objectAtIndex:i];
                NSString *stringPointY = [pointsArray objectAtIndex:i+1];
                
                NSString *stringPoint = [NSString stringWithFormat:@"{%@,%@}",stringPointX,stringPointY];
                
                //align to the center
                CGPoint point = CGPointFromString(stringPoint);
                
                if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
                {
                    point = ccpMult(point, 2);
                }
                
                point = ccp(roundf(point.x /78)* 78 , roundf(point.y /78)* 78);
                stringPoint = NSStringFromCGPoint(point);

                [trajectory addObject:stringPoint];
                i++;
            } 
        }
    return trajectory;
}

- (void) addObjects
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* worldNode = [self getChildByTag:WorldLayer];
    NSAssert([worldNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)worldNode;
    
    //CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSMutableDictionary * spawnPoint;

    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSMutableDictionary *spawnPlayer = [objects objectNamed:@"SpawnPlayer"];
    NSAssert(spawnPlayer.count > 0, @"SpawnPoint object missing");
    CGPoint centerPoint;
    CCDirector *director = [CCDirector sharedDirector];
    
    centerPoint.x = [[spawnPlayer valueForKey:@"x"] floatValue]  ;
    centerPoint.y = [[spawnPlayer valueForKey:@"y"] floatValue] ;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        centerPoint.x = centerPoint.x * 2;
        centerPoint.y = centerPoint.y * 2 - (tileMap.mapSize.height * tileMap.tileSize.height);
    }
    
    if ([director contentScaleFactor] == 2)
    {
        centerPoint.y = centerPoint.y - (tileMap.tileSize.height / 2) * tileMap.mapSize.height;
    }
    
    centerPoint.x = centerPoint.x / (tileMap.tileSize.height / [director contentScaleFactor]);
    centerPoint.y = centerPoint.y / (tileMap.tileSize.height / [director contentScaleFactor]);

    CGPoint newCenterPoint;
    newCenterPoint.x = (centerPoint.y + centerPoint.x ) * ((tileMap.tileSize.width/2) / [director contentScaleFactor]) - ((tileMap.tileSize.width/2) / [director contentScaleFactor]);
    newCenterPoint.y = (centerPoint.y - centerPoint.x) * ((tileMap.tileSize.height/2) / [director contentScaleFactor]) + ((tileMap.tileSize.height/2) / [director contentScaleFactor]);
    
    for (spawnPoint in [objects objects])
    {
        if ([[spawnPoint valueForKey:@"Enemy"] intValue] != 0)
        {
            CGFloat property = 0;
            if ([[spawnPoint valueForKey:@"Property"] floatValue] != 0)
            {
                property = [[spawnPoint valueForKey:@"Property"] floatValue];
            }
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];

            [self addEnemie:[[spawnPoint valueForKey:@"Enemy"] intValue] 
                 inPosition:ccpSub(spawnPosition, newCenterPoint) 
                 trajectory:[self getTrajectoryObject:spawnPoint]
             property:property];
            
        }
        else if ([[spawnPoint valueForKey:@"Mum"] intValue] > 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            reindeer = [Reindeer reindeerWithDirection:[[spawnPoint valueForKey:@"Mum"] intValue]];
            reindeer.visible = NO;
            reindeer.position = ccpSub(spawnPosition, newCenterPoint);
            
            CGPoint pos = [MapCoordinationHelper floatingTilePosFromLocation:reindeer.position tileMap:tileMap];

            CGSize layerSize = [tileMap layerNamed:@"Ground"].layerSize;
            NSInteger ret = 0;
            NSUInteger maxVal = 0;
            maxVal = layerSize.width + layerSize.height;
            ret = -(maxVal - (pos.x + pos.y));
            reindeer.vertexZ = ret - 1;
   
            [worldLayer addChild:reindeer z:0];
        }
        else if ([[spawnPoint valueForKey:@"Home"] intValue] > 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Smoke.plist"];
            
            CCSprite *smoke = [CCSprite spriteWithSpriteFrameName:@"smoke.swf/0000"];
//            [smoke setBlendFunc:(ccBlendFunc) {GL_ONE | GL_ONE_MINUS_SRC_ALPHA}];
            
            if ([[spawnPoint valueForKey:@"Home"] intValue] == 1)
            {//x больше левее y меньше выше
                smoke.anchorPoint = ccp(0.62, -0.64);
            }
            else if ([[spawnPoint valueForKey:@"Home"] intValue] == 2)
            {
                smoke.anchorPoint = ccp(0.52, -0.65);
            }
            else if ([[spawnPoint valueForKey:@"Home"] intValue] == 3)
            {
                smoke.anchorPoint = ccp(0.55, -0.55);
            }
            else if ([[spawnPoint valueForKey:@"Home"] intValue] == 4)
            {
                smoke.anchorPoint = ccp(0.51, -0.60);
            }
            smoke.position = ccpSub(spawnPosition, newCenterPoint);
//            [worldLayer addChild:smoke z:6];
            
            NSMutableArray *animationSmokeFrames = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
            for (NSUInteger i = 1; i < 30; i++)
            {
                NSString* fileJump = [NSString stringWithFormat:@"smoke.swf/%04d",i];
           
                CCSpriteFrame* frameIdle = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileJump];
                [animationSmokeFrames addObject:frameIdle];
            }
            
            CCCallBlock *playAnimation = [CCCallBlock actionWithBlock:^{
                CGFloat moveTime = 0.125;
                CCAnimate *animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:animationSmokeFrames delay: moveTime]];;
                CCRepeatForever *repeat = [CCRepeatForever actionWithAction:animate];
                [smoke runAction:repeat];
            }];
            
            CGFloat spawnTime = arc4random() % 4;
            [smoke runAction:[CCSequence actionOne:[CCDelayTime actionWithDuration:spawnTime] two:playAnimation]];
        }
        else if ([[spawnPoint valueForKey:@"IceHole"] intValue] > 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            CCSprite *iceHole = [CCSprite spriteWithFile:@"ice_hole.png"];
            iceHole.position = ccpSub(spawnPosition, newCenterPoint);
            iceHole.anchorPoint = ccp(0.5, 0.0);
            [worldLayer addChild:iceHole];
            iceHole.vertexZ = -790;
        }
        else if ([[spawnPoint valueForKey:@"Sleigh"] intValue] > 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            NSString *sleighPath = [NSString stringWithFormat:@"with presents sleigh%d.png",currentLevel];
            CCSprite *sleigh = [CCSprite spriteWithFile:sleighPath];
            sleigh.position = ccpSub(spawnPosition, newCenterPoint);
            sleigh.anchorPoint = ccp(0.5, 0.0);
            [worldLayer addChild:sleigh];
            sleigh.vertexZ = -790;
        }
        else if ([[spawnPoint valueForKey:@"ElfLaugh"] intValue] > 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            elfLaugh = [ElfLaugh elfLaugh];
    
            elfLaugh.position = ccpSub(spawnPosition, newCenterPoint);
            elfLaugh.anchorPoint = ccp(0.5, 0.0);
            [worldLayer addChild:elfLaugh z:2];
            //elfLaugh.vertexZ = -790;
        }

        else if ([[spawnPoint valueForKey:@"Crocodile"] intValue] != 0)
        {
            CGPoint spawnPosition;
            spawnPosition.x = [[spawnPoint valueForKey:@"x"] floatValue];
            spawnPosition.y = [[spawnPoint valueForKey:@"y"] floatValue];
            spawnPosition = [MapCoordinationHelper spawnPosition:spawnPosition :tileMap];
            
            BOOL hasGold = NO;
            if ([[spawnPoint valueForKey:@"Gold"] intValue] == 1)
            {
                hasGold = YES;
            }
            
            Crocodile *crocodile = [Crocodile crocodile];
            crocodile.trajectory = [[NSMutableArray alloc] initWithArray:[self getTrajectoryObject:spawnPoint]];
            crocodile.position = ccpSub(spawnPosition, newCenterPoint);
            crocodile.startPosition = crocodile.position;
            [worldLayer addChild:crocodile];
            if ([[spawnPoint valueForKey:@"Speed"] intValue] != 0) 
            {
                crocodile.speed = [[spawnPoint valueForKey:@"Speed"] intValue];
            }
            [crocodiles addObject:crocodile];
        }
    }
}

- (void) addEnemie:(EnemiesType)type inPosition:(CGPoint) position trajectory:(NSMutableArray*)trajectory property:(CGFloat)property
{
    CCNode* node = [self getChildByTag:WorldLayer];
    NSAssert([node isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)node;
    

    if (type == EnemiesTypeElfSneak_1 ||
        type == EnemiesTypeElfSneak_2 ||
        type == EnemiesTypeElfSneak_3 ||
        type == EnemiesTypeElfSneak_4)
    {
        SneakEnemy *enemy = [SneakEnemy sneakEnemyWithType:type];
        enemy.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
        enemy.position = position;
        [worldLayer addChild:enemy];
        [enemy goToTrajectory];
        [enemies addObject:enemy];
    }
    
    else if (type == EnemiesTypeElfThrow_1 ||
             type == EnemiesTypeElfThrow_2)
    {
        ThrowEnemy *enemy = [ThrowEnemy throwEnemyWithType:type];
        enemy.delegate = self;
        enemy.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
        enemy.position = position;
        enemy.breakTime = property;
        [worldLayer addChild:enemy];
        [enemy playAnimations];
        [enemies addObject:enemy];
    }
//    else if (type == EnemiesTypeElfSneak_3)
//    {
//        ElfSneak_3 *elf = [ElfSneak_3 elf];
//        elf.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        elf.position = position;
//        [worldLayer addChild:elf];
//        [elf goToTrajectory];
//        [enemies addObject:elf];
//    }
//    else if (type == EnemiesTypeFeralCat)
//    {
//        FeralCat *cat = [FeralCat feralCat];
//        cat.anchorPoint = ccp(0.5, 0.37);
//        cat.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        cat.position = position;
//        [worldLayer addChild:cat];
//        [cat goToTrajectory];
//        [enemies addObject:cat];
//    }
//    else if (type == EnemiesTypeMarsupialLion) 
//    {
//        MarsupialLion *lion = [MarsupialLion marsupialLion];
//        lion.anchorPoint = ccp(0.5, 0.4);
//        lion.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        lion.position = position;
//        [worldLayer addChild:lion];
//        [lion goToTrajectory];
//        [enemies addObject:lion];
//    }
//    else if (type == EnemiesTypeFeralEagle) 
//    {
//        Eagle *eagle = [Eagle eagle];
//        eagle.anchorPoint = ccp(0.66, 0.19);
//        eagle.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        eagle.position = position;
//        [worldLayer addChild:eagle z:3];
//        [eagle goToTrajectory];
//        [enemies addObject:eagle];
//    }
//    else if (type == EnemiesTypeThylacine) 
//    {
//        Thylacine *thylacine = [Thylacine thylacine];
//        thylacine.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        thylacine.position = position;
//        [worldLayer addChild:thylacine];
//        [thylacine goToTrajectory];
//        [enemies addObject:thylacine];
//    }
//    else if (type == EnemiesTypeBadKangaroo) 
//    {
//        BadKangaroo *badKangaroo = [BadKangaroo badKangaroo];
//        badKangaroo.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        badKangaroo.position = position;
//        badKangaroo.startPosition = position;
//        [worldLayer addChild:badKangaroo];
//        [badKangaroo goToTrajectory];
//        [enemies addObject:badKangaroo];
//    }
//    else if (type == EnemiesTypeDingo) 
//    {
//        Dingo *dingo = [Dingo dingo];
//        dingo.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        dingo.position = position;
//        [worldLayer addChild:dingo];
//        [dingo goToTrajectory];
//        [enemies addObject:dingo];
//    }
//    else if (type == EnemiesTypePython) 
//    {
//        Python *python = [Python python];
//        python.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        python.position = position;
//        [worldLayer addChild:python];
//        [python goToTrajectory];
//        [enemies addObject:python];
//    }
//    else if (type == EnemiesTypeWanambi) 
//    {
//        Wanambi *wanambi = [Wanambi wanambi];
//        wanambi.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        wanambi.position = position;
//        [worldLayer addChild:wanambi];
//        [wanambi goToTrajectory];
//        [enemies addObject:wanambi];
//    }
//    else if (type == EnemiesTypeMonkey) 
//    {
//        Monkey *monkey = [Monkey monkey];
//        monkey.delegate = self;
//        monkey.trajectory = [[NSMutableArray alloc] initWithArray:trajectory];
//        monkey.position = position;
//        monkey.breakTime = property;
//        [worldLayer addChild:monkey];
//        [monkey playAnimations];
//        [enemies addObject:monkey]; 
//    }
}

- (void) addJumpButton
{
    CCSprite *jumpButton = [CCSprite spriteWithSpriteFrameName:@"jumpNormal.png"];
    CCSprite *jumpSelButton = [CCSprite spriteWithSpriteFrameName:@"jumpSelected.png"];
    CCSprite *jumpDisButton = [CCSprite spriteWithSpriteFrameName:@"jumpDisabled.png"];
    jumpButtonItem = [CCMenuItemSprite itemWithNormalSprite:jumpButton
                                             selectedSprite:jumpSelButton
                                             disabledSprite:jumpDisButton 
                                                     target:self
                                                   selector:@selector(onJump)];
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCMenu *jumpButtonMenu = [CCMenu menuWithItems: jumpButtonItem, nil];
    jumpButtonMenu.position = ccp(screenSize.width * 550 / 480,screenSize.height * 70 / 320);
    [self addChild:jumpButtonMenu];
    
    CCEaseBackOut *easeMove = [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:0.4 position:ccp(screenSize.width * 410 / 480,screenSize.height * 70 / 320)]];
    [jumpButtonMenu runAction:easeMove];
}

- (void) addJoystick
{
    if (leftJoy == nil) 
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        leftJoy = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
        leftJoy.position = ccp(screenSize.width * 64 / 480,screenSize.height * 64 / 320);
        leftJoy.backgroundSprite = [CCSprite spriteWithSpriteFrameName:@"joy_stick.png"];
        leftJoy.backgroundSprite.opacity = 0;//80
        leftJoy.thumbSprite = [CCSprite spriteWithSpriteFrameName:@"JoystickFront.png"];
        leftJoy.thumbSprite.opacity = 0;//30
        leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,screenSize.width * 128 / 480,screenSize.height * 128 / 320)];
        
        leftJoystick = [leftJoy.joystick retain];
        [leftJoystick setGameDelegate:self];
        [leftJoystick setIsDPad:YES];
        [leftJoystick setDeadRadius:0];
        
        leftJoy.joystick.joystickRadius = screenSize.width * 20 / 480;
        leftJoy.joystick.thumbRadius = screenSize.width * 20 / 480;
        
        leftJoy.position = ccp(screenSize.width * 80 / 480,screenSize.height * 80 / 320);
        [self addChild:leftJoy];
    }
}

- (void) addScoreLabel
{
    goldBarsLayer = [[[GoldBarsLayer alloc] initWithMaxHays:maxHeysInLevel] autorelease];
    [self addChild:goldBarsLayer];
}

- (void) addTimeLabel
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    timeLabel = [CCLabelBMFont labelWithString:@"00:00" fntFile:@"MuseoFont_28.fnt"];
    timeLabel.position = ccp(screenSize.width / 2 ,screenSize.height * 350 / 320);
    [self addChild:timeLabel z:2];
    
    CCEaseBackOut *easeMove = [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:0.5 position:ccp(screenSize.width / 2,screenSize.height * 300 / 320)]];
    [timeLabel runAction:easeMove];
    [self updateTimeLabel];
}

- (void) addPauseButton
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCMenuItemSprite *pauseOnItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause_normal.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"pause_pressed.png"]];

    CCMenuItemSprite *pauseOffItem = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"play_normal.png"]
                                                            selectedSprite:[CCSprite spriteWithSpriteFrameName:@"play_pressed.png"]];

    pauseToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(pauseOffOn:) items:pauseOnItem,pauseOffItem, nil];
    menuResumButton = [CCMenu menuWithItems:pauseToggle, nil];
    menuResumButton.position = ccp(screenSize.width * 520 / 480,screenSize.height * 280 / 320);
    [self addChild:menuResumButton z:5];
    CCEaseBackOut *easeMove = [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:0.4 position:ccp(screenSize.width * 440 / 480,screenSize.height * 280 / 320)]];
    [menuResumButton runAction:easeMove];
}

- (void) pauseOffOn: (id) sender
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate playEffectClick];
    
    pauseToggle.isEnabled = NO;
    
    CCCallBlock *finichMove = [CCCallBlock actionWithBlock:^{
        pauseToggle.isEnabled = YES;
    }];
    
    if ([sender selectedIndex] == 1) 
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [jumpButtonItem runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.3 position:ccp(screenSize.width * 140 / 480, 0)], finichMove, nil]];
        [leftJoy setVisible:NO];
        
        pauseLayer = [[[GamePauseLayer alloc] init] autorelease];
        [self addChild:pauseLayer z:1];
        self.isTouchEnabled = NO;
    }
    else
    {
        self.isTouchEnabled = YES;
        [pauseLayer removeLayer];
        [leftJoy setVisible:YES];
        [jumpButtonItem runAction:[CCSequence actions: [CCEaseBackOut actionWithAction:[CCMoveTo actionWithDuration:0.3 position:ccp(0, 0)]], finichMove, nil]];
    }
}


- (void) addGameOverLayerIsWin:(BOOL)isWin;
{
    [[SimpleAudioEngine sharedEngine] stopEffect:river];
    [self unscheduleAllSelectors];
    [self setIsTouchEnabled:NO];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_YouWin.caf"];
    
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if ([delegate.currentLevel intValue] == 8)
    {
        [delegate launchGameOver];
    }
    else
    {
        [delegate openNextLevel];
        [delegate launchMorePresents:remainingTime];
    } 
}

#pragma mark -
#pragma mark Sneak Joystick delegate metods

- (void) updateJoystikDirection:(EMoveDirection) direction
{
    currentMoveDirection = direction;
    if (!player.isMovePlay)
        [player rotationPlayerInDirection:direction];
}

- (void) stopUpdate
{
    currentMoveDirection = MoveDirectionNone;
}

#pragma mark -
#pragma mark Monkey delegate metods

- (void) playStoneEffect:(CGPoint) position
{
    NSLog(@"playStoneEffect 1 ");
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    NSLog(@"position  x=%f y=%f ",position.x,position.y);
    NSLog(@"player.position  x=%f y=%f ",player.position.x,player.position.y);
    CGFloat distanceToPlayer = ccpDistance(position, player.position);
    NSLog(@"distanceToPlayer = %f",distanceToPlayer);
    
    CGFloat offset = screenSize.width * 0.04;
    if (distanceToPlayer <= screenSize.width * 400 / 480)
    {
        CGFloat pan;
        if (player.position.x - offset > position.x) {
            pan = -1;
        }
        else if (player.position.x + offset < position.x) {
            pan = 1;
        }
        else {
            pan = 0;
        }
        NSLog(@"pan=%f",pan);
        CGFloat volume = 1 - (distanceToPlayer / screenSize.width * 400 / 480);
        [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_ElfThrowingSnowball.caf" pitch:1.0 pan:pan gain:volume];
        
        NSLog(@"playStoneEffect 2 ");
    }
}

- (void) addProjectile:(CCSprite*)projectile
{
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    [worldLayer addChild:projectile z:2];
    [projectiles addObject:projectile];
}

- (void) deleteProjectile:(CCSprite*)projectile
{
    [projectiles removeObject:projectile];
}
#pragma mark -
#pragma mark tick metod

- (void) updateTimeLabel
{
    int minutes = remainingTime / 60;
    int seconds = remainingTime % 60;
    NSString *time;
    if (remainingTime < 0)
    {
        seconds = abs(seconds);
        time = [NSString stringWithFormat:@"-%02d:%02d",minutes,seconds];
    }
    else
    {
        time = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    timeLabel.string = time;
}

- (void) timeBefore
{
    [self updateTimeLabel];
    remainingTime--;
    if (remainingTime < 0) 
    {
        [self skip];
    }
}


- (void) tickTime
{
    remainingTime++;
    [self updateTimeLabel];
//    if (remainingTime == 0) 
//    {
//       [self addGameOverLayerIsWin:NO]; 
//    }
}

- (void) updateCrocodile:(ccTime)delta
{
    for (Crocodile *crocodile in crocodiles)
    {
        CGPoint startPoint = CGPointFromString([crocodile.trajectory objectAtIndex:0]);
        startPoint = [MapCoordinationHelper mapConvertToWorldCoord:startPoint];
        CGPoint finishPoint = CGPointFromString([crocodile.trajectory objectAtIndex:1]);
        finishPoint = [MapCoordinationHelper mapConvertToWorldCoord:finishPoint];
        //need fixed
        if (finishPoint.x < 0)
        {
            if (crocodile.position.x < ccpAdd(crocodile.startPosition, finishPoint).x) 
            {
                [crocodile rotationUpperLeft];
                crocodile.goToFinish = NO;
            }
            
            if (crocodile.position.x > ccpAdd(crocodile.startPosition, startPoint).x ) 
            {
                [crocodile rotationLowerRight];
                crocodile.goToFinish = YES;
            }
        }
        else
        {
            if (crocodile.position.x > ccpAdd(crocodile.startPosition, finishPoint).x) 
            {
                [crocodile rotationLowerRight];
                crocodile.goToFinish = NO;
            }
            
            if (crocodile.position.x < ccpAdd(crocodile.startPosition, startPoint).x ) 
            {
                [crocodile rotationUpperLeft];
                crocodile.goToFinish = YES;
            }
        }
        
        CGPoint newPosition = ccpSub(finishPoint, startPoint);
        newPosition = ccpMult(newPosition, 0.0001 * crocodile.speed);
        if (crocodile.goToFinish)
        {
            [self moveByCrocodile:crocodile Point:newPosition];
        }
        else
        {
            newPosition = ccpMult(newPosition, -1);
            [self moveByCrocodile:crocodile Point:newPosition];
        }
    }
}

- (void) moveByCrocodile:(Crocodile*)crocodile Point:(CGPoint)point
{
    if (crocodile.withPlayer)
    {
        CCNode* node = [self getChildByTag:TileMapNode];
        NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
        CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
        
        CCNode* nodeLayer = [self getChildByTag:WorldLayer];
        NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
        CCLayer* worldLayer = (CCLayer*)nodeLayer;
        
        tileMap.position = ccpSub(tileMap.position, point);
        worldLayer.position = ccpSub(worldLayer.position, point);
        player.position = ccpAdd(player.position, point);
        crocodile.position = ccpAdd(crocodile.position, point);
    }
    else
    {
        crocodile.position = ccpAdd(crocodile.position, point);
    }
}

- (void) update:(ccTime)delta
{
    
	CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
	// if the tilemap is currently being moved, wait until it's done moving
	//if ([tileMap numberOfRunningActions] == 0)
	//{
        // player is always standing on the tile which is centered on the screen
        CGPoint tilePos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) tileMap:tileMap];
    
		if (currentMoveDirection != MoveDirectionNone)
		{
			// get the tile coordinate offset for the direction we're moving to
			NSAssert(currentMoveDirection < MAX_MoveDirections, @"invalid move direction!");
			CGPoint offset = moveOffsets[currentMoveDirection];
			
			// offset the tile position and then make sure it's within bounds of the playable area
			CGPoint nextTilePos = CGPointMake(tilePos.x + offset.x, tilePos.y + offset.y);
			nextTilePos = [self ensureTilePosIsWithinBounds:nextTilePos];
            tilePos = [self ensureTilePosIsWithinBounds:tilePos];
			

            
            if ((player.playerDirection != currentMoveDirection || !player.isMovePlay) && !player.isStunned) 
            {
                
                if (![MapCoordinationHelper isTilePosBlocked:nextTilePos tileMap:tileMap] && 
                    ![MapCoordinationHelper isTilePosWater:nextTilePos tileMap:tileMap] && 
                    ![MapCoordinationHelper isTilePosWater:tilePos tileMap:tileMap])
                {

                        if (!isMoveScreen && !player.isJump)
                        {
                            if ([self restrictionRotation:tileMap])
                            {
                                [player rotationPlayerInDirection:currentMoveDirection];
     
                                
                                [tileMap stopAllActions];
                                [worldLayer stopAllActions];
                                
                                CGFloat randPith = (arc4random() % (30));
                                randPith = 1.15 - (randPith/ 100);
                                
                                [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_Footsteps.caf" pitch:1 pan:0 gain:randPith - 0.5];
                                
                                // move tilemap so that touched tiles is at center of screen
                                [MapCoordinationHelper centerTileMapOnTileCoord:nextTilePos tileMap:tileMap worldLayer:worldLayer player:player];
                                [self playWaterEffectWithDistance:[self distanceToWater:nextTilePos]];
                                [player animateJumpPlayerWithDirection:currentMoveDirection];
                                
                                if ([MapCoordinationHelper isTilePosFinished:nextTilePos tileMap:tileMap] && !player.withBucket)
                                {
                                    if (elfLaugh.opacity == 0)
                                    {
                                        [elfLaugh show];
                                    }
                                }
                                
                            }
                        }
                    
                }
            }
		//}
	}


    if ([MapCoordinationHelper isTilePosFinished:tilePos tileMap:tileMap] && !player.isMovePlay)
    {

        if(player.withBucket)
        {
            player.withBucket = NO;
            [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_PickingHay.caf"];
            [goldBarsLayer collectedNumberBar:maxHeysInLevel - countCollectedGoldStone];
        }
        
        if (hayIsCollected)
        {
            NSInteger isPlayAction = 100;
            if (reindeer.tag != isPlayAction)
            {
                CCCallBlock *callWinLayer = [CCCallBlock actionWithBlock:^{
                    [self addGameOverLayerIsWin:YES];
                    
                }];
                
                //[reindeer runAction:[CCSequence actions:[reindeer animateJump],callWinLayer, nil]];
                [reindeer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0],callWinLayer, nil]];
                reindeer.tag = isPlayAction;
                
                [self unschedule:@selector(tickTime)];
                
                [self performSelector:@selector(playerLaugh) withObject:self afterDelay:0.32];
                //player.isStunned = YES;
                
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_YouWin.caf"];
                pauseToggle.isEnabled = NO;
                
                CGSize screenSize = [[CCDirector sharedDirector] winSize];
                [menuResumButton runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(screenSize.width * 440 / 480,screenSize.height * 350 / 320)]];
                [jumpButtonItem runAction:[CCMoveTo actionWithDuration:0.5 position:ccp(0, - screenSize.height * 140 / 320)]];
                [leftJoy runAction:[CCMoveBy actionWithDuration:1.0 position:ccp(0, - screenSize.height * 420 / 320)]];
            }
        }
    }
    else 
    {
        if ([MapCoordinationHelper isTilePosCollectableBarGold:tilePos tileMap:tileMap]) 
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"Zvuk_zolotogo_slitka.caf"];

            countCollectedGoldBar++;
            [timeLabel animateValueFrom:remainingTime to:remainingTime - 10 interval:1];

            remainingTime -= 10;
            
            CCScaleBy *scale = [CCScaleBy actionWithDuration:0.5 scale:1.2];
            CCEaseSineIn *ease = [CCEaseSineIn actionWithAction:scale];
            CCSequence *sequence = [CCSequence actions:ease, [ease reverse], nil];
            [timeLabel runAction:sequence];
            
            CCParticleSystemQuad *particle = [CCParticleSystemQuad particleWithFile:@"timeParticle.plist"];
            particle.position = timeLabel.position;
            [particle setPosVar:ccp(timeLabel.boundingBox.size.width, timeLabel.boundingBox.size.height)];
            particle.scale /= 2;
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                particle.scale /= 2;
            }
            if ([[CCDirector sharedDirector] contentScaleFactor] == 2) {
                particle.scale *= 2;
            }
            
            
            [self addChild:particle];
            
        }
        else if (!player.withBucket)
        {
            if ([MapCoordinationHelper isTilePosCollectableStoneGold:tilePos tileMap:tileMap])
            {
                [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_PickingHay.caf"];
                
                countCollectedGoldStone++;
                player.withBucket = YES;
                if (countCollectedGoldStone == maxHeysInLevel)
                {
                    hayIsCollected = YES;
                    reindeer.visible = YES;
                }
            }

        }  
    }
    
    CGPoint tilePosPlayer = [MapCoordinationHelper floatingTilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) tileMap:tileMap];
    if (player.isJump)
    {
        tilePosPlayer = ccpAdd(tilePosPlayer, ccp(1, 1));
    }
    [player updateVertexZ:tilePosPlayer tileMap:tileMap];
}

- (void) playerLaugh
{
    if (!player.isStunned) {
        [player animateLaughPlayerWithDirection:player.playerDirection];
        player.isStunned = YES;
    }
}

- (BOOL) restrictionRotation:(CCTMXTiledMap*)tileMap
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    BOOL solve = NO;
    CGFloat posX = (tileMap.position.x - screenSize.width/2) / 50 ;
  
    posX = posX - floorf(posX);
    
    CGFloat posY = (tileMap.position.y - screenSize.height/2) / 39 ;
    posY = posY - floorf(posY); 
    
    if ((posX > 0.8 || posX < 0.2) &&  (posY > 0.8 || posY < 0.2)) 
    {
        solve = YES;
    }
    return solve;
}

- (void)collisionWithprojectiles
{
    if (player.isStunned || player.isJump) {
        return;
    }
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;

    for (CCSprite *projectile in projectiles)
    {
        CGPoint projectilerPosition = ccpAdd(projectile.position, worldLayer.position) ;
        projectilerPosition = [MapCoordinationHelper floatingTilePosFromLocation:projectilerPosition tileMap:tileMap];
        projectilerPosition = ccpSub(projectilerPosition, ccp(0.5, 0.5));
        projectilerPosition = ccp(roundf(projectilerPosition.x), roundf(projectilerPosition.y)) ;
        
        CGPoint playerPosition = [MapCoordinationHelper floatingTilePosFromLocation:screenCenter tileMap:tileMap];
        playerPosition = ccpSub(playerPosition, ccp(0.5, 0.5));
        
        CGFloat offset = 0.7;

        if ((projectilerPosition.x > playerPosition.x - offset && projectilerPosition.x < playerPosition.x + offset) &&
            (projectilerPosition.y > playerPosition.y - offset && projectilerPosition.y < playerPosition.y + offset) && !player.isStunned)
        //if (projectilerPosition.x == playerPosition.x && projectilerPosition.y == playerPosition.y)//if player stand
        {

            [projectiles removeObject:projectile];
            [projectile removeFromParentAndCleanup:YES];
            [player stunPlayer];
            return;
        }
    }
}

- (void) reorderEnemies
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
    for (Enemies *enemie in enemies)
    {
        CGPoint enemierPosition = ccpAdd(enemie.position, worldLayer.position) ;
        enemierPosition = [MapCoordinationHelper floatingTilePosFromLocation:enemierPosition tileMap:tileMap];

        // continuously fix the player's Z position
        [enemie updateVertexZ:enemierPosition tileMap:tileMap];

        if(enemie.vertexZ > player.vertexZ)
        {
            [worldLayer reorderChild:enemie z:2];
        }
        else
        {
                [worldLayer reorderChild:enemie z:0]; 
        }
    }
}

- (void)collisionWithEnemys
{
    if (player.isJump)
    {
        return;
    }
    [self collisionWithprojectiles];
    

    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
    for (Enemies *enemie in enemies)
    {
        CGPoint enemierPosition = ccpAdd(enemie.position, worldLayer.position) ;
        enemierPosition = [MapCoordinationHelper floatingTilePosFromLocation:enemierPosition tileMap:tileMap];
        enemierPosition = ccpSub(enemierPosition, ccp(0.5, 0.5));

        CGPoint playerPosition = [MapCoordinationHelper 
                                  floatingTilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) 
                                  tileMap:tileMap];
        
        playerPosition = ccpSub(playerPosition, ccp(0.5, 0.5));

        //If a player stands on the site
//        if ( (playerPosition.x - floorf(playerPosition.x) == 0) && (playerPosition.y - floorf(playerPosition.y) == 0)) 
//        {
            CGFloat offset = 0.7;
            //if the enemy from a distance of one cell
            if ((enemierPosition.x > playerPosition.x - offset && enemierPosition.x < playerPosition.x + offset) && 
                (enemierPosition.y > playerPosition.y - offset && enemierPosition.y < playerPosition.y + offset) && !player.isStunned)
            {
                
//                CGFloat angle = CC_RADIANS_TO_DEGREES(atan2f(player.position.x - enemie.position.x , player.position.y - enemie.position.y));
//                player.playerDirection = [MapCoordinationHelper directionWithAngleStunPlayer:angle];
//
//                player.isMovePlay = NO;
//                CGPoint newPos = [self jumpPositionWithStep:2];
                CGPoint newPos = [self pushSanta];
                
                if (newPos.x != 0 && newPos.y != 0 && !isMoveScreen) 
                {
                    [MapCoordinationHelper centerTileMapOnTileCoord:newPos tileMap:tileMap worldLayer:worldLayer player:player];
                    [self playWaterEffectWithDistance:[self distanceToWater:newPos]];
                }
                
                [player stunPlayer]; 
            }
        //}
    }
}
#pragma mark -
#pragma mark Other metods

- (void) skip
{
    AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    [delegate playEffectClick];
    
//    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Game_track.mp3" loop:NO];
//    
    [menuSkip removeFromParentAndCleanup:YES];
    [self unschedule:@selector(timeBefore)];
    [self playGame]; 
    [self stopActionByTag:1];
    if (mapBackPosition.x != 0 || mapBackPosition.y != 0)
    {
        [self moveMapBack];
    }
}

- (void) respawnPlayer
{
    if (!player.isMovePlay) 
    {
        
        CCNode* node = [self getChildByTag:TileMapNode];
        NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
        CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
        
        CCNode* nodeLayer = [self getChildByTag:WorldLayer];
        NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
        CCLayer* worldLayer = (CCLayer*)nodeLayer;
        
        CGPoint offsetToPositionPlayer = ccpSub(player.positionMapRespawn, tileMap.position);
        CGFloat timeAction = ccpDistance(offsetToPositionPlayer, ccp(0, 0)) / 500;
        

        for (Crocodile *allCrocodile in crocodiles)
        {
            allCrocodile.withPlayer = NO;
        }
        
        player.isStunned = YES;
        player.opacity = 0;
        
        CCCallBlock *finishSpawn = [CCCallBlock actionWithBlock:^{
            player.position = ccpAdd(ccpMult(offsetToPositionPlayer, -1) , player.position);
            CCCallBlock *finishFade = [CCCallBlock actionWithBlock:^{
                player.isStunned = NO;

            }]; 
            [player runAction:[CCSequence actions:[CCFadeIn actionWithDuration:0.5],finishFade, nil ]];
            
            [self schedule:@selector(collisionWithEnemys)];
        }];

        
        [self unschedule:@selector(collisionWithEnemys)];
        
        [tileMap stopAllActions];
        [worldLayer stopAllActions];
        [player stopAllActions];
        
        CCMoveTo *moveForMap = [CCMoveTo actionWithDuration:timeAction position:ccpAdd(offsetToPositionPlayer, tileMap.position)];
        CCMoveTo *moveForWorld = [CCMoveTo actionWithDuration:timeAction position:ccpAdd(offsetToPositionPlayer, worldLayer.position)];
        
        [tileMap runAction:[CCEaseInOut actionWithAction:moveForMap rate:2.0]];
        [worldLayer runAction:[CCSequence actions:[CCEaseInOut actionWithAction:moveForWorld rate:2.0],finishSpawn, nil]]; 
    }
}

- (void) focusToMum
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;

    CGPoint newPosition = [self positionFocusObjectName:@"SpawnMum"];
    newPosition = ccpSub(newPosition, tileMap.position);
    tileMap.position = ccpAdd(newPosition, tileMap.position);
    worldLayer.position = ccpAdd(newPosition, worldLayer.position);
    
    CCDelayTime *timeInterval = [CCDelayTime actionWithDuration:0.5];
    CCCallBlock *focusToPlayer = [CCCallBlock actionWithBlock:^{
        [self focusToPlayerWithSpeed:300];
        
    }];
    [self runAction:[CCSequence actions:timeInterval,focusToPlayer, nil]];
}

- (void)focusToPlayerWithSpeed:(CGFloat) speed;
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
    CGPoint playerFocusPosition = [self positionFocusObjectName:@"SpawnPlayer"];
    CGPoint offsetToPositionPlayer = ccpSub(playerFocusPosition, tileMap.position);
    
    CGFloat timeAction = ccpDistance(offsetToPositionPlayer, ccp(0, 0)) / speed;
    CCCallFunc *callStartAllSchedule = [CCCallFunc actionWithTarget:self selector:@selector(playGame)];
    [self stopAllActions];
    [tileMap stopAllActions];
    [worldLayer stopAllActions];
    
    CCMoveTo *moveForMap = [CCMoveTo actionWithDuration:timeAction position:ccpAdd(offsetToPositionPlayer, tileMap.position)];
    CCMoveTo *moveForWorld = [CCMoveTo actionWithDuration:timeAction position:ccpAdd(offsetToPositionPlayer, worldLayer.position)];

    if (speed > 500)
    {
        [tileMap runAction:[CCEaseInOut actionWithAction:moveForMap rate:2.0]];
        [worldLayer runAction:[CCSequence actions:[CCEaseInOut actionWithAction:moveForWorld rate:2.0],callStartAllSchedule, nil]]; 
        [self addJoystick];
    }
    else
    {
        [tileMap runAction:[CCEaseInOut actionWithAction:moveForMap rate:2.0]];
        [worldLayer runAction:[CCSequence actions:[CCEaseInOut actionWithAction:moveForWorld rate:2.0],callStartAllSchedule, nil]]; 
    }
}

- (void) playGame
{
    remainingTime = 0;

    isPlay = YES;
    [self addJoystick];
    [self addJumpButton];
    [self addScoreLabel];
    [self addPauseButton];
    [self showJoystick];
    
    [self scheduleUpdate];
    [self schedule:@selector(tickTime) interval:1.0];
    [self schedule:@selector(collisionWithEnemys)];
   
}

- (void) showJoystick
{
    
    if (leftJoy.backgroundSprite.opacity == 0)
    {
        [leftJoystick.arrow runAction:[CCFadeIn actionWithDuration:0.3]];
        [leftJoy.backgroundSprite runAction:[CCFadeIn actionWithDuration:0.3]];
        [leftJoy.thumbSprite runAction:[CCFadeIn actionWithDuration:0.3]];
        leftJoystick.isEnabled = YES;
        
    }
}

- (void) hideJoystick
{
    
    if (jumpButtonItem.opacity != 0) 
    {
        [self stopUpdate];
        leftJoystick.arrow.opacity = 0;
        leftJoy.backgroundSprite.opacity = 0;
        leftJoy.thumbSprite.opacity = 0;
        leftJoystick.isEnabled = NO;
    }
}

- (void) showJumpButton
{
    [self stopUpdate];
    if (jumpButtonItem.opacity == 0)
    {
        [jumpButtonItem runAction:[CCFadeIn actionWithDuration:0.3]];
        [jumpButtonItem setIsEnabled:YES];
    }
}

- (void) hideJumpButton
{

    jumpButtonItem.opacity = 0;
    [jumpButtonItem setIsEnabled:NO];
}

- (void) playWaterEffect
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
    CGPoint tilePos = [self tilePosFromLocation:ccpAdd([self convertToWorldSpace:player.position], worldLayer.position) tileMap:tileMap];
    [self playWaterEffectWithDistance:[self distanceToWater:tilePos]];
}

- (void) playWaterEffectWithDistance:(NSInteger)distance
{
    if ((river == -1 && distance != 5) || river == -2) 
    {
        river =[[SimpleAudioEngine sharedEngine] playEffect:@"river.caf" pitch:1.0 pan:0.0 gain:0.0 loop:YES];
        
        CDSoundEngine *soundEngine = [[CDSoundEngine alloc] init];
        soundSource = [[CDSoundSource alloc] init:river sourceIndex:0 soundEngine:soundEngine];
        [[NSUserDefaults standardUserDefaults] setInteger:river forKey:@"riverId"];
    }

    CGFloat gain = 0.0;
    
    if (distance == 4)
    {
        gain = 0.1;
    }
    else if (distance == 3)
    {
        gain = 0.2;
    }
    else if (distance == 2)
    {
        gain = 0.3;
    }
    else if (distance == 1)
    {
        gain = 0.4;
    }
    else if (distance == 0)
    {
        gain = 0.5;
    }

    [CDXPropertyModifierAction fadeSoundEffect:0.5 finalVolume:gain curveType:kIT_Linear shouldStop:NO effect:soundSource];
    
    if (distance == 5) 
    {
        [[SimpleAudioEngine sharedEngine] stopEffect:river];
        river = -1;
        [[NSUserDefaults standardUserDefaults] setInteger:river forKey:@"riverId"];
    }
}

- (NSInteger) distanceToWater:(CGPoint) tilePos
{
    NSInteger distanceToWater = 5;
 
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    if ([MapCoordinationHelper isTilePosWater:tilePos tileMap:tileMap]) {
        distanceToWater = 0;
        return distanceToWater;
    }
    for (Crocodile *crocodile in crocodiles)
    {
        if (crocodile.withPlayer)
        {
            distanceToWater = 0;
            return distanceToWater;
        }
    }
    
    for (int i = 1; i <= 5; i++)
    {
        for (int direction = MoveDirectionLowerRight; direction <= MoveDirectionUpperLeft; direction++) 
        {
            CGPoint offset = moveOffsets[direction];
            offset = ccpMult(offset, i);
            
            CGPoint newTilePos = ccpAdd(tilePos, offset);
            if ([MapCoordinationHelper isTilePosWater:newTilePos tileMap:tileMap]) {
                distanceToWater = i;
                return distanceToWater;
            }
        }
    }
    return  distanceToWater;
}

- (CGPoint) pushSanta
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    
    CGPoint tilePos = [self tilePosFromLocation:screenCenter tileMap:tileMap];
    CGPoint offset; 
 
    for (int step = 3; step > 0; step--)
    {
        for (int dir = 1; dir < MAX_MoveDirections; dir++)
        {
          
            offset = moveOffsets[dir];
            
            CGPoint newOffset = ccpMult(offset, step);
            CGPoint newPosition = [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
                
            if (![MapCoordinationHelper isTilePosBlocked:newPosition tileMap:tileMap] ||
                ![MapCoordinationHelper isTilePosWater:newPosition tileMap:tileMap])
            {
                if ([self isPassage:step :dir])
                {
                    return [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
                }
            }    
        }        
    }
    
    return CGPointZero;
}

- (BOOL) isPassage:(NSInteger) step :(NSInteger) direction
{
    
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CGPoint tilePos = [self tilePosFromLocation:screenCenter tileMap:tileMap];
    BOOL isPassage = YES;
    CGPoint offset = moveOffsets[direction];
    for (int i = 0; i < step + 1; i++)
    {
        CGPoint newOffset = ccpMult(offset, i);
        CGPoint newPosition = [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
        
        if ([MapCoordinationHelper isTilePosBlocked:newPosition tileMap:tileMap] ||
            [MapCoordinationHelper isTilePosWater:newPosition tileMap:tileMap]) {
            return NO;
        }
    }
    return isPassage;
}

- (CGPoint)jumpPositionWithStep:(NSInteger)step
{
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* nodeLayer = [self getChildByTag:WorldLayer];
    NSAssert([nodeLayer isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)nodeLayer;
    
    CGPoint tilePos = [self tilePosFromLocation:screenCenter tileMap:tileMap];
    CGPoint offset = moveOffsets[player.playerDirection];
    
    CGPoint offsetIfCrocodile = CGPointZero;
    BOOL inCrocodile =NO;

    if([MapCoordinationHelper isTilePosWater:tilePos tileMap:tileMap])
    {
        inCrocodile = YES;
        CCDirector *director = [CCDirector sharedDirector];

        offsetIfCrocodile.x =  (offset.y ) * (tileMap.tileSize.width /[director contentScaleFactor]) / 2 ; 
        offsetIfCrocodile.y =  (offset.y ) * (tileMap.tileSize.height /[director contentScaleFactor]) / 2;
        offsetIfCrocodile = ccpMult(offsetIfCrocodile, -0.5);
        tilePos = [self tilePosFromLocation:ccpAdd(screenCenter, offsetIfCrocodile) tileMap:tileMap];
    }

    int noWaterPos = 0;
    for (int i = 1; i <= step; i++)
    {
        CGPoint newOffset = ccpMult(offset, i);
        CGPoint newPosition = [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
        
        if ([MapCoordinationHelper isTilePosBlocked:newPosition tileMap:tileMap])
        {
            if (noWaterPos == 0)
            {
                return CGPointZero;
            }
            CGPoint newOffset = ccpMult(offset, noWaterPos);
            return [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
        }
        if (![MapCoordinationHelper isTilePosWater:newPosition tileMap:tileMap])
        {
            if (inCrocodile)
            {
                if (i < 2) 
                {
                    noWaterPos = i;
                }
            }
            else
            {
               noWaterPos = i; 
            }
        }
        for (Crocodile *crocodile in crocodiles)
        {
            CGPoint crocodilePosition = ccpAdd(crocodile.position, worldLayer.position) ;
            crocodilePosition = [MapCoordinationHelper floatingTilePosFromLocation:crocodilePosition tileMap:tileMap];
            crocodilePosition = ccpSub(crocodilePosition, ccp(0.5, 0.5));
            
            CGPoint playerPosition = [MapCoordinationHelper floatingTilePosFromLocation:screenCenter tileMap:tileMap];
            playerPosition = ccpSub(playerPosition, ccp(0.5, 0.5));
            CGFloat offset = 0.7;
            //if the crocodilePosition from a distance of one cell
            if ((crocodilePosition.x > newPosition.x - offset && crocodilePosition.x < newPosition.x + offset) && 
                (crocodilePosition.y > newPosition.y - offset && crocodilePosition.y < newPosition.y + offset) && !crocodile.withPlayer)
            {
                if (crocodile.gold != nil)
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Zvuk_zolotogo_slitka.caf"];
                    [goldBarsLayer collectedNumberBar:countCollectedGoldStone];
                    countCollectedGoldBar++;
                    
                    [crocodile.gold removeFromParentAndCleanup:YES];
                    crocodile.gold = nil;
                }
                
                for (Crocodile *allCrocodile in crocodiles)
                {
                    allCrocodile.withPlayer = NO;
                }
                 
                if (!inCrocodile)
                {
                    player.positionMapRespawn = tileMap.position; 
                }

                crocodile.withPlayer = YES;
                /*eatPlayer
                CCCallBlock *eatPlayer = [CCCallBlock actionWithBlock:^{
                    if (crocodile.withPlayer)
                    {
                        [self respawnPlayer];
                    }
                }];
                CCSequence *sequence = [CCSequence actions:[CCActionInterval actionWithDuration:4.0],eatPlayer, nil];
                [crocodile runAction:sequence];
                */
                return crocodilePosition;
            }
            else if (noWaterPos > 0)
            {
                crocodile.withPlayer = NO;
            }
        } 
    }
   
    CGPoint newOffset = ccpMult(offset, noWaterPos);
    if (noWaterPos == 0)
    {
        return CGPointZero;
    }
    
    CGPoint newPosition = [self ensureTilePosIsWithinBounds:CGPointMake(tilePos.x + newOffset.x, tilePos.y + newOffset.y)];
    return newPosition;
}

- (void) onJump
{
    if (player.isStunned || isMoveScreen)
    {
        return;
    }
    
    CCNode* node = [self getChildByTag:TileMapNode];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* layerNode = [self getChildByTag:WorldLayer];
    NSAssert([layerNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)layerNode;
    
    CGPoint newPos = [self jumpPositionWithStep:player.stepJump];
    if (newPos.x != 0 && newPos.y != 0 ) 
    {
        player.isJump = YES;
        
        [tileMap stopAllActions];
        [worldLayer stopAllActions];
        [player stopAllActions];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"Santa_Jump.caf"];
        
        [MapCoordinationHelper centerTileMapOnTileCoord:newPos tileMap:tileMap worldLayer:worldLayer player:player];
        [self playWaterEffectWithDistance:[self distanceToWater:newPos]];
        [player animateJumpPlayerWithDirection:player.playerDirection];
        
        [jumpButtonItem setIsEnabled:NO];
        CCProgressTo *recoveryAction = [CCProgressTo actionWithDuration:1 percent:100];
        
        CCProgressTimer *recoveryTimer = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"jumpNormal.png"]];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        recoveryTimer.type = kCCProgressTimerTypeRadial;
        [self addChild:recoveryTimer];
        [recoveryTimer setPosition:ccp(screenSize.width * 410 / 480,screenSize.height * 70 / 320)];
        
        CCCallFuncN *callFinishRecovery = [CCCallBlock actionWithBlock:^{
            [recoveryTimer removeFromParentAndCleanup:YES];
            [jumpButtonItem setIsEnabled:YES];
        }];
        [recoveryTimer runAction:[CCSequence actions:recoveryAction,callFinishRecovery , nil ]];
    }

}

#pragma mark -
#pragma mark Positiom metods
- (CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	CGPoint pos = [MapCoordinationHelper floatingTilePosFromLocation:location tileMap:tileMap];

	// make sure coordinates are within bounds of the playable area, and cast to int
	pos = [self ensureTilePosIsWithinBounds:CGPointMake((int)pos.x, (int)pos.y)];
	//CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", location.x, location.y, (int)pos.x, (int)pos.y);
	return pos;
}

- (CGPoint) ensureTilePosIsWithinBounds:(CGPoint)tilePos
{
	tilePos.x = MAX(playableAreaMin.x, tilePos.x);
	tilePos.x = MIN(playableAreaMax.x, tilePos.x);
	tilePos.y = MAX(playableAreaMin.y, tilePos.y);
	tilePos.y = MIN(playableAreaMax.y, tilePos.y);
    
	return tilePos;
}

- (CGPoint) positionFocusObjectName:(NSString*)name;
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCNode* node = [self getChildByTag:TileMapNode];
	NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
	CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCTMXObjectGroup *objects = [tileMap objectGroupNamed:@"Objects"];
    NSMutableDictionary *spawnPlayer = [objects objectNamed:name];
    NSAssert(spawnPlayer.count > 0, @"SpawnPoint object missing");
    
    CCDirector *director = [CCDirector sharedDirector];
    
    CGFloat x = [[spawnPlayer valueForKey:@"x"] floatValue] ;
    CGFloat y = [[spawnPlayer valueForKey:@"y"] floatValue];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        x = x * 2;
        y = y * 2 - (tileMap.mapSize.height * tileMap.tileSize.height);
    }
    
    if ([director contentScaleFactor] == 2)//werwer
    {
        y = y - (tileMap.tileSize.height / 2) * tileMap.mapSize.height;
    }

    CGFloat mapTileOffsetX = (tileMap.tileSize.width /  [director contentScaleFactor]) / 2;
    CGFloat mapTileOffsetY = (tileMap.tileSize.height /  [director contentScaleFactor])  / 2;
    
    x = (x / (tileMap.tileSize.height /  [director contentScaleFactor]));
    y = (y / (tileMap.tileSize.height /  [director contentScaleFactor]));

    x = roundf(x);
    y = roundf(y);

    CGFloat halfHeightMap = (tileMap.tileSize.height /  [director contentScaleFactor]) * (-tileMap.mapSize.height / 2);
    
    CGPoint point = CGPointMake(screenSize.width / 2 - (y + x) * mapTileOffsetX, 
                                (screenSize.height / 2 + halfHeightMap  - (y - x) * mapTileOffsetY) - mapTileOffsetY);
    return  point;
}

#pragma mark -
#pragma mark Touch metods

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCNode* node = [self getChildByTag:TileMapNode];
    NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
    CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
    
    CCNode* layerNode = [self getChildByTag:WorldLayer];
    NSAssert([layerNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
    CCLayer* worldLayer = (CCLayer*)layerNode;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
    startMovePosition = touchLocation;
    startMapPosition = tileMap.position;
    startWorldPosition = worldLayer.position;
    
    [self stopActionByTag:1];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (!player.isMovePlay) 
    {
        CCNode* node = [self getChildByTag:TileMapNode];
        NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
        CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
        
        CCNode* layerNode = [self getChildByTag:WorldLayer];
        NSAssert([layerNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
        CCLayer* worldLayer = (CCLayer*)layerNode;
        
        [worldLayer stopActionByTag:2];
        [tileMap stopActionByTag:2];
        
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        if (isMoveScreen)
        {
            //[self hideJumpButton]; 
            
            CGPoint offset = ccpSub(startMovePosition,touchPoint);
            offset = ccpMult(offset, 1.5);
            CGPoint tilePos = [MapCoordinationHelper floatingTilePosFromLocation:ccpAdd(screenCenter , offset)  tileMap:tileMap];
            if (tilePos.x > 4 && tilePos.x < tileMap.mapSize.width - 4 &&
                tilePos.y > 4 && tilePos.y < tileMap.mapSize.height - 4) 
            {
                tileMap.position = ccpSub(startMapPosition, offset);
                worldLayer.position = ccpSub(startWorldPosition, offset);
            }
        }
        else
        {
            CGRect joystickTouchRect = CGRectMake(0, 0,screenSize.width * 150 / 480,screenSize.height * 140 / 320);
            if (CGRectContainsPoint(joystickTouchRect, startMovePosition) && isPlay) 
            {
                return;
            }
            
            if (ccpDistance(startMovePosition, touchPoint) > 50) 
            {
                for (Crocodile *allCrocodile in crocodiles)
                {
                    if (allCrocodile.withPlayer || player.opacity ==0)
                    {
                        return;
                    }
                }
                startMovePosition = touchPoint;
                startMapPosition = tileMap.position;
                startWorldPosition = worldLayer.position;
                
                
                
                isMoveScreen = YES;
                //[self hideJoystick];  
                
                mapBackPosition = tileMap.position;
                worldBackPosition = worldLayer.position;
                [self stopActionByTag:1];
                

            }
        } 
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded];
}

- (void) touchesEnded
{
    if (isMoveScreen && !player.isMovePlay) 
    {

        CCDelayTime *interval = [CCDelayTime actionWithDuration:1.0];
        CCSequence *sequence = [CCSequence actions:
                                interval,
                                [CCCallFunc actionWithTarget:self selector:@selector(moveMapBack)],
                                nil];
        sequence.tag = 1;
        [self runAction:sequence];
    }   
}

- (void) moveMapBack
{
    if (isMoveScreen)
    {
        CCNode* node = [self getChildByTag:TileMapNode];
        NSAssert([node isKindOfClass:[CCTMXTiledMap class]], @"not a CCTMXTiledMap");
        CCTMXTiledMap* tileMap = (CCTMXTiledMap*)node;
        
        CCNode* layerNode = [self getChildByTag:WorldLayer];
        NSAssert([layerNode isKindOfClass:[CCLayer class]], @"not a CCTMXTiledMap");
        CCLayer* worldLayer = (CCLayer*)layerNode;
        
        CGFloat timeAction = ccpDistance(tileMap.position,  mapBackPosition) / 500;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            timeAction = timeAction /2;
        }
        CCMoveTo *moveForMap = [CCMoveTo actionWithDuration:timeAction position:mapBackPosition];
        CCMoveTo *moveForWorld = [CCMoveTo actionWithDuration:timeAction position:worldBackPosition];
        
        CCCallBlock *finishMoveBack = [CCCallBlock actionWithBlock:^{
            isMoveScreen = NO;
            
            [self showJoystick];
            [self showJumpButton];
        }];     
        CCEaseInOut *easeInOut =  [CCEaseInOut actionWithAction:moveForMap rate:2.0];
        easeInOut.tag = 2;
        [tileMap runAction:easeInOut];
        
        CCSequence *sequence = [CCSequence actions:[CCEaseInOut actionWithAction:moveForWorld rate:2.0],finishMoveBack, nil];
        sequence.tag = 2;
        [worldLayer runAction:sequence];
    }
}
#pragma mark -
@end
