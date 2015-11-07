//
//  WebItem.m
//  QuadTest2
//
//  Created by Andrew Zhu on 7/4/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "WebItem.h"

@implementation WebItem

+ (id)webItemWithTitle:(NSString *)title andURL:(NSURL *)url
{
    WebItem *newWebItem = [[self alloc]init];
    newWebItem.title = title;
    newWebItem.contentURL = url;
    return newWebItem;
}

@end
