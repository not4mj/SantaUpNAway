//
//  SneakEnemy.h
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Enemies.h"

@interface SneakEnemy : Enemies {
    
}
+ (SneakEnemy*) sneakEnemyWithType:(EnemiesType ) type;

@end
