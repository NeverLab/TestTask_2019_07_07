//
//  ConfigParser.h
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

@protocol ParserDelegate
@optional
// объявляем метод делегата
- (void)onFinishParse;
@end

@interface ConfigParser : NSObject<NSXMLParserDelegate> {
    
    BOOL m_isItem;
    BOOL m_isBG;
    NSMutableArray* m_items;
    NSMutableString* m_content;
    NSMutableDictionary* m_attrs;
    NSString *bgPath;
    
}

// результат парсинга
@property (readonly) NSArray* items;
@property (nonatomic, retain) NSString *bgPath;
@property (weak, nonatomic) id <ParserDelegate> delegate;

@end
