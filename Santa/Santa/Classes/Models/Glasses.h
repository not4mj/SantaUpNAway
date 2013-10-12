//
//  Glasses.h
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
    GlassesTypeNone,
    GlassesTypeGreen,
    GlassesTypePink,
    GlassesTypeRed,
} GlassesType;

@interface Glasses : Clothing {
    
}
+ (Glasses *) glassesWithType:(GlassesType)type;
@end
