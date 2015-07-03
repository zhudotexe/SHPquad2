//
//  ImageDownloader.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/2/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageDownloaderProtocol <NSObject>

- (void)imagesDownloaded:(NSArray*)images;

@end


@interface ImageDownloader : NSObject

@property (nonatomic,weak) id<ImageDownloaderProtocol> delegate;
@property (nonatomic,strong) NSMutableArray *images;

- (void) downloadImagesinArray:(NSArray *)array;

@end