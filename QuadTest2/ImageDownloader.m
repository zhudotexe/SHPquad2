//
//  ImageDownloader.m
//  QuadTest2
//
//  Created by Andrew Zhu on 7/2/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

- (void)downloadImagesinArray:(NSArray *)array
{
    self.images = [[NSMutableArray alloc]init];
    NSArray *imageArray = array;
    NSLog(@"Image Array: %@", imageArray);
    for (int i =0; i < [imageArray count]; i++) {
        NSLog(@"Downloading Image: %d", i);
        NSURL *imageURL = [imageArray objectAtIndex:i];
        NSLog(@"URL: %@", [imageArray objectAtIndex:i]);
        UIImage *image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:imageURL]];
        NSLog(@"Downloaded Image");
        [self.images addObject:image];
    }
    
    NSLog(@"Images Downloaded");
    
    if(self.delegate){
        [self.delegate imagesDownloaded:self.images];
    }
    
}

@end
