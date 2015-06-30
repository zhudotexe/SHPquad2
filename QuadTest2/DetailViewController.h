//
//  DetailViewController.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@interface DetailViewController : UIViewController 

@property (strong, nonatomic) id detailItem;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
//@property (weak, nonatomic) IBOutlet UILabel *makeSelectionLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet UINavigationItem *detailTitle;

@end

