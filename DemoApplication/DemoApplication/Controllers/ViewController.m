//
//  ViewController.m
//  AppoxeeTestApplicatoin
//
//  Created by Raz Elkayam on 12/28/14.
//  Copyright (c) 2014 Appoxee. All rights reserved.
//

#import "ViewController.h"
#import <AppoxeeSDK/AppoxeeSDK.h>
#import "APXWebViewViewController.h"
#import "APXSchemeViewController.h"

#define IS_OS_LESS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkForUrlScheme) name:@"urlScheme" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self checkForUrlScheme];
}

- (void)checkForUrlScheme
{
    NSString *urlScheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"urlScheme"];
    
    if (urlScheme) {
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"urlScheme"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        
        [self performSegueWithIdentifier:@"APXSchemeViewController" sender:urlScheme];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"APXWebViewViewController"]) {
        
        APXWebViewViewController *webview = (APXWebViewViewController *)segue.destinationViewController;
        [webview setHtml:(NSString *)sender];
        
    } else if ([segue.identifier isEqualToString:@"APXSchemeViewController"]) {
        
        APXSchemeViewController *schemeController = (APXSchemeViewController *)segue.destinationViewController;
        schemeController.urlScheme = (NSString *)sender;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return NUM_OF_ACTIONS;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row) {
            
        case AppoxeeActionTypeToggle:
        {
            cell.textLabel.text = @"Opt In / Out Opt";
        }
            break;
        case AppoxeeActionTypeTags:
        {
            cell.textLabel.text = @"Tags";
        }
            break;
        case AppoxeeActionTypeCustomFields:
        {
            cell.textLabel.text = @"Custom Fields";
        }
            break;
        case AppoxeeActionTypeFeedback:
        {
            cell.textLabel.text = @"Show Feedback";
        }
            break;
        case AppoxeeActionTypeInbox:
        {
            cell.textLabel.text = @"Custom Inbox";
        }
            break;
        case AppoxeeActionTypeAlias:
        {
            cell.textLabel.text = @"Alias";
        }
            break;
        case AppoxeeActionTypeLog:
        {
            cell.textLabel.text = @"Log";
        }
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {

        case AppoxeeActionTypeToggle:
        {
            [self performSegueWithIdentifier:@"showToggle" sender:nil];
        }
            break;
        case AppoxeeActionTypeTags:
        {
            [self performSegueWithIdentifier:@"APXTagsViewController" sender:nil];
        }
            break;
        case AppoxeeActionTypeCustomFields:
        {
            [self performSegueWithIdentifier:@"APXCustomFieldsViewController" sender:nil];
        }
            break;
        case AppoxeeActionTypeFeedback:
        {
            [self.activityIndicator startAnimating];
            [[Appoxee shared] showFeedbackWithCompletionHandler:^(NSError *appoxeeError, id data) {
                
                [self.activityIndicator stopAnimating];
                if (!appoxeeError && [data isKindOfClass:[NSString class]]) {
                    
                    NSString *html = (NSString *)data;
                    
                    [self performSegueWithIdentifier:@"APXWebViewViewController" sender:html];
                    
                } else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Error" message:[appoxeeError description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        }
            break;
        case AppoxeeActionTypeInbox:
        {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                
                if (IS_OS_LESS_8) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Attention" message:@"We can't display a UISplitViewController from an iPad running on iOS7 modally" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                } else {
                    
                    [self.activityIndicator startAnimating];
                    [self performSegueWithIdentifier:@"showCustomInbox" sender:nil];
                    [self.activityIndicator stopAnimating];
                }
                
            } else {
                
                [self.activityIndicator startAnimating];
                [self performSegueWithIdentifier:@"showCustomInbox" sender:nil];
                [self.activityIndicator stopAnimating];
            }
        }
            break;
        case AppoxeeActionTypeAlias:
        {
            [self performSegueWithIdentifier:@"APXAliasViewController" sender:nil];
        }
            break;
        case AppoxeeActionTypeLog:
        {
            [self performSegueWithIdentifier:@"APXLogViewController" sender:nil];
        }
            break;
    }
}

@end
