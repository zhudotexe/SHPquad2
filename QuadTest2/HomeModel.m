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
    self.feedParser = [[FeedParser alloc]init];
    
    //delegate
    self.feedParser.delegate = self;
    
    //do the thing!
    [self.feedParser parseURL:feedURL];
    
    self.feedItems = [[NSMutableArray alloc] init];
}


-(void)didParseItem:(NSDictionary *)item {
    FeedItem *feedItem = [[FeedItem alloc] init];
    feedItem.title = [item valueForKey:@"title"] ? [item valueForKey:@"title"] : @"Untitled";
    feedItem.author = [item valueForKey:@"dc:creator"] ? [item valueForKey:@"dc:creator"] : @"Unknown Author";
    feedItem.images = [self parseImages:[item valueForKey:@"content:encoded"]];
    feedItem.videos = [self parseVideos:[item valueForKey:@"content:encoded"]];
    feedItem.content = [item valueForKey:@"content:encoded"] ? [item valueForKey:@"content:encoded"] : [NSString stringWithFormat:@"This article may not display correctly on the Quad App. Please view this article at %@", [item valueForKey:@"link"]];
    feedItem.date = [item valueForKey:@"pubDate"];
    feedItem.link = [item valueForKey:@"link"] ? [item valueForKey:@"link"] : @"http://shpquad.org/404";
    feedItem.summary = [item valueForKey:@"description"] ? [item valueForKey:@"description"] : @"No summary.";
    feedItem.enclosures = [item valueForKey:@"enclosure"];
    
    //NSLog(@"%@", item.content);
    
    
    [self.feedItems addObject:feedItem];
    
}

#pragma mark Image Handler

- (NSMutableArray *)parseImages:(NSString *)content {
    @autoreleasepool {
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray *videos = [[NSMutableArray alloc] initWithCapacity:1];
            
        // Character sets
        NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", (unichar)0x0085, (unichar)0x000C, (unichar)0x2028, (unichar)0x2029]];
        NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
        
        NSMutableString *result = [[NSMutableString alloc]initWithString:@""];
        NSMutableString *vidhtml = [[NSMutableString alloc]initWithString:@""];
        NSString *html = nil;
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
                        
                } else if ([scanner scanString:@"iframe" intoString:NULL]){
                    
                    //find image url
                    [scanner scanUpToString:@"src=" intoString:NULL];
                    [scanner scanString:@"src=\"" intoString:NULL];
                    //get the actual url
                    [scanner scanUpToString:@"\"" intoString:&url];
                    
                    //add the url to the image array
                    [videos addObject:[[NSURL alloc]initWithString:url]];
                    
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
                    
                    [vidhtml setString:@""];
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

- (NSMutableArray *)parseVideos:(NSString *)content {
    @autoreleasepool {
        NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:5];
        NSMutableArray *videos = [[NSMutableArray alloc] initWithCapacity:1];
        
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
                    
                } else if ([scanner scanString:@"iframe" intoString:NULL]){
                    
                    //find video url
                    [scanner scanUpToString:@"src=" intoString:NULL];
                    [scanner scanString:@"src=\"" intoString:NULL];
                    //get the actual url
                    [scanner scanUpToString:@"\"" intoString:&url];
                    
                    //add the url to the image array
                    [videos addObject:[[NSURL alloc]initWithString:url]];
                    
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
        
        return videos;
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

-(void) didFinishParsing:(NSArray *)items{
    if(self.delegate){
        [self.delegate itemsDownloaded:self.feedItems];
    }
}


@end
