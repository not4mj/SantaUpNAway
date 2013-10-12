//
//  Enemies.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "Animal.h"

typedef enum
{
    EnemiesTypeElfSneak_1 = 1,
    EnemiesTypeElfSneak_2,
    EnemiesTypeElfSneak_3,
    EnemiesTypeElfSneak_4,
    EnemiesTypeElfThrow_1,
    EnemiesTypeElfThrow_2,
} EnemiesType;

@interface Enemies : Animal 
{
    
}

@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) EnemiesType type;
@property (nonatomic, assign) NSMutableArray *trajectory;

- (void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;
- (void) goToTrajectory;
- (CCAnimate *) animateWithDirection:(EMoveDirection)direction;
- (EMoveDirection) directionWithAngle:(CGFloat)angle;
+ (CGPoint) convertSpawn:(CGPoint)oldSpawnPoint :(CCTMXTiledMap*) tileMap;
@end
