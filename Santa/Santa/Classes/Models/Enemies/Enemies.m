//
//  Enemies.m
//  Kangaroo
//
//  Created by Роман Семенов on 2/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemies.h"
#import "MapCoordinationHelper.h"
#import "Constants.h"


@implementation Enemies
@synthesize trajectory;
@synthesize speed;
@synthesize type;


-(void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
	float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
	float currentZ = tilePos.x + tilePos.y;
	self.vertexZ = lowestZ + currentZ - 0.5f;
}

-(void) goToTrajectory
{
    NSMutableArray *moveArray = [[NSMutableArray new] autorelease];
    NSMutableArray *animateArray = [[NSMutableArray new] autorelease];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.speed *= 2;
    }
    for (int i = 0; i < [self.trajectory count]; i++)
    {
        CGPoint currentPoint =CGPointFromString([self.trajectory objectAtIndex:i]);
        currentPoint = [MapCoordinationHelper mapConvertToWorldCoord:currentPoint];
        
        CGPoint nextPoint;
        if (i == [self.trajectory count] - 1)
        {
            nextPoint = CGPointFromString([self.trajectory objectAtIndex:0 ]);
        }
        else
        {
            nextPoint = CGPointFromString([self.trajectory objectAtIndex:i + 1 ]);
        }
        nextPoint = [MapCoordinationHelper mapConvertToWorldCoord:nextPoint];
        
        CGFloat angleDirection = CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(nextPoint, currentPoint)));
        EMoveDirection direction = [self directionWithAngle:angleDirection];
        
        [animateArray addObject:[CCSequence actions:[self animateWithDirection:direction], nil]];

        [moveArray addObject:[CCSequence actions:[CCMoveTo actionWithDuration:ccpDistance(currentPoint, nextPoint) / self.speed position:ccpAdd(self.position, nextPoint) ], nil]];           
    }

    CCSequence *currentMoveAction = nil;
    CCCallFuncN *currentCall = nil;
    CCRepeatForever *animateAction;
    for (int i = 0; i < [moveArray count]; i++)
    {
        CCSequence *moveAction = [moveArray objectAtIndex:i];
        animateAction = [CCRepeatForever actionWithAction:[animateArray objectAtIndex:i]];
        animateAction.tag = 1;
        if (!currentMoveAction)
        {
            currentMoveAction = moveAction;
        }
        else
        {
            currentCall = [CCCallBlock actionWithBlock:^{
                [self stopActionByTag:1];
                [self runAction:animateAction];
            }];
            currentMoveAction = [CCSequence actions:currentMoveAction,currentCall,moveAction, nil];
        }
    }
    
    animateAction = [CCRepeatForever actionWithAction:[animateArray objectAtIndex:0]];
    animateAction.tag = 1;
    currentCall = [CCCallBlock actionWithBlock:^{
        [self stopActionByTag:1];
        [self runAction:animateAction];
    }];
    
    currentMoveAction = [CCSequence actions:currentCall,currentMoveAction, nil];
    [self runAction:[CCRepeatForever actionWithAction: currentMoveAction]];
}

-(EMoveDirection) directionWithAngle:(CGFloat)angle
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

-(CCAnimate *) animateWithDirection:(EMoveDirection)direction
{
    CCAnimate *animate;
    if (direction == MoveDirectionUpperLeft ) 
    {
        animate = [CCAnimate actionWithAnimation:self.animationUpperLeft];
    }
    else if(direction == MoveDirectionLowerLeft ) 
    {
        animate = [CCAnimate actionWithAnimation:self.animationLowerLeft];
    }
    else if(direction == MoveDirectionUpperRight ) 
    {
        animate = [CCAnimate actionWithAnimation:self.animationUpperRight];
    }
    else if(direction == MoveDirectionLowerRight ) 
    {
        animate = [CCAnimate actionWithAnimation:self.animationLowerRight]; 
    }
    else
    {
        animate = [CCAnimate actionWithAnimation:self.animationLowerRight]; 
    }
    return animate;
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
@end
