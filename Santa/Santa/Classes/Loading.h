//
//  Loading.h
//  Kangaroo
//
//  Created by Роман Семенов on 3/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Loading : CCLayer 
{
    BOOL isLoading;    
}
@property (nonatomic, assign) BOOL isLoadedData;

+ (id) scene;

@end
