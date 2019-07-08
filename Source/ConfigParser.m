//
//  ConfigParser.m
//  TTxcode
//
//  Created by Dmitry Pavlov on 07/07/2019.
//  Copyright © 2019 Apportable. All rights reserved.
//

#import "ConfigParser.h"
#import "Item.h"

@implementation ConfigParser

@synthesize items=m_items, bgPath;

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
    m_items = [NSMutableArray new];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if(self.delegate)
    {
        [self.delegate onFinishParse];
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    m_isItem = [[elementName lowercaseString] isEqualToString:@"item"];
    m_isBG = !m_isItem && [[elementName lowercaseString] isEqualToString:@"background"];
    
    if(m_isItem)
    {
        m_attrs = [attributeDict mutableCopy];
    }
    
    m_content = [NSMutableString new];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSString* content = m_content;
    //content = [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ( m_isItem ) {
        
        NSString* type = (NSString *)[NSString stringWithFormat:@"%@", [m_attrs objectForKey:@"type"]];
        
        NSUInteger index = [m_items indexOfObjectPassingTest:^BOOL(Item *item, NSUInteger idx, BOOL *stop) {
            if ([item.type isEqualToString:type]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        BOOL doAddNewItem = index == NSNotFound;
        
        Item* tempItem = doAddNewItem ? [Item initItemWitNewType:type] : m_items[index];
        if(doAddNewItem) [m_items addObject:tempItem];
        
        int x = [m_attrs[@"x"] intValue];
        int y = [m_attrs[@"y"] intValue];
        
        [tempItem addNewPosition:content posX:x posY:y];
        
        m_isItem = false;
        [m_attrs removeAllObjects];
    }
    else if ( m_isBG ) {
        
        bgPath = content;
        m_isBG = false;
        
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [m_content appendString:string];
    
}

@end
