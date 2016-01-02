//
//  HomeModel.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedParser.h"
#import "FeedItem.h"
#import "NSDate+DateTools.h"

@protocol HomeModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray*)items;
- (void)itemsDownloaded:(NSArray *)items withTarget:(NSString *)target;

@end


@interface HomeModel : NSObject<FeedParserProtocol>

@property (nonatomic,weak) id<HomeModelProtocol> delegate;
@property (nonatomic,strong) FeedParser *feedParser;
@property (nonatomic,strong) NSMutableArray *feedItems;
@property (nonatomic,strong) NSString *target;

- (void) downloadItems;

- (void)downloadItemsWithTarget:(NSString *)target;

@end
