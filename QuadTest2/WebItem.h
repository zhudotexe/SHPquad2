//
//  WebItem.h
//  QuadTest2
//
//  Created by Andrew Zhu on 7/4/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebItem : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSURL *contentURL;

+ (id)webItemWithTitle:(NSString *)title andURL:(NSURL *)url;

@end
