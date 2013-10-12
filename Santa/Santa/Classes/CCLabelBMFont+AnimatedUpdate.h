//
//  CCLabelBMFont+AnimatedUpdate.h
//  ShapeDrop
//
//  Created by Alexander on 9/11/12.
//  Copyright (c) 2012 Tap Company. All rights reserved.
//

#import "CCLabelBMFont.h"

@interface CCLabelBMFont (AnimatedUpdate)

- (void) animateValueFrom:(int)from to:(int)to interval:(ccTime)interval;
- (void) animateValueFrom:(int)from to:(int)to interval:(ccTime)interval delay:(ccTime)delay;

@end
