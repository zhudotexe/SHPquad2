//
//  DetailViewController.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "DetailViewController.h"
#import "NSString+HTML.h"
#import "CTView.h"
#import "MarkupParser.h"

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
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"zombies" ofType:@"txt"];
    NSString* text = [self.detailItem content];//[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    MarkupParser* p = [[MarkupParser alloc] init];
    NSAttributedString* attString = [p attrStringFromMarkup: text];
    [self.detailView setAttString:attString];
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


@end
