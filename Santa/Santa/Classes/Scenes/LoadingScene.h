//
//  LoadingScene.h
//  ElementTD
//
//  Created by Roman Semenov on 07.02.11.
//  Copyright 2011 TRASD. All rights reserved.
//

#import "cocos2d.h"

@interface LoadingScene : CCScene {
	
}
@end

@interface LoadingLayer : CCLayer {
	CCSprite *defaultImage;
    CCSpriteBatchNode *batchNode;
    CCSprite *mainBkgrnd;
    CCSprite *mainTitle;
    CCSprite *tapToCont;
    CCLabelTTF *loadingLebel;
	
    BOOL isLoading;
    BOOL imagesLoaded;
    BOOL scenesLoaded;
    
}
@property (nonatomic, assign) CCSprite *defaultImage;
@property (nonatomic, assign) CCSpriteBatchNode *batchNode;
@property (nonatomic, assign) CCSprite *mainBkgrnd;
@property (nonatomic, assign) CCSprite *mainTitle;
@property (nonatomic, assign) CCSprite *tapToCont;
@property (nonatomic, assign) CCLabelTTF *loadingLebel;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL imagesLoaded;
@property (nonatomic, assign) BOOL scenesLoaded;

@end