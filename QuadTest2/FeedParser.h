//
//  FeedParser.h
//  RSSTest
//
//  Created by Andrew Zhu on 9/4/15.
//  Copyright (c) 2015 Andrew Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedParserProtocol <NSObject>

- (void)didParseItem:(NSDictionary*)item;
- (void)didFinishParsing:(NSArray*)items;

@end

@interface FeedParser : NSObject <NSXMLParserDelegate>

@property (nonatomic,weak) id<FeedParserProtocol> delegate;

- (void)parseURL:(NSURL*)url;

@end
