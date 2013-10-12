//
//  Crocodile.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    EnemiesTypeOne = 1,
    EnemiesTypeTwo,
} CrocodileType;

@class Player;
@interface Crocodile : CCSprite 
{

}
@property (nonatomic, retain) CCAnimation *animationRotationToUpperLeft;
@property (nonatomic, retain) CCAnimation *animationRotationToLowerRight;

@property (nonatomic, assign) NSMutableArray *trajectory;
@property (nonatomic, retain) CCSprite *gold;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) BOOL goToFinish;
@property (nonatomic, assign) CGPoint startPosition;
@property (nonatomic, assign) BOOL withPlayer;
+ (Crocodile*) crocodile;
- (void) rotationUpperLeft;
- (void) rotationLowerRight;
@end
