//
//  APXAliasViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 5/10/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXAliasViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>

@interface APXAliasViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *aliasTitleLable;
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation APXAliasViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aliasTextField.delegate = self;
    
    self.title = @"Alias";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAliasAndUpdateUI];
}

#pragma mark - UI

- (void)updateUIWithAlias:(NSString *)alias
{
    self.aliasTextField.text = @"";
    self.aliasTitleLable.text = [NSString stringWithFormat:@"Alias: %@", alias];
}

#pragma mark - IBAction

- (IBAction)setAnAliasButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] setDeviceAlias:self.aliasTextField.text withCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self.activityIndicator stopAnimating];
        
        if (!appoxeeError) {
            
            [self updateUIWithAlias:self.aliasTextField.text];
        
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)removeAliasButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] removeDeviceAliasWithCompletionHandler:^(NSError *appoxeeError, id data) {
       
        [self.activityIndicator stopAnimating];
        
        if (!appoxeeError) {
            
            [self getAliasAndUpdateUI];
        
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (IBAction)clearAliasCache:(id)sender
{
    [self.view endEditing:YES];
    
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] clearAliasCacheWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self.activityIndicator stopAnimating];
        
        if (!appoxeeError) {
            
            [self getAliasAndUpdateUI];
        
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)getAliasAndUpdateUI
{
    [self.activityIndicator startAnimating];
    
    [[Appoxee shared] getDeviceAliasWithCompletionHandler:^(NSError *appoxeeError, id data) {
        
        [self.activityIndicator stopAnimating];
        
        if (!appoxeeError) {
            
            if ([data isKindOfClass:[NSString class]]) {
                
                [self updateUIWithAlias:data];
            }
        
        } else {
            
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end
