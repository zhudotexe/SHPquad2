//
//  SettingsViewController.m
//  QuadTest2
//
//  Created by Andrew Zhu on 9/2/15.
//  Copyright (c) 2015 SHPQuad. All rights reserved.
//

#import "SettingsViewController.h"
#import <MessageUI/MessageUI.h>

@interface SettingsViewController () {
    NSUserDefaults *_defaults;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    
    [self.speedModeSwitch setOn:[_defaults boolForKey:@"SpeedMode"] animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)speedModeChanged:(id)sender {
    if (self.speedModeSwitch.on) {
        //Alert that it's BETA
        //if they say continue, do prefs
        UIAlertController *betaAlert = [UIAlertController
                                        alertControllerWithTitle:@"Beta Warning"
                                        message:@"This feature is in BETA, it may have bugs! Do you want to continue?"
                                        preferredStyle:UIAlertControllerStyleAlert];
        [betaAlert addAction:[UIAlertAction
                              actionWithTitle:@"Yes"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *action){
                                  [_defaults setBool:YES forKey:@"SpeedMode"];
                                  [_defaults synchronize];
                                  // NSLog(@"%@", @"Speed Mode ON");
                              }]];
        [betaAlert addAction:[UIAlertAction
                              actionWithTitle:@"No"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction *action){
                                  [_defaults setBool:NO forKey:@"SpeedMode"];
                                  [self.speedModeSwitch setOn:NO animated:YES];
                                  [_defaults synchronize];
                                  // NSLog(@"%@", @"Speed Mode OFF");
                              }]];
        [self presentViewController:betaAlert animated:YES completion:nil];
    } else {
        [_defaults setBool:NO forKey:@"SpeedMode"];
        [_defaults synchronize];
        // NSLog(@"%@", @"Speed Mode OFF");
    }
}

- (IBAction)sendEmail:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        // mail.mailComposeDelegate = self;
        [mail setSubject:@"Quad Feedback"];
        [mail setMessageBody:@"I have some feedback for the SHP Quad app." isHTML:NO];
        [mail setToRecipients:@[@"shpquad@shschools.org"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
}
#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 // Return the number of sections.
 return 1;
 }*/

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 // Return the number of rows in the section.
 return 1;
 }*/


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
