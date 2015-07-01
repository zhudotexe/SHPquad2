//
//  MarkupParser.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/1/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@interface MarkupParser : NSObject {
    
    NSString* font;
    UIColor* color;
    UIColor* strokeColor;
    float strokeWidth;
    
    NSMutableArray* images;
}

@property (retain, nonatomic) NSString* font;
@property (retain, nonatomic) UIColor* color;
@property (retain, nonatomic) UIColor* strokeColor;
@property (assign, readwrite) float strokeWidth;

@property (retain, nonatomic) NSMutableArray* images;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end
