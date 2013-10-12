//
//  Hat.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Clothing.h"

typedef enum
{
    HatTypeNone,
    HatTypeBaseball,
    HatTypeCowboy,
    HatTypeTop,
} HatType;

@interface Hat : Clothing 
{
    
}
+ (Hat *) hatWithType:(HatType)type;
@end
