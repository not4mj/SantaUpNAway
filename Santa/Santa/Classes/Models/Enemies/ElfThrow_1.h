//
//  ElfThrow_1.h
//  Kangaroo
//
//  Created by Roman Semenov on 10/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Enemies.h"
#import "Constants.h"
#import "ThrowDelegate.h"
@interface ElfThrow_1 : Enemies {
    
}
@property (nonatomic, assign) id <ThrowDelegate> delegate;
@property (nonatomic, assign) ccBezierConfig stoneCurve;
@property (nonatomic, assign) CGFloat breakTime;

+ (ElfThrow_1 *) elf;
- (void) playAnimations;
@end
