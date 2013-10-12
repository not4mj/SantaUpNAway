//
//  Animal.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Animal : CCSprite 
{
}
@property (nonatomic, retain) CCAnimation *animationUpperLeft;
@property (nonatomic, retain) CCAnimation *animationLowerLeft;
@property (nonatomic, retain) CCAnimation *animationUpperRight;
@property (nonatomic, retain) CCAnimation *animationLowerRight;

@end
