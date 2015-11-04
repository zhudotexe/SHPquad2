//
//  ResultsTableController.m
//  SHPQuad
//
//  Created by Andrew Zhu on 11/3/15.
//  Copyright © 2015 SHPQuad. All rights reserved.
//

#import "ResultsTableController.h"

@interface ResultsTableController ()

@end

@implementation ResultsTableController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Retrieve cell
    NSString *cellIdentifier = @"SimpleTableCell";
    SimpleTableCell *myCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (myCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil];
        myCell = [nib objectAtIndex:0];
    }
    
    FeedItem *item;
    
    
    item = self.filteredItems[indexPath.row];
    
    
    
    // Get references to labels of cell
    myCell.titleLabel.text = item.title;
    myCell.authorLabel.text = item.author;
    myCell.dateLabel.text = (NSString *)item.date; //[item.date descriptionWithLocale:[NSLocale currentLocale]];
    // TODO: myCell.thumbnailImageView.image = item.
    
    return myCell;

}

@end
