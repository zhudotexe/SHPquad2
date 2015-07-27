//
//  FeedItem.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItem : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,strong) NSMutableArray *videos;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSArray *enclosures;

@end
