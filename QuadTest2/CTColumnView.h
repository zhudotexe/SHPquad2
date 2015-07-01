//
//  CTColumnView.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/1/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CTColumnView : UIView {
    id ctFrame;
    NSMutableArray* images;
}

@property (retain, nonatomic) NSMutableArray* images;

-(void)setCTFrame:(id)f;
@end
