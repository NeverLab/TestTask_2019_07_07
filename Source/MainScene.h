#import "ConfigParser.h"
#import <Foundation/Foundation.h>

@interface MainScene : CCScene<ParserDelegate>
{
    BOOL parseDone;
    BOOL sceneEntered;
    BOOL gameStarted;
    ConfigParser* configParser;
}

- (void)onFinishParse;

@end
