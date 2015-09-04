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

@protocol HomeModelProtocol <NSObject>

- (void)itemsDownloaded:(NSArray*)items;

@end


@interface HomeModel : NSObject<FeedParserProtocol>

@property (nonatomic,weak) id<HomeModelProtocol> delegate;
@property (nonatomic,strong) FeedParser *feedParser;
@property (nonatomic,strong) NSMutableArray *feedItems;

- (void) downloadItems;

@end
