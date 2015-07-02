//
//  DetailViewController.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"
#import "ImageDownloader.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate, ImageDownloaderProtocol>

//@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UINavigationItem *detailTitle;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) UIView *containerView;

@end

