//
//  MasterViewController.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HomeModel.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <HomeModelProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)downloadItemsWithTarget:(NSString *)target;

@end

