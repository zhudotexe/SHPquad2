//
//  AppDelegate.h
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "NSData+Base64.h"
#import "MasterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

