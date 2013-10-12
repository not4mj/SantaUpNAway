//
//  Satchel.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Clothing.h"

typedef enum
{
    SatchelTypeNone,
    SatchelTypeBlue,
    SatchelTypePink,
    SatchelTypeRed,
} SatchelType;

@interface Satchel : Clothing 
{
    
}
+ (Satchel *) satchelWithType:(SatchelType)type;
@end
