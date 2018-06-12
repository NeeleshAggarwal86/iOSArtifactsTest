//
//  APXRichContentViewController.m
//  NewSDKTestApplication
//
//  Created by Raz Elkayam on 5/26/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//

#import "APXRichContentViewController.h"

@interface APXRichContentViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation APXRichContentViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad:(BOOL)animated
{
    [super viewDidLoad];
    
    self.webView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

#pragma mark - UI

- (void)updateUI
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.html]];
    
    [self.webView loadRequest:request];
}

#pragma mark - IBActions

- (IBAction)dismissButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicator stopAnimating];
    
    NSLog(@"Error while loading web view: %@", error);
}

@end
