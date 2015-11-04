//
//  ResultsTableController.h
//  SHPQuad
//
//  Created by Andrew Zhu on 11/3/15.
//  Copyright © 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"
#import "SimpleTableCell.h"

@interface ResultsTableController : UITableViewController

@property (nonatomic, strong) NSArray *filteredItems;

@end
