//
//  CTView.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/1/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "CTColumnView.h"

@interface CTView : UIScrollView<UIScrollViewDelegate>{
    float frameXOffset;
    float frameYOffset;
}

@property (retain, nonatomic) NSArray* images;

@property (retain, nonatomic) NSAttributedString* attString;

@property (retain, nonatomic) NSMutableArray* frames;

-(void)attachImagesWithFrame:(CTFrameRef)f inColumnView:(CTColumnView*)col;

-(void)setAttString:(NSAttributedString *)attString withImages:(NSArray*)imgs;

- (void)buildFrames;

@end
