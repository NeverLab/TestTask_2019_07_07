//
//  GameScene.m
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Item.h"
#import "PositionInfo.h"
#import "cocos2d-ui.h"
#import "CCDirector.h"

#define CLAMP(x, low, high) ({\
__typeof__(x) __x = (x); \
__typeof__(low) __low = (low);\
__typeof__(high) __high = (high);\
__x > __high ? __high : (__x < __low ? __low : __x);\
})

@implementation GameScene

@synthesize items, bgPath;

+ (GameScene *) initSceneWithData:(NSString *)bgPath gameItems:(NSArray *) items
{
    return [[self alloc]initScene:bgPath gameItems: items];
}

- (GameScene *)initScene:(NSString *)bgPath gameItems:(NSArray *) items
{
    self = [super init];
    self.userInteractionEnabled = YES;
    
    self.bgPath = bgPath;
    self.items = items;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchZoom:)];
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    [[director view] addGestureRecognizer:pinch];
    
    CCNodeColor *backColor = [CCNodeColor nodeWithColor:[CCColor colorWithRed:80 / 255.0f
                                                                        green:160 / 255.0f
                                                                         blue:190 / 255.0f]];
    [self addChild:backColor];
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *bgResourcesPath = [resourcePath stringByAppendingPathComponent:bgPath];
    
    rootSprite = [CCSprite spriteWithImageNamed:bgResourcesPath];
    rootSprite.position = ccp(0.5, 0.5);
    rootSprite.positionType = CCPositionTypeNormalized;
    
    bgWidth = rootSprite.contentSize.width;
    bgHeight = rootSprite.contentSize.height;
    float dWidth = [[UIScreen mainScreen] bounds].size.width / bgWidth;
    float dHeight = [[UIScreen mainScreen] bounds].size.height / bgHeight;
    
    scaleMin = dWidth > dHeight ? dWidth : dHeight;
    scaleMax = scaleMin * 1.3;
    scaleCurrent = scaleMin;
    pinchScale = scaleCurrent;
    rootSprite.scale = scaleCurrent;
    
    [self addChild:rootSprite];
    
    for (Item* item in items) {
        [item invalidate:bgWidth withHeight:bgHeight];
    }
    
    bgWidth = bgWidth * scaleMin / [[UIScreen mainScreen] bounds].size.width;
    bgHeight = bgHeight * scaleMin / [[UIScreen mainScreen] bounds].size.height;
    
    CCButton *resetButton = [CCButton buttonWithTitle:@"[ RESET ]"
                                                  fontName:@"ArialMT"
                                                  fontSize:18.0f];
    resetButton.color = [CCColor blackColor];
    [resetButton setLabelColor:[CCColor whiteColor]
                           forState:CCControlStateHighlighted];
    resetButton.positionType = CCPositionTypeNormalized;
    resetButton.position = ccp(0.5f, (resetButton.contentSize.height / 2) /[[UIScreen mainScreen] bounds].size.height);
    
    [resetButton setTarget:self
                       selector:@selector(reset)];
    [self addChild:resetButton];
    
    [self reset];
    
    return self;
}

- (void)onEnter
{
    //printf("\nGame started!\n");
    [super onEnter];
}

-(CGPoint) locationNormilized:(CGPoint) oldPoint
{
    return CGPointMake(oldPoint.x / [[UIScreen mainScreen] bounds].size.width, 1 - oldPoint.y / [[UIScreen mainScreen] bounds].size.height);
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    touchStart = [self locationNormilized:touch.locationInWorld];
    rootPosition = rootSprite.position;
}

- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if([[event allTouches]count] < 2)
    {
        CGPoint normLoc = [self locationNormilized:touch.locationInWorld];
        float dX = normLoc.x - touchStart.x;
        float dY = touchStart.y - normLoc.y;
        rootSprite.position = ccp(
          rootPosition.x + dX,
          rootPosition.y + dY
        );
        [self invalidatePosition];
    }
}

- (void) touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
}

- (void) touchCancelled:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
}

-(void) reset{
    [rootSprite removeAllChildren];
    for (Item* item in items) {
        [rootSprite addChild:[item sprite]];
    }
}

CGFloat sqrOfDistanceBetweenPoints(CGPoint p1, CGPoint p2)
{
    CGPoint diff = ccpSub(p1, p2);
    return diff.x * diff.x + diff.y * diff.y;
}

-(void)pinchZoom:(UIPinchGestureRecognizer*)pinch
{
    if(pinch.state == UIGestureRecognizerStateEnded)
    {
        pinchScale = scaleCurrent;
    }
    else
    {
        //if(pinch.state == UIGestureRecognizerStateBegan && pinchScale != 0.0f)
        if(pinch.scale != NAN && pinch.scale != 0.0)
        {
            scaleCurrent = CLAMP(pinchScale + (pinch.scale - 1) * (scaleMax - scaleMin), scaleMin, scaleMax);
            rootSprite.scale = scaleCurrent;
        }
    }
    [self invalidatePosition];
}

-(void) invalidatePosition
{
    float dScale = scaleCurrent / scaleMin;
    float dw = fabsf((dScale * bgWidth - 1) / 2);
    float dh = fabsf((dScale * bgHeight - 1) / 2);
    rootSprite.position = ccp(
        CLAMP(rootSprite.position.x, 0.5 - dw, 0.5 + dw),
        CLAMP(rootSprite.position.y, 0.5 - dh, 0.5 + dh)
    );
}

@end
