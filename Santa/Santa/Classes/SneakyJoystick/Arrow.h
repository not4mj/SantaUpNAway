//
//  Arrow.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Arrow : CCSprite {
    
}
@property (nonatomic, retain) CCAnimation *animationNone;
@property (nonatomic, retain) CCAnimation *animationUpperLeft;
@property (nonatomic, retain) CCAnimation *animationLowerLeft;
@property (nonatomic, retain) CCAnimation *animationUpperRight;
@property (nonatomic, retain) CCAnimation *animationLowerRight;

+ (Arrow *) arrow;
@end
