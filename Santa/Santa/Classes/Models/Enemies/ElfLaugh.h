//
//  ElfLaugh.h
//  Kangaroo
//
//  Created by Roman Semenov on 11/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ElfLaugh : CCSprite {
    
}
@property (nonatomic, retain) CCAnimation *animationLaugh;
@property (nonatomic, retain) CCSprite *bundle;
+ (ElfLaugh*) elfLaugh;
- (void) show;

@end
