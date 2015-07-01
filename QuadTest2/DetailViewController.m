//
//  DetailViewController.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+HTML.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    
    self.detailTitle.title = [self.detailItem title];
    
    if (self.detailItem) {
        NSString *content = [self flattenHTML:[self.detailItem content]];
        
        self.detailTextView.text = [content stringByDecodingHTMLEntities];
        [self imageDownloadStart];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark HTML Flattener

- (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];
    
    html = [html stringByReplacingOccurrencesOfString:@"</br>" withString:@"\n"];
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n\n"];
    
    while ([theScanner isAtEnd] == NO) {
        
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //

    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}


#pragma mark Image Handlin'

-(void)imageDownloadStart
{
    [self performSelectorInBackground:@selector(downloadImage) withObject:nil];
}

- (void)downloadImage
{
    NSArray *imageArray = [self.detailItem images];
    NSLog(@"Image Array: %@", imageArray);
    NSURL *imageURL = imageArray.firstObject;
    UIImage *image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:imageURL]];
    image = [self resizeImage:image withSize:CGSizeMake(600.0f, 400.0f)];
    [self setImage:image];
}

- (void)setImage:(UIImage *)image
{
    self.detailImageView.image = image;
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)newSize
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = newSize.width/newSize.height;
    
    if(imgRatio!=maxRatio)
    {
        if(imgRatio < maxRatio){
            imgRatio = newSize.width / actualHeight;
            actualWidth = round(imgRatio * actualWidth);
            actualHeight = newSize.width;
        }
        else{
            imgRatio = newSize.height / actualWidth;
            actualHeight = round(imgRatio * actualHeight);
            actualWidth = newSize.height;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //[resizedImage release];
    return resizedImage;
}
@end
