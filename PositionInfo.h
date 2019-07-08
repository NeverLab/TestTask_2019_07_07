//
//  Position.h
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PositionInfo : NSObject {
    int x;
    int y;
    NSString *path;
    CCSprite *sprite;
}

@property (nonatomic, readwrite) int x;
@property (nonatomic, readwrite) int y;
@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) CCSprite *sprite;

- (void) invalidate:(float) width withHeight:(float) height;

@end
