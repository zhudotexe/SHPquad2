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
    float length = [imageArray count];
    NSLog(@"Image Array: %@", imageArray);
    for (int i = 0; i < [imageArray count]; i++) {
        NSLog(@"Downloading Image: %d", i);
        NSURL *imageURL = [imageArray objectAtIndex:i];
        NSLog(@"URL: %@", [imageArray objectAtIndex:i]);
        UIImage *image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:imageURL]];
        NSLog(@"Downloaded Image");
        if (image) {
            [self.images addObject:image];
            if(self.delegate){
                NSNumber *progress = [[NSNumber alloc]initWithFloat:(i + 1) / length];
                [self.delegate updateProgressforImages:progress];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Connection Error" message:@"Error connecting to server, check internet connection and try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            break;
        }
        
    }
    
    NSLog(@"Images Downloaded");
    
    if(self.delegate){
        [self.delegate imagesDownloaded:self.images];
    }
    
}

@end
