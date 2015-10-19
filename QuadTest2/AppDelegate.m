//
//  AppDelegate.m
//  QuadTest2
//
//  Created by A on 6/30/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Push notification delegate methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
    //const void *devTokenBytes = [devToken bytes];
    
    NSLog(@"My token is: %@", devToken);
    
    NSString *strDeviceToken = [[NSString alloc]initWithFormat:@"%@",
                                [[[devToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                    stringByReplacingOccurrencesOfString:@" " withString:@""]];

    [self sendProviderDeviceToken:strDeviceToken];
    NSLog(@"Did Register for Remote Notifications with Device Token (%@)", devToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

#pragma mark - APNs Registration

NSString *token;

- (void)sendProviderDeviceToken:(NSString *)data {
    /*NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];
    NSString *nonce = [NSString stringWithFormat:@"%@", [self randomStringWithLength:20]];
    token = data;
    
    NSString *post = [NSString stringWithFormat:@"token=%@&os=%@&oauth_consumer_key=%@&oauth_timestamp=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_version=%@&oauth_signature=%@",
                      data,
                      @"iOS",
                      @"ck_71d8939a436019ca3b169c65d192689c",
                      time,
                      nonce,
                      @"HMAC-SHA1",
                      @"1.0",
                      [self genOAuthSignatureWithString:[NSString stringWithFormat:@"POST&http://www.shpquad.org/pnfw/register/&%@",
                                                              [NSString stringWithFormat:@"oauth_consumer_key=%@&oauth_timestamp=%@&oauth_nonce=%@&oauth_signature_method=%@&oauth_version=%@&os=%@&token=%@",
                                                               @"ck_71d8939a436019ca3b169c65d192689c",
                                                               time,
                                                               nonce,
                                                               @"HMAC-SHA1",
                                                               @"1.0",
                                                               @"iOS",
                                                               data]]]];*/
    
    
    NSString *post = [NSString stringWithFormat:@"token=%@&os=%@",data,@"iOS"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://www.shpquad.org/pnfw/register/"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

#pragma mark - NSURLConnection Delegate Methods

// This method is used to receive the data which we get using post method.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
    NSString *conData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", conData);
}

// This method receives the error report in case of connection is not made to server.
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

// This method is used to process the data after connection has made successfully.
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

/*#pragma mark - Random Generation Methods

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)randomStringWithLength:(int)len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

-(NSString *)genOAuthSignatureWithString:(NSString *)string {
    NSString *key = [NSString stringWithFormat:@"cs_633a2cd4a0f16f0f22eccceab3aced6e&%@", token];
    NSString *data = string;
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData),
           cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *encodedString = [HMAC base64EncodedString];
    
    NSString *escapeEncoded = [self urlEncodedString: encodedString];
    
    return escapeEncoded;
}

-(NSString *)urlEncodedString: (NSString *) baseString
{
    NSString *encoded = (NSString
                          *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (CFStringRef)baseString, NULL, CFSTR(":/?#[]@!$&’()*+,;="),
                                                                    kCFStringEncodingUTF8));
    return encoded; 
}*/

@end
