//
//  ThrowDelegate.h
//  Kangaroo
//
//  Created by Roman Semenov on 10/26/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol ThrowDelegate <NSObject>
- (void) addProjectile:(CCSprite*)projectile;
- (void) deleteProjectile:(CCSprite*)projectile;
- (void) playStoneEffect:(CGPoint) position;
@end
