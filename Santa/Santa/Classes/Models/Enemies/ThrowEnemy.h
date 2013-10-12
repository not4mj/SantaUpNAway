//
//  ThrowEnemy.h
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enemies.h"
#import "ThrowDelegate.h"

@interface ThrowEnemy : Enemies {
    
}
@property (nonatomic, assign) id <ThrowDelegate> delegate;
@property (nonatomic, assign) ccBezierConfig stoneCurve;
@property (nonatomic, assign) CGFloat breakTime;

+ (ThrowEnemy*) throwEnemyWithType:(EnemiesType) type;
- (void) playAnimations;
@end
