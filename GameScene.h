//
//  GameScene.h
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene {
    NSString* bgPath;
    NSArray* items;
    float scaleCurrent;
    float scaleMin;
    float scaleMax;
    float bgWidth;
    float bgHeight;
    float pinchScale;
    CGPoint rootPosition;
    CGPoint touchStart;
    CCSprite* rootSprite;
}

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *bgPath;
 
+ (GameScene *) initSceneWithData:(NSString *)bgPath gameItems:(NSArray *) items;

@end

