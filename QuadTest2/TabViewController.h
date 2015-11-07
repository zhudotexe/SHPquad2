//
//  TabViewController.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/4/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"

@interface TabViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
