//
//  SimpleTableCell.m
//  QuadTest2
//
//  Created by Andrew Zhu on 7/1/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "SimpleTableCell.h"

@implementation SimpleTableCell
@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize dateLabel = _dateLabel;


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
