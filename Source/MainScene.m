#import "MainScene.h"
#import "ConfigParser.h"
#import "CCDirector.h"
#import "CCTransition.h"
#import "GameScene.h"

@implementation MainScene

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    
    parseDone = false;
    sceneEntered = false;
    gameStarted = false;
    
    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    NSAssert(self, @"Whoops");
    
    // Background
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"ic_launcher.png"];
    sprite.position = ccp(0.5, 0.5);
    sprite.positionType = CCPositionTypeNormalized;
    [self addChild:sprite];
    
    // The standard Hello World text
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Loading..." fontName:@"ArialMT" fontSize:16];
    label.positionType = CCPositionTypeNormalized;
    label.position = (CGPoint){0.5, 0.25};
    [self addChild:label];
    
    [self readConfig];
    
    // done
    return self;
}

- (void)readConfig
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    
    if (error)
        NSLog(@"Error reading file: %@", error.localizedDescription);
    
    //NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    //NSLog(@"items = %lu", (unsigned long)[listArray count]);
    
    configParser = [ConfigParser new];
    configParser.delegate = self;
    NSData *data = [fileContents dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:configParser];
    
    [parser parse];
}

- (void)onFinishParse
{
    parseDone = true;
    [self startGame];
}

- (void)onEnter
{
    [super onEnter];
    sceneEntered = true;
    [self startGame];
}

- (void)startGame
{
    if(parseDone && sceneEntered && !gameStarted)
    {
        gameStarted = true;
        
        CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
        CCScene* game = [GameScene initSceneWithData:configParser.bgPath gameItems:configParser.items];
        CCTransition* transition = [CCDefaultTransition transitionCrossFadeWithDuration:2];
        [director pushScene:game withTransition:transition];
    }
}
@end
