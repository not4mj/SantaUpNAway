//
//  Reindeer.h
//  Kangaroo
//
//  Created by Roman Semenov on 10/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
@interface Reindeer : CCSprite {
    
}
+ (Reindeer*) reindeerWithDirection:(EMoveDirection)direction;
@end
