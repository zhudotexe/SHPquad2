//
//  MarkupParser.m
//  QuadTest2
//
//  Created by Andrew Zhu on 7/1/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "MarkupParser.h"

static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@implementation MarkupParser

@synthesize font, color, strokeColor, strokeWidth;
@synthesize images;

-(id)init
{
    self = [super init];
    if (self) {
        self.font = @"ArialMT";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    NSMutableAttributedString* aString =
    [[NSMutableAttributedString alloc] initWithString:@""]; //1
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil]; //2
    NSArray* chunks = [regex matchesInString:markup options:0
                                       range:NSMakeRange(0, [markup length])];
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray* parts = [[markup substringWithRange:b.range]
                          componentsSeparatedByString:@"<"]; //1
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font,
                                                 24.0f, NULL);
        
        //apply the current text style //2
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)self.color.CGColor, kCTForegroundColorAttributeName,
                               (__bridge id)fontRef, kCTFontAttributeName,
                               (id)self.strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                               (id)[NSNumber numberWithFloat: self.strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               nil];
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs]];
        
        CFRelease(fontRef);
        
        //handle new formatting tag //3
        if ([parts count]>1) {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"img"]) {
                
                __block NSNumber* width = [NSNumber numberWithInt:0];
                __block NSNumber* height = [NSNumber numberWithInt:0];
                __block NSString* fileName = @"";
                
                //width
                NSRegularExpression* widthRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL];
                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
                }];
                
                //height
                NSRegularExpression* faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
                }];
                
                //image
                NSRegularExpression* srcRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL];
                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    fileName = [tag substringWithRange: match.range];
                }];
                
                //add the image for drawing
                [self.images addObject:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  width, @"width",
                  height, @"height",
                  fileName, @"fileName",
                  [NSNumber numberWithInt: [aString length]], @"location",
                  nil]
                 ];
                
                //render empty space for drawing the image in the text //1
                CTRunDelegateCallbacks callbacks;
                callbacks.version = kCTRunDelegateVersion1;
                callbacks.getAscent = ascentCallback;
                callbacks.getDescent = descentCallback;
                callbacks.getWidth = widthCallback;
                
                NSDictionary* imgAttr = [NSDictionary dictionaryWithObjectsAndKeys: //2
                                          width, @"width",
                                          height, @"height",
                                          nil];
                
                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(imgAttr)); //3
                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
                                                        //set the delegate
                                                        (__bridge id)delegate, (NSString*)kCTRunDelegateAttributeName,
                                                        nil];
                
                //add a space to the text so that it can call the delegate
                [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate]];
            }
        }
    }
    
    return (NSAttributedString*)aString;
}

-(void)dealloc
{
    self.font = nil;
    self.color = nil;
    self.strokeColor = nil;
    self.images = nil;
}

@end
