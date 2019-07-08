//
//  Item.m
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import "Item.h"
#import "PositionInfo.h"

@implementation Item

@synthesize type, positionArray/*, sprite*/;

+ (Item *) initItemWitNewType:(NSString *)newType {
    return [[self alloc]initItem: newType];
}

- (Item *) initItem:(NSString *)newType {
    self = [super init];
    
    type = newType;
    positionArray = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) addNewPosition:(NSString *) path posX:(int) x posY:(int) y
{
    PositionInfo* positionInfo = [PositionInfo new];
    positionInfo.path = path;
    positionInfo.x = x;
    positionInfo.y = y;
    //NSLog(@"\nNew pos added: \n{%@} (%i, %i)", path, x, y);
    [positionArray addObject:positionInfo];
}

- (void) invalidate:(float) width withHeight:(float) height
{
    for (PositionInfo* info in positionArray) {
        [info invalidate:width withHeight:height];
    }
}

- (CCSprite*) sprite
{
    NSUInteger randomIndex = arc4random() % positionArray.count;
    return [positionArray[randomIndex] sprite];
}


@end
