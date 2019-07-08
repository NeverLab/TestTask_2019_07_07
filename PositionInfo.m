//
//  Position.m
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import "PositionInfo.h"

@implementation PositionInfo

@synthesize path, x, y, sprite;

- (void) invalidate:(float) width withHeight:(float) height
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *imgResourcesPath = [resourcePath stringByAppendingPathComponent:path];
    sprite = [CCSprite spriteWithImageNamed:imgResourcesPath];
    sprite.position = ccp((x + sprite.contentSize.width / 2) / width, 1 - (y + sprite.contentSize.height / 2) / height);
    sprite.positionType = CCPositionTypeNormalized;
}

@end
