//
//  APXToggleOptionsViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 4/1/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXToggleOptionsViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>

@interface APXToggleOptionsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *pushToggleSwitcher;
@property (weak, nonatomic) IBOutlet UISwitch *inboxToggleSwitcher;

@end

@implementation APXToggleOptionsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Opt in - out";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateToggels];
}

#pragma mark - UI

- (void)updateToggels
{
    [[Appoxee shared] isPushEnabled:^(NSError *appoxeeError, id data) {
       
        if (!appoxeeError) {
            
            BOOL state = [(NSNumber *)data boolValue];
            
            [self.pushToggleSwitcher setOn:state animated:YES];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    [[Appoxee shared] isInboxEnabled:^(NSError *appoxeeError, id data) {
        
        if (!appoxeeError) {
            
            BOOL state = [(NSNumber *)data boolValue];
            
            [self.inboxToggleSwitcher setOn:state animated:YES];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - IBActions

- (IBAction)pushToggleSwitched:(UISwitch *)sender
{
    [[Appoxee shared] disablePushNotifications:!sender.isOn withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        if (!appoxeeError) {
         
            [self updateToggels];
            
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)inboxToggleSwitched:(UISwitch *)sender
{
    [[Appoxee shared] disableInbox:!sender.isOn withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        if (!appoxeeError) {
            
            [self updateToggels];
        
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
