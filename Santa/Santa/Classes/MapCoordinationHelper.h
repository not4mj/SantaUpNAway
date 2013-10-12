//
//  MapCoordinationHelper.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"

enum
{
	TileMapNode = 0,
    WorldLayer = 1,
};

@interface MapCoordinationHelper : NSObject
+ (void) centerTileMapOnTileCoord:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap worldLayer:(CCLayer*)worldLayer player:(Player*)player;
+ (CGPoint) floatingTilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap;
+ (CGPoint) mapConvertToWorldCoord:(CGPoint)location;
+ (bool) isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (bool) isTilePosWater:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (bool) isTilePosCollectableBarGold:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (bool) isTilePosCollectableStoneGold:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (bool) isTilePosFinished:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
+ (CGFloat) lengthFromPoint:(CGPoint) point toVector:(CGPoint)vectorPointZero :(CGPoint)vectorPointOne;
+ (EMoveDirection) directionWithAngle:(CGFloat)angle;
+ (BOOL) PointNearLineline_point1:(CGPoint) line_point1 line_point2:(CGPoint) line_point2 testPoint:(CGPoint) testPoint;
+ (EMoveDirection) directionWithAngleStunPlayer:(CGFloat)angle;
+ (CGPoint) unfloatingTilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap;
+ (NSInteger) heysInLevel:(CCTMXTiledMap*)tileMap;
+ (CGPoint) convertSpawn:(CGPoint)oldSpawnPoint :(CCTMXTiledMap*) tileMap;
+ (CGPoint) spawnPosition:(CGPoint) mapSpawnPoint :(CCTMXTiledMap*) tileMap;
@end
