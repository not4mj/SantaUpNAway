//
//  SneakJoystickDelegate.h
//  Kangaroo
//
//  Created by Роман Семенов on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol SneakJoystickDelegate <NSObject>
-(void) updateJoystikDirection:(EMoveDirection) direction;
-(void) stopUpdate;
-(void) moveMapBack;
@end
