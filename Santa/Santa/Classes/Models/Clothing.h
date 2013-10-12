//
//  Clothing.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Clothing : CCSprite {
    
}
@property (nonatomic, retain) CCAnimation *animationJumpUpperLeft;
@property (nonatomic, retain) CCAnimation *animationJumpLowerLeft;
@property (nonatomic, retain) CCAnimation *animationJumpUpperRight;
@property (nonatomic, retain) CCAnimation *animationJumpLowerRight;

@property (nonatomic, retain) CCAnimation *animationIdleUpperLeft;
@property (nonatomic, retain) CCAnimation *animationIdleLowerLeft;
@property (nonatomic, retain) CCAnimation *animationIdleUpperRight;
@property (nonatomic, retain) CCAnimation *animationIdleLowerRight;
@end
