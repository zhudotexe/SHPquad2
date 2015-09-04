//
//  FeedParser.m
//  RSSTest
//
//  Created by Andrew Zhu on 9/4/15.
//  Copyright (c) 2015 Andrew Zhu. All rights reserved.
//

#import "FeedParser.h"

@interface FeedParser () {
    NSXMLParser *_parser;
    NSMutableArray *_elementStack;
    NSArray *_items;
    NSDictionary *_item;
    NSString *_currentChars;
}

@end

@implementation FeedParser

- (void)parseURL:(NSURL *)url {
    
    _parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    [_parser setDelegate:self];
    _elementStack = [[NSMutableArray alloc]init];
    _items = [[NSMutableArray alloc]init];
    [_parser parse];
    
    
}

#pragma mark - XML Parser Delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        NSLog(@"Found Item");
        [_elementStack addObject:@"item"];
        _item = [[NSMutableDictionary alloc]init];
    } else if ([[_elementStack firstObject]isEqualToString:@"item"]) {
        [_elementStack addObject:elementName];
        NSLog(@"Found %@", elementName);
        NSLog(@"Stack: %@", _elementStack);
        _currentChars = [[NSString alloc]init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([[_elementStack firstObject]isEqualToString:@"item"] && [_elementStack count] > 1) {
        _currentChars = [NSString stringWithFormat:@"%@%@", _currentChars, string];
        NSLog(@"Found Chars, string: %@", _currentChars);
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    if ([[_elementStack firstObject]isEqualToString:@"item"] && [_elementStack count] > 1) {
        NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
        _currentChars = [NSString stringWithFormat:@"%@%@", _currentChars, string];
        NSLog(@"Found CDATA, string: %@", _currentChars);
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([[_elementStack lastObject]isEqualToString:@"item"]) {
        [_elementStack removeLastObject];
        NSLog(@"Ended item");
        // Append _item to _items
        _items = [_items arrayByAddingObject:_item];
        
        if (self.delegate) {
            [self.delegate didParseItem:_item];
        }
        
        NSLog(@"Finished Item: %@", _item);
        _item = nil;
    } else if ([_elementStack count] > 1) {
        [_elementStack removeLastObject];
        NSLog(@"Ended %@", elementName);
        NSLog(@"Stack: %@", _elementStack);
        NSLog(@"Element Value: %@", _currentChars);
        // Add key elementName to _item with value _currentChars
        NSString *value = _currentChars;
        [_item setValue:value forKey:elementName];
        // Reset _currentChars
        _currentChars = nil;
    }
}


- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Items: %@", _items);
    if (self.delegate) {
        [self.delegate didFinishParsing:_items];
    }
}


@end
