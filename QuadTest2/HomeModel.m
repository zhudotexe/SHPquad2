//
//  HomeModel.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "HomeModel.h"



@implementation HomeModel

-(void) downloadItems
{
    //URL
    NSURL *feedURL = [NSURL URLWithString:@"http://shpquad.org/?feed=rss2"];
    self.feedParser = [[MWFeedParser alloc]initWithFeedURL:feedURL];
    
    //delegate
    self.feedParser.delegate = self;
    
    //parse type
    self.feedParser.feedParseType = ParseTypeFull;
    
    //connection type
    self.feedParser.connectionType = ConnectionTypeAsynchronously;
    
    //do the thing!
    [self.feedParser parse];
}

-(void) feedParserDidStart:(MWFeedParser *)parser{
    self.feedItems = [[NSMutableArray alloc] init];
}

-(void) feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    FeedItem *feedItem = [[FeedItem alloc] init];
    feedItem.title = item.title ? item.title : @"Untitled";
    feedItem.author = item.author ? item.author : @"Unknown Author";
    feedItem.content = item.content ? item.content : @"This article does not contain any text.";
    feedItem.date = item.date;
    feedItem.link = item.link ? item.link : @"http://shpquad.org/404";
    feedItem.images = [self parseImages:item.content];
    
    [self.feedItems addObject:feedItem];
    
}

#pragma mark Image Handler

- (NSMutableArray *)parseImages:(NSString *)content {
    @autoreleasepool {
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:5];
            
        // Character sets
        NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        
        NSMutableString *result = [[NSMutableString alloc]initWithString:@""];
        NSString *url = nil;
        
        // Scan and find all tags
        NSScanner *scanner = [[NSScanner alloc] initWithString:content];
        [scanner setCharactersToBeSkipped:nil];
        [scanner setCaseSensitive:YES];
        NSString *str = nil, *tagName = nil;
        BOOL dontReplaceTagWithSpace = NO;
        do {
                
            // Scan up to the start of a tag or whitespace
            if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
                [result appendString:str];
                str = nil; // reset
            }
                
            // Check if we've stopped at a tag/comment or whitespace
            if ([scanner scanString:@"<" intoString:NULL]) {
                    
                // Stopped at a comment, script tag, or other tag
                if ([scanner scanString:@"!--" intoString:NULL]) {
                        
                    // Comment
                    [scanner scanUpToString:@"-->" intoString:NULL];
                    [scanner scanString:@"-->" intoString:NULL];
                        
                } else if ([scanner scanString:@"img" intoString:NULL]){
                    
                    //find image url
                    [scanner scanUpToString:@"src=" intoString:NULL];
                    [scanner scanString:@"src=\"" intoString:NULL];
                    //get the actual url
                    [scanner scanUpToString:@"\"" intoString:&url];
                        
                    //add the url to the image array
                    [images addObject:[[NSURL alloc]initWithString:url]];
                    
                    //NSLog(@"Added URL: %@",[images lastObject]);
                    
                    url = nil;
                    
                    // Scan past tag
                    [scanner scanUpToString:@">" intoString:NULL];
                    [scanner scanString:@">" intoString:NULL];
                        
                } else if ([scanner scanString:@"script" intoString:NULL]) {
                        
                    // Script tag where things don't need escaping!
                    [scanner scanUpToString:@"</script>" intoString:NULL];
                    [scanner scanString:@"</script>" intoString:NULL];
                        
                } else {
                        
                    // Tag - remove and replace with space unless it's
                    // a closing inline tag then dont replace with a space
                    if ([scanner scanString:@"/" intoString:NULL]) {
                            
                        // Closing tag - replace with space unless it's inline
                        tagName = nil; dontReplaceTagWithSpace = NO;
                        if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
                            tagName = [tagName lowercaseString];
                            dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                                        [tagName isEqualToString:@"b"] ||
                                                        [tagName isEqualToString:@"i"] ||
                                                        [tagName isEqualToString:@"q"] ||
                                                        [tagName isEqualToString:@"span"] ||
                                                        [tagName isEqualToString:@"em"] ||
                                                        [tagName isEqualToString:@"strong"] ||
                                                        [tagName isEqualToString:@"cite"] ||
                                                        [tagName isEqualToString:@"abbr"] ||
                                                        [tagName isEqualToString:@"acronym"] ||
                                                        [tagName isEqualToString:@"label"]);
                        }
                            
                        // Replace tag with string unless it was an inline
                        if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                        
                    }
                    
                    // Scan past tag
                    [scanner scanUpToString:@">" intoString:NULL];
                    [scanner scanString:@">" intoString:NULL];
                        
                }
                    
            } else {
                    
                // Stopped at whitespace - replace all whitespace and newlines with a space
                if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
                    if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
                }
                    
            }
                
        } while (![scanner isAtEnd]);
        
        return images;
    }
}

#pragma mark HTML Handler

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(void) feedParserDidFinish:(MWFeedParser *)parser{
    if(self.delegate){
        [self.delegate itemsDownloaded:self.feedItems];
    }
}

-(void) feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error
{
    
}

@end
