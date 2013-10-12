//
//  MapCoordinationHelper.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapCoordinationHelper.h"

@implementation MapCoordinationHelper


+ (EMoveDirection) directionWithAngle:(CGFloat)angle
{
    EMoveDirection direction = MoveDirectionNone;
    if (angle > 0 && angle < 90)
    {
        direction = MoveDirectionUpperRight;
    }
    else if (angle > 90 && angle < 180)
    {
        direction = MoveDirectionUpperLeft;
    }
    else if (angle < 0 && angle > -90)
    {
        direction =MoveDirectionLowerRight;
    }
    else if (angle > -180 && angle < -90)
    {
        direction = MoveDirectionLowerLeft;
    }
    return direction;
}

+ (EMoveDirection) directionWithAngleStunPlayer:(CGFloat)angle
{
    EMoveDirection direction = MoveDirectionNone;
    if (angle > 0 && angle < 90)
    {
        direction = MoveDirectionUpperRight;
    }
    else if (angle > 90 && angle < 180)
    {
        direction = MoveDirectionLowerRight;
    }
    else if (angle < 0 && angle > -90)
    {
        direction =MoveDirectionUpperLeft;
    }
    else if (angle > -180 && angle < -90)
    {
        direction = MoveDirectionLowerLeft;
    }
    return direction;
}

+ (CGPoint) floatingTilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
    CCDirector *director = [CCDirector sharedDirector];
	CGPoint pos = ccpSub(location , tileMap.position);

    float halfMapWidth = tileMap.mapSize.width * 0.5f;
	float mapHeight = tileMap.mapSize.height;
    
	float tileWidth = tileMap.tileSize.width / [director contentScaleFactor];
	float tileHeight = tileMap.tileSize.height / [director contentScaleFactor];
    
	CGPoint tilePosDiv = CGPointMake(pos.x / tileWidth, pos.y / tileHeight);
	float mapHeightDiff = mapHeight - tilePosDiv.y;
	
	float posX = (mapHeightDiff + tilePosDiv.x - halfMapWidth);
	float posY = (mapHeightDiff - tilePosDiv.x + halfMapWidth);
    
	return CGPointMake(posX, posY);
}

+ (CGPoint) unfloatingTilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
    CGSize tileSize = [tileMap tileSize];
    CGSize mapSize = [tileMap mapSize];
    CGPoint pos = ccpSub(location, [tileMap position]);
    float posX = floor(pos.x / tileSize.width);
    float posY = mapSize.height - floor(pos.y / tileSize.height);
    return ccp(posX, posY);
}

+(void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap worldLayer:(CCLayer*)worldLayer player:(Player*)player;
{
    if (!player.isStunned)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        // get the ground layer
        CCTMXLayer* layer = [tileMap layerNamed:@"Ground"];
        NSAssert(layer != nil, @"Ground layer not found!");
        
        // internally tile Y coordinates seem to be off by 1, this fixes the returned pixel coordinates
        tilePos.y -= 1;

        CGPoint scrollPosition = [layer positionAt:tilePos];

        // negate the position for scrolling
        scrollPosition = ccpMult(scrollPosition, -1);
        // add offset to screen center
        scrollPosition = ccpAdd(scrollPosition, screenCenter);
        
        //CCLOG(@"tilePos: (%i, %i) moveTo: (%.0f, %.0f)", (int)tilePos.x, (int)tilePos.y, scrollPosition.x, scrollPosition.y);
        CGPoint worldScrollPosition = ccpSub(scrollPosition , tileMap.position);
        //NSLog(@"ccpDistance =%f",ccpDistance(scrollPosition, tileMap.position));
        ccTime timeJump = 0.3f;//0.27
        
        CGFloat lengthJump = fabsf(worldScrollPosition.x / 50);
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            lengthJump /= 2;
        
        CCFiniteTimeAction *moveAction;
        CGPoint centerPos = ccp(screenSize.width/2, screenSize.height/2);
        CGPoint posPlayer = ccpSub(centerPos, ccpAdd(worldLayer.position, worldScrollPosition));
        if (!player.isJump)
        {//walk
            moveAction = [CCMoveTo actionWithDuration:timeJump position:posPlayer];
        }
        else
        {//use jump
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            {
                lengthJump *= 2;
            }
                
            ccBezierConfig curve;
            curve.controlPoint_1 = ccpAdd(ccpAdd(ccpMult(ccpSub(posPlayer, player.position), 0.2), player.position) , ccp(0, 8 * lengthJump));
            curve.controlPoint_2 = ccpAdd(ccpAdd(ccpMult(ccpSub(posPlayer, player.position), 0.5), player.position), ccp(0, 15 * lengthJump)) ;
            curve.endPosition = posPlayer;
            moveAction = [CCBezierTo actionWithDuration:timeJump bezier:curve];
        }

        player.isMovePlay = YES;
        CCCallBlock * callIdle = [CCCallBlock actionWithBlock:^{

                [player animateIdlePlayerWithDirection:player.playerDirection];
                
                player.isMovePlay = NO;
                player.isJump = NO;
        }]; 
    
        
        CCMoveTo* move = [CCMoveTo actionWithDuration:timeJump  position:scrollPosition];
        [tileMap runAction:[CCSequence actions:move, nil ]];
        
        CCMoveBy* moveWorldLayer = [CCMoveBy actionWithDuration:timeJump  position:worldScrollPosition];
        [worldLayer runAction: moveWorldLayer];
        
        [player runAction:[CCSequence actions:moveAction,callIdle, nil]];
    }
}

+ (CGPoint) mapConvertToWorldCoord:(CGPoint)location
{
    location.x = location.x / 78;
    location.y = -location.y / 78;
    CGPoint newNextPoint;
    newNextPoint.x =  (location.y + location.x)* 50;
    newNextPoint.y =  (location.y - location.x) * 39;
    return newNextPoint;
}


+ (BOOL) PointNearLineline_point1:(CGPoint) line_point1 line_point2:(CGPoint) line_point2 testPoint:(CGPoint) testPoint
{
    BOOL result = NO;
    int tmp = (line_point2.x-line_point1.x)*(testPoint.y-line_point1.y) -
    (line_point2.y-line_point1.y)*(testPoint.x-line_point1.x);

    if (tmp == 0) 
    {
        result = YES;
    }
    return result;
}

+ (CGFloat) lengthFromPoint:(CGPoint) point toVector:(CGPoint)vectorPointZero :(CGPoint)vectorPointOne
{
    CGFloat length;
    length = (vectorPointZero.y - vectorPointOne.y) * point.x + (vectorPointOne.x - vectorPointZero.x)*point.y + (vectorPointZero.x*vectorPointOne.y - vectorPointOne.x*vectorPointZero.y) /
    sqrtf((vectorPointOne.x - vectorPointZero.x)* (vectorPointOne.x - vectorPointZero.x)) + 
    sqrtf((vectorPointOne.y - vectorPointZero.y)* (vectorPointOne.y - vectorPointZero.y));
    
    return length;
}
#pragma mark -
#pragma mark this is position

+(bool) isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
	CCTMXLayer* layer = [tileMap layerNamed:@"Meta"];
	NSAssert(layer != nil, @"Meta layer not found!");
	
	bool isBlocked = NO;
	unsigned int tileGID = [layer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_movement = [tileProperties objectForKey:@"blocks_movement"];
		isBlocked = (blocks_movement != nil);
	}
	return isBlocked;
}

+(bool) isTilePosWater:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
	CCTMXLayer* layer = [tileMap layerNamed:@"Meta"];
	NSAssert(layer != nil, @"Meta layer not found!");
	
	bool isWater = NO;
	unsigned int tileGID = [layer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_movement = [tileProperties objectForKey:@"water"];
		isWater = (blocks_movement != nil);
	}
	return isWater; 
}

+ (bool) isTilePosCollectableBarGold:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
    CCTMXLayer* metaLayer = [tileMap layerNamed:@"Meta"];
	NSAssert(metaLayer != nil, @"Meta layer not found!");
    
    bool isCollectable = NO;
	unsigned int tileGID = [metaLayer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_collectable = [tileProperties objectForKey:@"Collectable"];
		isCollectable = (blocks_collectable != nil);
        
        if (isCollectable) 
        {
            [metaLayer removeTileAt:tilePos];
            
            CCTMXLayer* groundObjectsLayer = [tileMap layerNamed:@"GroundObjects"];
            NSAssert(groundObjectsLayer != nil, @"ground Objects Layer not found!");
            [groundObjectsLayer removeTileAt:tilePos];
        }
	}
    return isCollectable;
}

+ (bool) isTilePosCollectableStoneGold:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
    CCTMXLayer* metaLayer = [tileMap layerNamed:@"Meta"];
	NSAssert(metaLayer != nil, @"Meta layer not found!");
    
    bool isCollectable = NO;
	unsigned int tileGID = [metaLayer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_collectable = [tileProperties objectForKey:@"CollectableStone"];
		isCollectable = (blocks_collectable != nil);
        
        if (isCollectable) 
        {
            [metaLayer removeTileAt:tilePos];
            
            CCTMXLayer* groundObjectsLayer = [tileMap layerNamed:@"GroundObjects"];
            NSAssert(groundObjectsLayer != nil, @"ground Objects Layer not found!");
            [groundObjectsLayer removeTileAt:tilePos];
        }
	}
    return isCollectable;
}

+ (bool) isTilePosFinished:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
    CCTMXLayer* metaLayer = [tileMap layerNamed:@"Meta"];
	NSAssert(metaLayer != nil, @"Meta layer not found!");
    
    bool isFinished = NO;
	unsigned int tileGID = [metaLayer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_movement = [tileProperties objectForKey:@"Finish"];
		isFinished = (blocks_movement != nil);
	}
    return isFinished;
    return NO;
}

+ (NSInteger) heysInLevel:(CCTMXTiledMap*)tileMap
{
    CCTMXLayer* metaLayer = [tileMap layerNamed:@"Meta"];
	NSAssert(metaLayer != nil, @"Meta layer not found!");
    
    NSInteger count = 0;
    for (int i = 0; i < tileMap.mapSize.width; i++)
    {
        for (int j = 0; j < tileMap.mapSize.height; j++)
        {
            bool isCollectable = NO;
            unsigned int tileGID = [metaLayer tileGIDAt:ccp(i, j)];
            if (tileGID > 0)
            {
                NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
                id blocks_collectable = [tileProperties objectForKey:@"CollectableStone"];
                isCollectable = (blocks_collectable != nil);
                
                if (isCollectable)
                {
                    count++;
                }
            }

        }
    }
    return count;
}

+ (CGPoint) convertSpawn:(CGPoint)oldSpawnPoint :(CCTMXTiledMap*) tileMap
{
    CCDirector *director = [CCDirector sharedDirector];
    
    CGPoint spawnPosition;
    
    spawnPosition.x = oldSpawnPoint.x /(tileMap.tileSize.height / [director contentScaleFactor]);
    spawnPosition.y = oldSpawnPoint.y /(tileMap.tileSize.height / [director contentScaleFactor]);
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint newPoint;
    newPoint.x = (spawnPosition.y + spawnPosition.x ) * ((tileMap.tileSize.width/2) / [director contentScaleFactor]) + (screenSize.width / 2 ) - (tileMap.tileSize.width/2) / [director contentScaleFactor];
    newPoint.y = (spawnPosition.y - spawnPosition.x) * ((tileMap.tileSize.height/2) / [director contentScaleFactor]) + (screenSize.height / 2);
    
    return newPoint;
}

+ (CGPoint) spawnPosition:(CGPoint) mapSpawnPoint :(CCTMXTiledMap*) tileMap
{
    CGPoint spawnPosition = mapSpawnPoint;

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        spawnPosition.x = spawnPosition.x * 2;
        spawnPosition.y = spawnPosition.y * 2 - (tileMap.mapSize.height * tileMap.tileSize.height);
    }
    if ([[CCDirector sharedDirector] contentScaleFactor] == 2)
    {
        spawnPosition.y = spawnPosition.y - (tileMap.tileSize.height / 2) * tileMap.mapSize.height;
    }
     
    return [MapCoordinationHelper convertSpawn:spawnPosition :tileMap];
}
@end
