//
//  DetailViewController.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+HTML.h"

@interface DetailViewController (){
    ImageDownloader *_imageDownloader;
    NSArray *_images;
}

@end

@implementation DetailViewController
@synthesize containerView = _containerView;
@synthesize imageProgress = _imageProgress;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _webItem = nil;
        
        // Update the view.
        [self configureView];
    }
}

- (void)setWebItem:(id)newWebItem {
    if (_webItem != newWebItem) {
        _webItem = newWebItem;
        _detailItem = nil;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.

    
    if (self.detailItem) {
        self.detailTitle.title = [self.detailItem title];
        NSString *content = [self flattenHTML:[self.detailItem content]];
        content = [content stringByDecodingHTMLEntities];
        
        if ([[self.detailItem enclosures]count]) {
            //let people start reading article
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 400.0f, 700.0f, 350 - 44)];
            [self.view addSubview:textView];
            
            [textView setEditable:NO];
            [textView setFont:[UIFont systemFontOfSize:18]];
            
            textView.text = content;
            
            //NSLog(@"%@", [self.detailItem enclosures]);
            
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(50.0f, 0.0f, 600.0f, 400.0f)];
            NSURLRequest *webContent = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[[[self.detailItem enclosures]firstObject]valueForKey:@"url"]]];
            [webView loadRequest:webContent];
            //[webView setUserInteractionEnabled:NO];
            
            [self.view addSubview:webView];
        } else if ([[self.detailItem videos]count]) {
            //let people start reading article
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 400.0f, 700.0f, 350 - 44)];
            [self.view addSubview:textView];
            
            [textView setEditable:NO];
            [textView setFont:[UIFont systemFontOfSize:18]];
            
            textView.text = content;
            
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(50.0f, 0.0f, 600.0f, 400.0f)];
            NSURLRequest *webContent = [[NSURLRequest alloc]initWithURL:[[self.detailItem videos]firstObject]];
            [webView loadRequest:webContent];
            //[webView setUserInteractionEnabled:NO];
            
            [self.view addSubview:webView];
                
            /*// set up the scroll view
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 750.0f, 400.0f)];
            [self.view addSubview:scrollView];
            
            [self.view bringSubviewToFront:scrollView];
            
            // Set up the container view to hold your custom view hierarchy
            CGSize containerSize = CGSizeMake(75 + [[self.detailItem videos]count] * 625, 400.0f);
            self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
            [scrollView addSubview:self.containerView];
            
            for (int i = 0; i < [[self.detailItem videos]count]; i++) { // set up an web view for each video at multiples of the video resolution
                UIWebView *tempWebView = [[UIWebView alloc]initWithFrame:CGRectMake(25 + i * 625, 0.0f, 600.0f, 400.0f)];
                NSURLRequest *content = [[NSURLRequest alloc]initWithURL:[[self.detailItem videos]objectAtIndex:i]];
                [tempWebView loadRequest:content];
                [self.containerView addSubview:tempWebView];
            }
            // set attributes of the scrollview
            scrollView.contentSize = containerSize;
            [scrollView setShowsHorizontalScrollIndicator:NO];
            [scrollView setBackgroundColor:[UIColor whiteColor]];*/
            
        } else if ([[self.detailItem images]count]) { // if there is an image, init with an imageview
            
            // placeholder loading image while images load
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading.png"]];
            imageView.frame = CGRectMake(75.0f, 0.0f, 600.0f, 400.0f);
            [self.view addSubview:imageView];
            
            // progress view
            self.imageProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            [self.imageProgress setFrame:CGRectMake(0.0f, 350.0f, 700.0f, 2.0f)];
            self.imageProgress.center = CGPointMake(352.0f, 375.0f);
            [self.imageProgress setProgressTintColor:[UIColor blueColor]];
            [self.view addSubview:self.imageProgress];
            
            //let people start reading article
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 400.0f, 700.0f, 350 - 44)];
            [self.view addSubview:textView];
            
            [textView setEditable:NO];
            [textView setFont:[UIFont systemFontOfSize:18]];
            
            textView.text = content;
            
            [_imageDownloader performSelectorInBackground:@selector(downloadImagesinArray:) withObject:[self.detailItem images]];
            
        } else { // otherwise init without images
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 700.0f, 750 - 44)];
            [self.view addSubview:textView];
            
            [textView setEditable:NO];
            [textView setFont:[UIFont systemFontOfSize:18]];
            
            textView.text = content;
        }
        
    } else if (self.webItem) { // load webview for selected item
        if (self.webItem) {
            self.detailTitle.title = [self.webItem title];
            
            UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 700.0f, 706.0f)];
            NSURLRequest *content = [[NSURLRequest alloc]initWithURL:[self.webItem contentURL]];
            [webView loadRequest:content];
            [self.view addSubview:webView];
        }
    }
}

- (void)imagesDownloaded:(NSArray *)images
{
    if ([images count]) {
        // set up the scroll view
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 750.0f, 400.0f)];
        [self.view addSubview:scrollView];
        
        [self.view bringSubviewToFront:scrollView];
        
        // Set up the container view to hold your custom view hierarchy
        CGSize containerSize = CGSizeMake(75 + [images count] * 625, 400.0f);
        self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
        [scrollView addSubview:self.containerView];
        
        for (int i = 0; i < [images count]; i++) { // set up an image view for each image at multiples of the image resolution
            UIImageView *tempImageView = [[UIImageView alloc]initWithFrame:CGRectMake(25 + i * 625, 0.0f, 600.0f, 400.0f)];
            tempImageView.contentMode = UIViewContentModeScaleAspectFit;
            tempImageView.image = [images objectAtIndex:i];
            [self.containerView addSubview:tempImageView];
        }
        // set attributes of the scrollview
        scrollView.contentSize = containerSize;
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];

    _imageDownloader = [[ImageDownloader alloc] init];
    
    _imageDownloader.delegate = self;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.6784 green:0.0588 blue:0.1137 alpha:1]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Progress Handlers

- (void)updateProgressforImages:(NSNumber *)progress
{
    [self performSelectorOnMainThread: @selector(moveProgressBar:) withObject: progress waitUntilDone: NO];
}

- (void)moveProgressBar:(NSNumber *)progress
{
    [self.imageProgress setProgress:[progress floatValue] animated:YES];
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

- (UIImage *)downloadImage
{
    NSArray *imageArray = [self.detailItem images];
    NSLog(@"Image Array: %@", imageArray);
    NSURL *imageURL = imageArray.firstObject;
    UIImage *image = [[UIImage alloc]initWithData:[[NSData alloc]initWithContentsOfURL:imageURL]];
    //image = [self resizeImage:image withSize:CGSizeMake(600.0f, 400.0f)];
    return image;
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
