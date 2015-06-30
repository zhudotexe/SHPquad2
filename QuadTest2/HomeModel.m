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
    feedItem.content = item.content ? item.content : @"This article cannot be displayed in the Quad's mobile app. Sorry!";
    feedItem.date = item.date;
    feedItem.link = item.link ? item.link : @"http://shpquad.org/404";
    
    [self.feedItems addObject:feedItem];
    
}

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
