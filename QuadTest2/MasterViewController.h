//
//  MasterViewController.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "ResultsTableController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <HomeModelProtocol, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, strong) UISearchController *searchController;

// our secondary search results table view
@property (nonatomic, strong) ResultsTableController *resultsTableController;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;


- (void)downloadItemsWithTarget:(NSString *)target;

@end

