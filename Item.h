//
//  Item.h
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject {
    NSMutableArray *positionArray;
    NSString *type;
}

@property (nonatomic, readwrite) NSMutableArray *positionArray;
@property (nonatomic, retain) NSString *type;

+ (Item*) initItemWitNewType:(NSString *)newType;

- (void) addNewPosition:(NSString *) path posX:(int) x posY:(int) y;
- (void) invalidate:(float) width withHeight:(float) height;
- (CCSprite*) sprite;

@end
