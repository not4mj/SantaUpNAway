//
//  MorePresents.h
//  Kangaroo
//
//  Created by Roman Semenov on 11/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MorePresents : CCLayer {
    
}
- (id) initWithTime:(NSInteger) time;
+ (id) sceneWithTime:(NSInteger) time;
@end